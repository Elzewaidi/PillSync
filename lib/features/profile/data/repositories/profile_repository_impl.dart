import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:pillsync/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pillsync/features/auth/data/models/user_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/imgbb_remote_data_source.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/update_profile_request_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final ImgbbRemoteDataSource _imgbbDataSource;
  final NetworkInfo _networkInfo;
  final AuthLocalDataSource _authLocalDataSource;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
    required ImgbbRemoteDataSource imgbbDataSource,
    required NetworkInfo networkInfo,
    required AuthLocalDataSource authLocalDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _imgbbDataSource = imgbbDataSource,
       _networkInfo = networkInfo,
       _authLocalDataSource = authLocalDataSource;

  @override
  Future<Either<Failure, User>> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? birthDate,
    String? imageUrl,
    required String currentToken,
    required User currentUser,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final request = UpdateProfileRequestModel(
        fullName: fullName,
        emailAddress: currentUser.emailAddress,
        phoneNumber: phoneNumber,
        birthDate: birthDate,
        imageUrl: imageUrl,
      );
      final profileModel = await _remoteDataSource.updateProfile(
        request,
        token: currentToken,
      );
     
      // Use the birthDate the user submitted if the server doesn't return it
      final resolvedBirthDate =
          profileModel.birthDate ?? birthDate ?? currentUser.birthDate;

      // Calculate age from birthDate
      int? calculatedAge;
      if (resolvedBirthDate != null && resolvedBirthDate.isNotEmpty) {
        try {
          final dob = DateTime.parse(resolvedBirthDate);
          final today = DateTime.now();
          calculatedAge = today.year - dob.year;
          if (today.month < dob.month ||
              (today.month == dob.month && today.day < dob.day)) {
            calculatedAge--;
          }
        } catch (_) {}
      }

      final updatedUser = currentUser.copyWith(
        fullName: profileModel.fullName,
        phoneNumber: profileModel.phoneNumber,
        birthDate: resolvedBirthDate,
        age: calculatedAge ?? profileModel.age ?? currentUser.age,
        imageUrl: imageUrl ?? profileModel.imageUrl ?? currentUser.imageUrl,
      );

      // Persist birthDate in its own box so it survives logout/clearCache
      if (updatedUser.birthDate != null && updatedUser.birthDate!.isNotEmpty) {
        await _authLocalDataSource.saveBirthDate(
            currentUser.userId, updatedUser.birthDate!);
      }

      await _localDataSource.cacheProfile(profileModel);
      await _authLocalDataSource.updateCachedUser(
        UserModel(
          userIdField: updatedUser.userId,
          emailAddressField: updatedUser.emailAddress,
          fullNameField: updatedUser.fullName,
          imageUrlField: updatedUser.imageUrl,
          isVerifiedField: currentUser.isVerified,
          tokenField: currentUser.token,
          phoneNumberField: updatedUser.phoneNumber,
          ageField: updatedUser.age,
          birthDateField: updatedUser.birthDate,
        ),
      );

      return Right(updatedUser);
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
  Future<Either<Failure, String>> uploadProfileImage({
    required File imageFile,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final imageUrl = await _imgbbDataSource.uploadImage(imageFile);
      return Right(imageUrl);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
