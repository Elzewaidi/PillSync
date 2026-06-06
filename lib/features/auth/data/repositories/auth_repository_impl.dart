import 'package:dartz/dartz.dart';
import 'package:pillsync/features/profile/data/datasources/profile_local_data_source.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final ProfileLocalDataSource _profileLocalDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required ProfileLocalDataSource profileLocalDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo,
       _profileLocalDataSource = profileLocalDataSource;

  @override
Future<Either<Failure, User>> login({
  required String email,
  required String password,
}) async {
  if (!await _networkInfo.isConnected) {
    return const Left(NetworkFailure('No internet connection'));
  }

  try {
    final request = LoginRequestModel(
      emailAddress: email,
      password: password,
    );

    final userModel = await _remoteDataSource.login(request);

    final cachedUser = await _localDataSource.getCachedUser();

    // Server never returns birthDate — read from our persistent store keyed by userId
    final storedBirthDate = await _localDataSource.getBirthDate(userModel.userId);
    final resolvedBirthDate = storedBirthDate ?? cachedUser?.birthDate;

    // Phone: prefer server value, fall back to cache
    final resolvedPhone =
        (userModel.phoneNumber != null && userModel.phoneNumber!.isNotEmpty)
            ? userModel.phoneNumber
            : cachedUser?.phoneNumber;

    final userWithImage = userModel.copyWith(
      imageUrl: userModel.imageUrl ?? cachedUser?.imageUrl,
      birthDate: resolvedBirthDate,
      phoneNumber: resolvedPhone,
      age: _calcAge(resolvedBirthDate),
    );

    await _localDataSource.cacheUser(userWithImage);
    await _localDataSource.cacheToken(userWithImage.token);

    return Right(userWithImage);
  } on UnauthorizedException catch (e) {
    return Left(UnauthorizedFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

  @override
  Future<Either<Failure, User>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String? phoneNumber,
    String? birthDate,
  }) async {
    if (password != confirmPassword) {
      return const Left(InvalidInputFailure('Passwords do not match'));
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final request = RegisterRequestModel(
        fullName: fullName,
        emailAddress: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        birthDate: birthDate,
      );

      final userModel = await _remoteDataSource.register(request);

      // Server doesn't return birthDate — use what the user submitted
      final resolvedBirthDate =
          (userModel.birthDate != null && userModel.birthDate!.isNotEmpty)
              ? userModel.birthDate
              : birthDate;

      // Persist birthDate independently so it survives logout
      if (resolvedBirthDate != null && resolvedBirthDate.isNotEmpty) {
        await _localDataSource.saveBirthDate(userModel.userId, resolvedBirthDate);
      }

      final userWithData = userModel.copyWith(
        birthDate: resolvedBirthDate,
        age: _calcAge(resolvedBirthDate),
      );

      await _localDataSource.cacheUser(userWithData);
      await _localDataSource.cacheToken(userWithData.token);

      return Right(userWithData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendOTP(
    String emailAddress, {
    String? token,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.sendOTP(emailAddress, token: token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOTP({
    required String email,
    required String otpCode,
    required bool requiresAuth,
    String? token,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await _remoteDataSource.verifyOTP(
        email,
        otpCode,
        token: token,
        requiresAuth: requiresAuth,
      );

      if (result) {
        final cachedUser = await _localDataSource.getCachedUser();
        if (cachedUser != null) {
          final verifiedUser = cachedUser.copyWith(isVerified: true);

          await _localDataSource.cacheUser(verifiedUser);
        }
      }

      return Right(result);
    } on OTPException catch (e) {
      return Left(OTPFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        otpCode: otpCode,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      await _localDataSource.clearCache();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearCache();
      await _profileLocalDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    try {
      final token = await _localDataSource.getCachedToken();
      if (token == null || token.isEmpty) return const Right(null);

      final user = await _localDataSource.getCachedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword(String email) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.forgetPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  /// Calculate age from an ISO date string. Returns null if unparseable.
  int? _calcAge(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return null;
    try {
      final dob = DateTime.parse(birthDate);
      final today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return null;
    }
  }
}