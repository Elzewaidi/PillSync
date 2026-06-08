import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? birthDate,
    String? imageUrl,
    required String currentToken,
    required User currentUser,
  });

  Future<Either<Failure, String>> uploadProfileImage({required File imageFile});
}
