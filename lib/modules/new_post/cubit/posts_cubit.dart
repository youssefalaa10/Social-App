import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import 'posts_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  static PostCubit get(context) => BlocProvider.of(context);

  List<PostModel> posts = [];
  SocialUserModel? userModel =SocialUserModel(name: 'sss', email: 'email', phone: 'phone', uId: 'uId', image: 'assets/images/profile.jpeg', cover: 'assets/images/profile.jpeg') ;
  File? postImage;
  final picker = ImagePicker();




  // Fetch all posts from Firestore
  Future<void> getPosts() async {
    emit(PostLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      posts = [];
      for (var element in value.docs) {
        posts.add(PostModel.fromJson(element.data(), element.id)); // Use element.id for postId
      }
      emit(PostSuccessState());
    }).catchError((error) {
      emit(PostErrorState(error.toString()));
    });
  }

  // Create a new post
  Future<void> createPost({
    required String text,
    required String dateTime,
    String? postImageUrl,
    required String name,
    required String uId,
    required String image,
  }) async {
    PostModel postModel = PostModel(
      postId: '', // Firestore will generate the ID, so we pass an empty string initially
      name: name,
      uId: uId,
      image: image,
      text: text,
      dataTime: dateTime,
      postImage: postImageUrl ?? '',
    );

    FirebaseFirestore.instance.collection('posts').add(postModel.toMap()).then((value) {
      emit(PostSuccessState());
      getPosts(); // Refresh the posts after creating a new one
    }).catchError((error) {
      emit(PostErrorState(error.toString()));
    });
  }

  // Upload post image to Firebase Storage
  Future<void> uploadPostImage({
    required String text,
    required String dateTime,
    required String name,
    required String uId,
    required String image,
  }) async {
    if (postImage == null) {
      emit(PostImagePickedErrorState('No image selected'));
      return;
    }

    emit(PostLoadingState());

    FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        createPost(
          text: text,
          dateTime: dateTime,
          postImageUrl: imageUrl,
          name: name,
          uId: uId,
          image: image,
        );
      }).catchError((error) {
        emit(PostErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(PostErrorState(error.toString()));
    });
  }

  // Pick post image from gallery
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      emit(PostImagePickedErrorState('No image selected'));
    }
  }

  // Remove selected post image
  void removePostImage() {
    postImage = null;
    emit(PostImageRemovedState());
  }

  // Toggle like post (Firestore integration)
  Future<void> toggleLikePost(String postId) async {
    try {
      DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

      // Perform a transaction to avoid concurrency issues with likes
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          emit(PostErrorState('Post does not exist'));
          return;
        }

        List<dynamic> likes = postSnapshot['likes'] ?? [];
        String currentUserId = userModel!.uId;

        if (likes.contains(currentUserId)) {
          transaction.update(postRef, {'likes': FieldValue.arrayRemove([currentUserId])});
        } else {
          transaction.update(postRef, {'likes': FieldValue.arrayUnion([currentUserId])});
        }
      });

      emit(PostLikedState());
    } catch (error) {
      emit(PostErrorState(error.toString()));
    }
  }

  // Delete a post with confirmation
  Future<void> deletePost(String postId) async {
    FirebaseFirestore.instance.collection('posts').doc(postId).delete().then((value) {
      emit(PostDeleteSuccessState());
      getPosts(); // Refresh posts after deletion
    }).catchError((error) {
      emit(PostDeleteErrorState(error.toString()));
    });
  }
}
