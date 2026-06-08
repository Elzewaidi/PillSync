import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPassword implements UseCase<void, ResetPasswordParams> {
  final AuthRepository _repository;
  ResetPassword(this._repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await _repository.resetPassword(
      email: params.email,
      otpCode: params.otpCode,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String email;
  final String otpCode;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordParams({
    required this.email,
    required this.otpCode,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, otpCode, newPassword, confirmPassword];
}
