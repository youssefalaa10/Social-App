// import 'dart:async';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:social/layout/social_app/cubit/states.dart';
// import 'package:social/models/social_app/social_user_model.dart';
// import 'package:social/models/social_app/post_model.dart';

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import '../../../models/social_app/message_model.dart';
// import '../../../modules/social_app/chats/chats_screen.dart';
// import '../../../modules/social_app/feeds/feeds_screen.dart';
// import '../../../modules/social_app/new_post/new_post_screen.dart';
// import '../../../modules/social_app/settings/settings_screen.dart';
// import '../../../modules/social_app/users/users_screen.dart';


// class SocialCubit extends Cubit<SocialStates> {
//   SocialCubit() : super(SocialInitialState());

//   static SocialCubit get(context) => BlocProvider.of(context);

//   SocialUserModel? userModel;

//   void getUserData() {
//     emit(SocialGetUserLoadingState());
//     FirebaseFirestore.instance.collection('users').doc('uId').get().then((value) {
//       userModel = SocialUserModel.fromJson(value.data()!);
//       emit(SocialGetUserSuccessState());
//     }).catchError((error) {
//       debugPrint('Error fetching user data: $error');
//       emit(SocialGetUserErrorState(error.toString()));
//     });
//   }
//   List<SocialUserModel> users = [];

// void getUsers() {
//   emit(SocialGetAllUsersLoadingState());

//   FirebaseFirestore.instance.collection('users').get().then((value) {
//     users = []; // Reset the list before fetching

//     for (var element in value.docs) {
//       // Ensure not to include the current user in the users list
//       if (element.data()['uId'] != userModel!.uId) {
//         users.add(SocialUserModel.fromJson(element.data()));
//       }
//     }
    
//     emit(SocialGetAllUsersSuccessState());
//   }).catchError((error) {
//     debugPrint('Error getting users: $error');
//     emit(SocialGetAllUsersErrorState(error.toString()));
//   });
// }


//   // Bottom Navigation Management
//   int currentIndex = 0;

//   List<Widget> screens = [
//     const FeedsScreen(),
//     const ChatsScreen(),
//     NewPostScreen(),
//     const UsersScreen(),
//     const SettingsScreen(),
//   ];

//   List<String> titles = [
//     'Home',
//     'Chats',
//     'Post',
//     'Users',
//     'Settings',
//   ];

//   void changeBottomNav(int index) {
//     if (index == 1) getUsers();
//     if (index == 2) {
//       emit(SocialNewPostState());
//     } else {
//       currentIndex = index;
//       emit(SocialChangeBottomNavState());
//     }
//   }

//   // Image Picker and Upload Logic
//   File? profileImage;
//   File? coverImage;
//   File? postImage;
//   final picker = ImagePicker();

//   Future<void> getProfileImage() async {
//     _pickImage((pickedFile) {
//       profileImage = File(pickedFile.path);
//       emit(SocialProfileImagePickedSuccessState());
//     }, SocialProfileImagePickedErrorState());
//   }

//   Future<void> getCoverImage() async {
//     _pickImage((pickedFile) {
//       coverImage = File(pickedFile.path);
//       emit(SocialCoverImagePickedSuccessState());
//     }, SocialCoverImagePickedErrorState());
//   }

//   Future<void> getPostImage() async {
//     _pickImage((pickedFile) {
//       postImage = File(pickedFile.path);
//       emit(SocialPostImagePickedSuccessState());
//     }, SocialPostImagePickedErrorState());
//   }

//   void _pickImage(Function(XFile) onPicked, SocialStates errorState) async {
//     XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       onPicked(pickedFile);
//     } else {
//       debugPrint('No image selected.');
//       emit(errorState);
//     }
//   }

//   // Upload image to Firebase
//   Future<String> _uploadImage({
//     required File image,
//     required String path,
//   }) async {
//     try {
//       var storageRef = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child(path + '/${Uri.file(image.path).pathSegments.last}');
//       await storageRef.putFile(image);
//       return await storageRef.getDownloadURL();
//     } catch (error) {
//       debugPrint('Error uploading image: $error');
//       throw Exception('Image upload failed');
//     }
//   }

//   // Profile Image Upload
//   void uploadProfileImage({
//     required String name,
//     required String phone,
//     required String bio,
//   }) async {
//     if (profileImage != null) {
//       try {
//         emit(SocialUserUpdateLoadingState());
//         String profileImageUrl = await _uploadImage(
//           image: profileImage!,
//           path: 'users/profile_images',
//         );
//         updateUserData(name: name, phone: phone, bio: bio, image: profileImageUrl);
//       } catch (error) {
//         emit(SocialUploadProfileImageErrorState());
//       }
//     }
//   }

//   // Cover Image Upload
//   void uploadCoverImage({
//     required String name,
//     required String phone,
//     required String bio,
//   }) async {
//     if (coverImage != null) {
//       try {
//         emit(SocialUserUpdateLoadingState());
//         String coverImageUrl = await _uploadImage(
//           image: coverImage!,
//           path: 'users/cover_images',
//         );
//         updateUserData(name: name, phone: phone, bio: bio, cover: coverImageUrl);
//       } catch (error) {
//         emit(SocialUploadCoverImageErrorState());
//       }
//     }
//   }

//   // Update User Data in Firebase
//   void updateUserData({
//     required String name,
//     required String phone,
//     required String bio,
//     String? cover,
//     String? image,
//   }) {
//     SocialUserModel model = SocialUserModel(
//       name: name,
//       phone: phone,
//       bio: bio,
//       email: userModel!.email,
//       cover: cover ?? userModel!.cover,
//       image: image ?? userModel!.image,
//       uId: userModel!.uId,
//       isEmailVerified: false,
//     );

//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(userModel!.uId)
//         .update(model.toMap())
//         .then((_) => getUserData())
//         .catchError((error) {
//       debugPrint('Error updating user data: $error');
//       emit(SocialUserUpdateErrorState());
//     });
//   }

//   // Post Handling
//   void removePostImage() {
//     postImage = null;
//     emit(SocialRemovePostImageState());
//   }

//   void uploadPostImage({
//     required String dataTime,
//     required String text,
//   }) async {
//     emit(SocialCreatePostLoadingState());

//     if (postImage != null) {
//       try {
//         String postImageUrl = await _uploadImage(
//           image: postImage!,
//           path: 'posts',
//         );
//         createPost(
//           text: text,
//           dataTime: dataTime,
//           postImage: postImageUrl,
//         );
//       } catch (error) {
//         emit(SocialCreatePostErrorState());
//       }
//     }
//   }

//   void createPost({
//     required String dataTime,
//     required String text,
//     String? postImage,
//   }) {
//     emit(SocialCreatePostLoadingState());

//     PostModel model = PostModel(
//       name: userModel?.name ?? 'Unknown',
//       image: userModel?.image ?? '',
//       uId: userModel!.uId,
//       dataTime: dataTime,
//       text: text,
//       postImage: postImage ?? '',
//     );

//     FirebaseFirestore.instance
//         .collection('posts')
//         .add(model.toMap())
//         .then((_) => emit(SocialCreatePostSuccessState()))
//         .catchError((error) {
//       emit(SocialCreatePostErrorState());
//     });
//   }

//   // Fetch Posts
//   List<PostModel> posts = [];
//   List<String> postsId = [];
//   List<int> likes = [];

//   void getPost() {
//     FirebaseFirestore.instance.collection('posts').get().then((value) {
//       for (var element in value.docs) {
//         element.reference.collection('likes').get().then((value) {
//           likes.add(value.docs.length);
//           postsId.add(element.id);
//           posts.add(PostModel.fromJson(element.data()));
//         }).catchError((error) {
//           debugPrint('Error fetching likes: $error');
//         });
//       }
//       emit(SocialGetPostsSuccessState());
//     }).catchError((error) {
//       emit(SocialGetPostsErrorState(error.toString()));
//     });
//   }

//   // Likes Management
//   final StreamController<List<PostModel>> _postsController = StreamController<List<PostModel>>.broadcast();

//   Stream<List<PostModel>> get postsStream => _postsController.stream;

//   void toggleLikePost(String postId) {
//     var postReference = FirebaseFirestore.instance
//         .collection('posts')
//         .doc(postId)
//         .collection('likes')
//         .doc(userModel!.uId);

//     postReference.get().then((doc) {
//       if (doc.exists) {
//         postReference.delete().then((_) {
//           _updatePostLikes(postId, -1);
//           emit(SocialUnlikePostSuccessState());
//         }).catchError((error) {
//           emit(SocialUnlikePostErrorState(error.toString()));
//         });
//       } else {
//         postReference.set({'like': true}).then((_) {
//           _updatePostLikes(postId, 1);
//           emit(SocialLikePostSuccessState());
//         }).catchError((error) {
//           emit(SocialLikePostErrorState(error.toString()));
//         });
//       }
//     }).catchError((error) {
//       emit(SocialLikePostErrorState(error.toString()));
//     });
//   }

//   void _updatePostLikes(String postId, int change) {
//     int index = postsId.indexOf(postId);
//     if (index != -1) {
//       likes[index] += change;
//       _postsController.add(posts);
//     }
//   }

//   // Delete Post
//   void deletePost(String postId) {
//     FirebaseFirestore.instance
//         .collection('posts')
//         .doc(postId)
//         .delete()
//         .then((_) => emit(SocialDeletePostSuccessState()))
//         .catchError((error) {
//       emit(SocialDeletePostErrorState(error.toString()));
//     });
//   }

//   // Edit Post
//   void editPost(String postId, String newContent) async {
//     emit(SocialEditPostLoadingState());
//     try {
//       await FirebaseFirestore.instance.collection('posts').doc(postId).update({'content': newContent});
//       emit(SocialEditPostSuccessState());
//     } catch (error) {
//       emit(SocialEditPostErrorState(error.toString()));
//     }
//   }

//   // Dispose StreamController
//   @override
//   Future<void> close() {
//     _postsController.close();
//     return super.close();
//   }

//   List<MessageModel> messages = [];

// void getMessages({
//   required String receiverId,
// }) {
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(userModel!.uId)
//       .collection('chats')
//       .doc(receiverId)
//       .collection('messages')
//       .orderBy('dateTime')
//       .snapshots()
//       .listen((event) {
//     messages = []; // Clear the list before populating it
//     for (var element in event.docs) {
//       messages.add(MessageModel.fromJson(element.data()));
//     }
//     emit(SocialGetMessagesSuccessState());
//   });
// }

//   void sendMessage({
//     required String receiverId,
//     required String dateTime,
//     required String text,
//   }) {
//     MessageModel messageModel = MessageModel(
//       text: text,
//       senderId: userModel!.uId,
//       receiverId: receiverId,
//       dateTime: dateTime,
//     );

//     // Set the message in the sender's chat collection
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(userModel!.uId)
//         .collection('chats')
//         .doc(receiverId)
//         .collection('messages')
//         .add(messageModel.toMap())
//         .then((value) {
//       emit(SocialSendMessageSuccessState());
//     }).catchError((error) {
//       emit(SocialSendMessageErrorState());
//     });

//     // Set the message in the receiver's chat collection
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(receiverId)
//         .collection('chats')
//         .doc(userModel!.uId)
//         .collection('messages')
//         .add(messageModel.toMap())
//         .then((value) {
//       emit(SocialSendMessageSuccessState());
//     }).catchError((error) {
//       emit(SocialSendMessageErrorState());
//     });
//   }

// }
