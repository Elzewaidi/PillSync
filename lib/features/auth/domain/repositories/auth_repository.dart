import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String? phoneNumber,
    String? birthDate,
  });

  Future<Either<Failure, void>> sendOTP(String emailAddress, {String? token});

  Future<Either<Failure, bool>> verifyOTP({
    required String email,
    required String otpCode,
     String? token, required bool requiresAuth,
  });

 Future<Either<Failure, void>> resetPassword({
  required String email,
  required String otpCode,
  required String newPassword,
  required String confirmPassword,
  
});

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User?>> checkAuthStatus();

  Future<Either<Failure, void>> forgetPassword(String email);
}
