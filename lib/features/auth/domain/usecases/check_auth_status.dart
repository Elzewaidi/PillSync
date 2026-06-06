import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatus implements UseCase<User?, NoParams> {
  final AuthRepository _repository;

  CheckAuthStatus(this._repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await _repository.checkAuthStatus();
  }
}
