import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgetPassword implements UseCase<void, ForgetPasswordParams> {
  final AuthRepository _repository;

  ForgetPassword(this._repository);

  @override
  Future<Either<Failure, void>> call(ForgetPasswordParams params) async {
    return await _repository.forgetPassword(params.email);
  }
}

class ForgetPasswordParams extends Equatable {
  final String email;

  const ForgetPasswordParams({required this.email});

  @override
  List<Object> get props => [email];
}
