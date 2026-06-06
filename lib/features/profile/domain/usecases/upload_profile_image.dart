import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class UploadProfileImage implements UseCase<String, UploadProfileImageParams> {
  final ProfileRepository _repository;

  UploadProfileImage(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileImageParams params) async {
    return await _repository.uploadProfileImage(imageFile: params.imageFile);
  }
}

class UploadProfileImageParams extends Equatable {
  final File imageFile;

  const UploadProfileImageParams({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}
