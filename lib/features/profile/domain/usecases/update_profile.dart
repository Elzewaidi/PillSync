import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile implements UseCase<User, UpdateProfileParams> {
  final ProfileRepository _repository;

  UpdateProfile(this._repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await _repository.updateProfile(
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
      birthDate: params.birthDate,
      imageUrl: params.imageUrl,
      currentToken: params.currentUser.token,
      currentUser: params.currentUser,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String fullName;
  final String? phoneNumber;
  final String? birthDate;
  final String? imageUrl;
  final User currentUser;

  const UpdateProfileParams({
    required this.fullName,
    required this.currentUser,
    this.phoneNumber,
    this.birthDate,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    fullName,
    phoneNumber,
    birthDate,
    imageUrl,
    currentUser,
  ];
}
