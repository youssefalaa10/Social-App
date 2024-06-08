import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_app/cubit/cubit.dart';
import 'package:social/layout/social_app/cubit/states.dart';

import '../../models/social_app/comment_model.dart';

class CommentScreen extends StatelessWidget {
  final String postId;

  CommentScreen({super.key, required this.postId});
  List<CommentModel>? comments;

  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Comments'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => buildCommentItem(comments![index],context),
                  separatorBuilder: (context, index) => const SizedBox(height: 10.0),
                  itemCount: comments!.length,
                ),
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
                        // SocialCubit.get(context).commentOnPost(postId, commentController.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCommentItem(CommentModel comment,context) {

    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(comment.image),
        ),
        const SizedBox(width: 15.0),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.name,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(comment.text),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // SocialCubit.get(context).deleteComment(postId, comment.commentId);
          },
        ),
      ],
    ),
  );
  }
}
