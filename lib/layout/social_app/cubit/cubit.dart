import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/layout/social_app/cubit/states.dart';
import 'package:social/models/social_app/social_user_model.dart';
import 'package:social/modules/social_app/chats/chats_screen.dart';
import 'package:social/modules/social_app/feeds/feeds_screen.dart';
import 'package:social/modules/social_app/new_post/new_post_screen.dart';
import 'package:social/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../models/social_app/message_model.dart';
import '../../../models/social_app/post_model.dart';
import '../../../modules/social_app/settings/settings_screen.dart';
import '../../../modules/social_app/users/users_screen.dart';


class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //debugPrint(value.data());
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1) getUsers();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref() //يدخل جوا firebase
        .child(
        'users/${Uri.file(profileImage!.path).pathSegments.last}') //يتحرك ازاي و يسمي
        .putFile(profileImage!) //يرفع
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadProfileImageErrorState());
        updateUserData(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialProfileImagePickedErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref() //يدخل جوا firebase
        .child(
        'users/${Uri.file(coverImage!.path).pathSegments.last}') //يتحرك ازاي و يسمي
        .putFile(coverImage!) //يرفع
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadCoverImageSuccessState());
        updateUserData(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialCoverImagePickedErrorState());
    });
  }

  // void updateUserImages({
  //   required String name,
  //   required String phone,
  //   required String bio,
  // }) {
  //   emit(SocialUserUpdateLoadingState());
  //   if (coverImage != null) {
  //     uploadCoverImage();
  //   } else if (profileImage != null) {
  //     uploadProfileImage();
  //   } else if (coverImage != null && profileImage != null) {
  //   } else {
  //     updateUserData(
  //         name: name,
  //         phone: phone,
  //         bio: bio
  //     );
  //   }
  // }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
      uId: userModel!.uId,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dataTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref() //يدخل جوا firebase
        .child(
        'posts/${Uri.file(postImage!.path).pathSegments.last}') //يتحرك ازاي و يسمي
        .putFile(postImage!) //يرفع
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        createPost(
          text: text,
          dataTime: dataTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostSuccessState());
    });
  }

  void createPost(
      {required String dataTime, required String text, String? postImage}) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel?.name??'name',
      image: userModel?.image??'',
      uId: userModel!.uId,
      dataTime: dataTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap()) //add Make doc & create fake Id
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPost() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      }
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  // void likePost(String postId) {
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('likes')
  //       .doc(userModel!.uId)
  //       .set({
  //     'like': true,
  //   }).then((value) {
  //     emit(SocialLikePostSuccessState());
  //   }).catchError((error) {
  //     emit(SocialLikePostErrorState(error.toString()));
  //   });
  // }

  List<SocialUserModel> users = [];

  void getUsers() {
    users = [];
    //if(users.length == 0)
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != userModel!.uId) {
          users.add(SocialUserModel.fromJson(element.data()));
        }
      }
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  })
  {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );
    // set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error)
    {
      emit(SocialSendMessageErrorState());
    });

    //set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error)
    {
      emit(SocialSendMessageErrorState());
    });
  }
  List<MessageModel> messages = [];
  void getMessages({
    required String receiverId,
  }){
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages =[];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessagesSuccessState());
    });
  }
  //-----------------------------------------------------------------------
  final StreamController<List<PostModel>> _postsController = StreamController<List<PostModel>>.broadcast();

  Stream<List<PostModel>> get postsStream => _postsController.stream;
  void toggleLikePost(String postId) {
    var postReference = FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(userModel!.uId);
    postReference.get().then((doc) {
      if (doc.exists) {
        postReference.delete().then((value) {
          _updatePostLikes(postId, -1);
          emit(SocialUnlikePostSuccessState());
        }).catchError((error) {
          emit(SocialUnlikePostErrorState(error.toString()));
        });
      } else {
        postReference.set({'like': true}).then((value) {
          _updatePostLikes(postId, 1);
          emit(SocialLikePostSuccessState());
        }).catchError((error) {
          emit(SocialLikePostErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void _updatePostLikes(String postId, int change) {
    int index = postsId.indexOf(postId);
    if (index != -1) {
      likes[index] += change;
      _postsController.add(posts);
    }
  }
  //--
  void deletePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      emit(SocialDeletePostSuccessState());
      // Handle post deletion success
    })
        .catchError((error) {
      emit(SocialDeletePostErrorState(error.toString()));
      // Handle post deletion error
    });
  }

  void editPost(String postId, String newContent) async {
    emit(SocialEditPostLoadingState());
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({'content': newContent});
      emit(SocialEditPostSuccessState());
    } catch (error) {
      print("Error editing post: $error");
      emit(SocialEditPostErrorState(error.toString()));
    }
  }

//-----------------------------------------------------------------------
}
