import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyOTPParams extends Equatable {
  final String email;
  final String otpCode;
  final String? token;
  final bool requiresAuth;

  const VerifyOTPParams({
    required this.email,
    required this.otpCode,
    this.token,
    this.requiresAuth = true,
  });

  @override
  List<Object?> get props => [email, otpCode, token, requiresAuth];
}

class VerifyOTP implements UseCase<bool, VerifyOTPParams> {
  final AuthRepository _repository;
  VerifyOTP(this._repository);

  @override
  Future<Either<Failure, bool>> call(VerifyOTPParams params) async {
    return await _repository.verifyOTP(
      email: params.email,
      otpCode: params.otpCode,
      token: params.token,
      requiresAuth: params.requiresAuth, 
    );
  }
}
