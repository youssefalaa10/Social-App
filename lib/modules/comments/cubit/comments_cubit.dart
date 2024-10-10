import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/comment_model.dart';
import '../../../models/user_model.dart';
import 'comments_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  static CommentCubit get(context) => BlocProvider.of(context);

  List<CommentModel> comments = [];
  SocialUserModel? userModel; // Add user data (e.g., fetched from Firestore)

  void loadComments(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen((snapshot) {
      comments = snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .toList();
      emit(CommentSuccessState()); // Emit success when comments are loaded
    });
  }

  void addComment({
    required String postId,
    required String comment,
    required String dateTime,
    required String name,
    required String image,
  }) {
    CommentModel model = CommentModel(
      name: name,
      image: image,
      text: comment,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      emit(CommentSuccessState()); // Emit success when comment is added
    }).catchError((error) {
      emit(CommentErrorState(error.toString())); // Emit error state if there's an error
    });
  }

  // Optionally, you can add a deleteComment method to handle comment deletion
}
