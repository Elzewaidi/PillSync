import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register implements UseCase<User, RegisterParams> {
  final AuthRepository _repository;

  Register(this._repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await _repository.register(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
      phoneNumber: params.phoneNumber,
      birthDate: params.birthDate,
    );
  }
}

class RegisterParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phoneNumber;
  final String? birthDate;

  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phoneNumber,
    this.birthDate,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    password,
    confirmPassword,
    phoneNumber,
    birthDate,
  ];
}
