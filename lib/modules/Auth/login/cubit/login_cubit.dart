import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/Auth/login/cubit/login_states.dart';
import '../../../../shared/network/local/cache_helper.dart';


class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitial());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialChangePasswordVisibilityState());
  }

  // Clear any existing token before login
  void clearTokenBeforeLogin() async {
    await CacheHelper.removeData(key: 'uId');
  }

  // User login method with Firebase Authentication
  void userLogin({
    required String email,
    required String password,
  }) async {
    clearTokenBeforeLogin(); // Clear any existing token before login
    emit(SocialLoginLoadingState());

    try {
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save the new token (user UID) in CacheHelper
      CacheHelper.saveData(key: 'uId', value: user.user?.uid);

      emit(SocialLoginSuccessState(user.user?.uid));
    } catch (error) {
      emit(SocialLoginErrorState(error.toString()));
    }
  }
}
