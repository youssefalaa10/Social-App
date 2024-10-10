import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:social/shared/styles/icon_broken.dart';
import '../../../models/social_app/post_model.dart';
import '../new_post/cubit/posts_cubit.dart';
import '../new_post/cubit/posts_state.dart';

final getIt = GetIt.instance;

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  void initState() {
    super.initState();
    getIt<PostCubit>().getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = getIt<PostCubit>();

        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeaderCard(context),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildPostItem(cubit.posts[index], context, index),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemCount: cubit.posts.length,
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          const Image(
            image: NetworkImage(
              'https://img.freepik.com/free-photo/happy-young-caucasian-female-wearing-blue-long-sleeved-shirt-making-thumb-up-sign_176420-15015.jpg',
            ),
            fit: BoxFit.cover,
            height: 200.0,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Communicate with friends',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPostItem(PostModel model, BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(model, context, index),
            const SizedBox(height: 10.0),
            Text(model.text ?? '',
                style: Theme.of(context).textTheme.titleMedium),
            if (model.postImage != null && model.postImage!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 15.0),
                child: Container(
                  height: 140.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      image: NetworkImage(model.postImage ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            _buildLikeCommentRow(context, index),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(PostModel model, BuildContext context, int index) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(model.image ?? ''),
        ),
        const SizedBox(width: 15.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.name, style: const TextStyle(height: 1.4)),
              Text(model.dataTime ?? '',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_horiz, size: 16.0),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _confirmDeletePost(context, model.postId);
            }
          },
        ),
      ],
    );
  }

  Widget _buildLikeCommentRow(BuildContext context, int index) {
    var cubit = PostCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              child: Row(
                children: [
                  const Icon(IconBroken.heart, size: 16.0, color: Colors.red),
                  const SizedBox(width: 5.0),
                  Text(
                    'Like', // Replace with actual like count if available
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              onTap: () {
                cubit.toggleLikePost(cubit.posts[index].postId);
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(IconBroken.chat, size: 16.0, color: Colors.amber),
                  const SizedBox(width: 5.0),
                  Text('0 comments',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall), // Placeholder for dynamic comments
                ],
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePost(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                PostCubit.get(context).deletePost(postId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
