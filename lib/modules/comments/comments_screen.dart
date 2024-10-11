import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




import '../../models/comment_model.dart';
import 'cubit/comments_cubit.dart';
import 'cubit/comments_state.dart';


class CommentScreen extends StatelessWidget {
  final String postId;
  final TextEditingController commentController = TextEditingController();

  CommentScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CommentCubit()..loadComments(postId),
      child: BlocConsumer<CommentCubit, CommentState>(
        listener: (context, state) {
          if (state is CommentSuccessState) {
            commentController.clear(); // Clear the input after successfully posting the comment
          } else if (state is CommentErrorState) {
            // Show error if any
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          var cubit = CommentCubit(); 
          var comments = cubit.comments;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Comments'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: comments.isNotEmpty
                      ? ListView.separated(
                          itemBuilder: (context, index) =>
                              buildCommentItem(comments[index], context),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10.0),
                          itemCount: comments.length,
                        )
                      : const Center(child: Text('No comments yet')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'Write a comment...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {
                            cubit.addComment(
                              postId: postId,
                              comment: commentController.text,
                              dateTime: DateTime.now().toString(),
                              name: cubit.userModel!.name,
                              image: cubit.userModel!.image,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCommentItem(CommentModel comment, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(comment.image!),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.name!,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(comment.text!),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implement delete comment logic if needed
              // cubit.deleteComment(postId, comment.commentId);
            },
          ),
        ],
      ),
    );
  }
}
