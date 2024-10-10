import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/social_app/social_user_model.dart';
import '../../../../shared/network/local/cache_helper.dart'; // Import CacheHelper
import 'states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }

  // Clear any existing token before registering a new user
  void clearTokenBeforeRegister() async {
    await CacheHelper.removeData(key: 'uId');
  }

  // Register the user using Firebase Authentication
  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    clearTokenBeforeRegister(); // Clear any existing token before registration
    emit(RegisterLoadingState());

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        createUser(
          uId: user.uid,
          name: name,
          email: email,
          phone: phone,
        );

        // Save the new token (user UID) in CacheHelper
        CacheHelper.saveData(key: 'uId', value: user.uid);
      }
    } catch (error) {
      emit(RegisterErrorState(error.toString()));
    }
  }

  void createUser({
    required String uId,
    required String name,
    required String email,
    required String phone,
  }) async {
    SocialUserModel userModel = SocialUserModel(
      uId: uId,
      name: name,
      email: email,
      phone: phone,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance.collection('users').doc(uId).set(userModel.toMap()).then((value) {
      emit(RegisterSuccessState(uId));
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }
}
