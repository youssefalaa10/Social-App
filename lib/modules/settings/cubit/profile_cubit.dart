import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


import '../../../models/user_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;
  File? profileImage;
  File? coverImage;
  final ImagePicker picker = ImagePicker();

  // Fetch user data
  void getUserData(String uId) {
    emit(ProfileLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(ProfileSuccessState());
    }).catchError((error) {
      emit(ProfileErrorState(error.toString()));
    });
  }

  // Image Picking Logic
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(CoverImagePickedSuccessState());
    } else {
      emit(CoverImagePickedErrorState());
    }
  }

  // Upload profile and cover images
  Future<String> _uploadImage(File image, String path) async {
    var storageRef = FirebaseStorage.instance
        .ref()
        .child(path + '/${Uri.file(image.path).pathSegments.last}');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  // Update Profile Image
  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
    required String uId,
  }) async {
    if (profileImage != null) {
      String profileImageUrl = await _uploadImage(profileImage!, 'users/profile');
      updateUser(uId: uId, name: name, phone: phone, bio: bio, profileImage: profileImageUrl);
    }
  }

  // Update Cover Image
  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
    required String uId,
  }) async {
    if (coverImage != null) {
      String coverImageUrl = await _uploadImage(coverImage!, 'users/cover');
      updateUser(uId: uId, name: name, phone: phone, bio: bio, coverImage: coverImageUrl);
    }
  }

  // Update User Data
  void updateUser({
    required String uId,
    required String name,
    required String phone,
    required String bio,
    String? profileImage,
    String? coverImage,
  }) {
    emit(ProfileLoadingState());

    SocialUserModel updatedModel = SocialUserModel(
      uId: userModel!.uId,
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      image: profileImage ?? userModel!.image,
      cover: coverImage ?? userModel!.cover,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(updatedModel.toMap())
        .then((value) {
      getUserData(uId);
    }).catchError((error) {
      emit(ProfileErrorState(error.toString()));
    });
  }
}
