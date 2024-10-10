abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentSuccessState extends CommentState {}

class CommentErrorState extends CommentState {
  final String error;
  CommentErrorState(this.error);
}
