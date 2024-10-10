abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final String? uId;
  RegisterSuccessState(this.uId);
}

class RegisterErrorState extends RegisterState {
  final String error;
  RegisterErrorState(this.error);
}

class ChangePasswordVisibilityState extends RegisterState {}  // Added state for password visibility toggle
