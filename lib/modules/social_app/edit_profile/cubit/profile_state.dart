abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String error;
  ProfileErrorState(this.error);
}

class ProfileImagePickedSuccessState extends ProfileState {}

class ProfileImagePickedErrorState extends ProfileState {}

class CoverImagePickedSuccessState extends ProfileState {}

class CoverImagePickedErrorState extends ProfileState {}
