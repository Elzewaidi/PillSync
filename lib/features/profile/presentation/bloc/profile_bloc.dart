import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_profile_image.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfile _updateProfile;
  final UploadProfileImage _uploadProfileImage;

  ProfileBloc({
    required UpdateProfile updateProfile,
    required UploadProfileImage uploadProfileImage,
  }) : _updateProfile = updateProfile,
       _uploadProfileImage = uploadProfileImage,
       super(const ProfileInitial()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<UploadProfileImageRequested>(_onUploadProfileImageRequested);
    on<ClearMessages>(_onClearMessages);
  }

  Future<void> _onUploadProfileImageRequested(
    UploadProfileImageRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileImageUploading());

    final result = await _uploadProfileImage(
      UploadProfileImageParams(imageFile: event.imageFile),
    );

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (imageUrl) => emit(ProfileImageUploaded(imageUrl)),
    );
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {

    if (event.currentUser == null) {
      emit(const ProfileError('User data not available'));
      return;
    }

    emit(const ProfileLoading());

    final result = await _updateProfile(
      UpdateProfileParams(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        birthDate: event.birthDate,
        imageUrl: event.imageUrl,
        currentUser: event.currentUser!,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (updatedUser) => emit(ProfileUpdated(updatedUser)),
    );
  }

  void _onClearMessages(ClearMessages event, Emitter<ProfileState> emit) {
    if (state is ProfileError) {
      emit(const ProfileInitial());
    }
  }
}
