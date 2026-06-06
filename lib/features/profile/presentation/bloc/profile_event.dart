import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  final String fullName;
  final String? phoneNumber;
  final String? birthDate;
  final String? imageUrl;
  final User? currentUser;

  const UpdateProfileRequested({
    required this.fullName,
    this.phoneNumber,
    this.birthDate,
    this.imageUrl,
    this.currentUser,
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


class UploadProfileImageRequested extends ProfileEvent {
  final File imageFile;

  const UploadProfileImageRequested({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}


class ClearMessages extends ProfileEvent {
  const ClearMessages();
}
