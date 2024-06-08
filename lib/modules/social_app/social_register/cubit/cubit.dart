
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/models/social_app/social_user_model.dart';
import 'package:social/modules/social_app/social_register/cubit/states.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
          uId: value.user!.uid,
          name: name,
          email: email,
          phone: phone,
      );
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate(
      {
        required String name,
        required String email,
        required String phone,
        required String uId,
      })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write your bio ...',
      cover: 'https://img.freepik.com/free-photo/young-female-university-graduate-academic-cap-sitting-table-smiling-pointing-left-future-lawyer-engineer-showing-idea_176420-14245.jpg?t=st=1665624261~exp=1665624861~hmac=86af3b0b236e67d57afb80c65bf4d5e393c12c61db4d499b64d37662e4547767',
      image: 'https://img.freepik.com/free-photo/emotional-happy-young-caucasian-female-with-fair-hair-dressed-blue-clothes-giving-her-thumbs-up-showing-how-good-product-is-pretty-girl-smiling-brodly-with-teeth-gestures-body-language_176420-13493.jpg?w=996&t=st=1665624261~exp=1665624861~hmac=c2e8dd9edb250228040758684c6da56ce023057980545c662c617ba6389b2ecd',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialRegisterChangePasswordVisibilityState());
  }
}
