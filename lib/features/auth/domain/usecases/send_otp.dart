import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOTP implements UseCase<void, SendOTPParams> {
  final AuthRepository _repository;

  SendOTP(this._repository);

  @override
Future<Either<Failure, void>> call(SendOTPParams params) async {
  return await _repository.sendOTP(
    params.email,
    token: params.token, 
  );
}
}

class SendOTPParams extends Equatable {
  final String email;
  final String? token;
  const SendOTPParams({required this.email, this.token});

  @override
  List<Object> get props => [email];
}
