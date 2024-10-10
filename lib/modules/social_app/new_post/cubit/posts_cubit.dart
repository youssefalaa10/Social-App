import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/social_app/post_model.dart';
import '../../../../models/social_app/social_user_model.dart'; // Include the user model
import 'posts_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  static PostCubit get(context) => BlocProvider.of(context);

  List<PostModel> posts = [];
  SocialUserModel? userModel; // Add userModel to store the current user's data
  File? postImage;
  final picker = ImagePicker();

  // Fetch user data from Firestore based on userId
  void getUserData(String uId) {
    emit(PostLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!); // Initialize userModel
      emit(PostSuccessState());
    }).catchError((error) {
      emit(PostErrorState(error.toString()));
    });
  }

  // Fetch all posts from Firestore
  void getPosts() {
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
  void createPost({
    required String text,
    required String dateTime,
    String? postImageUrl,
    required String name,
    required String uId,
    required String image,
  }) {
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
  void uploadPostImage({
    required String text,
    required String dateTime,
    required String name,
    required String uId,
    required String image,
  }) {
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

  // Toggle like post (needs Firestore integration)
  void toggleLikePost(String postId) {
    // Implement Firestore like logic
    emit(PostLikedState());
  }

  // Delete a post with confirmation
  void deletePost(String postId) {
    FirebaseFirestore.instance.collection('posts').doc(postId).delete().then((value) {
      emit(PostDeleteSuccessState());
      getPosts(); // Refresh posts after deletion
    }).catchError((error) {
      emit(PostDeleteErrorState(error.toString()));
    });
  }
}
