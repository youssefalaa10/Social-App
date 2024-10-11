import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social/modules/settings/cubit/profile_cubit.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/icon_broken.dart';
import 'cubit/posts_cubit.dart';
import 'cubit/posts_state.dart';

class NewPostScreen extends StatefulWidget {
  final String userId;

  const NewPostScreen({super.key, required this.userId});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController textController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch the user data when the screen initializes
    ProfileCubit.get(context).getUserData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostSuccessState) {
          // Stop loading and pop back to the previous screen (FeedScreen)
          setState(() {
            isLoading = false;
          });
         

          // Show success snackbar after popping back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post Created Successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is PostErrorState) {
          // Stop loading and show error snackbar
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is PostLoadingState) {
          // Set loading to true when the post is being created
          setState(() {
            isLoading = true;
          });
        }
      },
      builder: (context, state) {
        var profileCubit = ProfileCubit.get(context).userModel;

        if (profileCubit == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
            actions: [
              defaultTextButton(
                function: () {
                  if (textController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Post content cannot be empty')),
                    );
                    return;
                  }

                  final now = DateTime.now();

                  if (PostCubit.get(context).postImage == null) {
                    PostCubit.get(context).createPost(
                      dateTime: now.toString(),
                      text: textController.text,
                      name: profileCubit.name,
                      uId: profileCubit.uId,
                      image: profileCubit.image,
                    );
                  } else {
                    PostCubit.get(context).uploadPostImage(
                      dateTime: now.toString(),
                      text: textController.text,
                      name: profileCubit.name,
                      uId: profileCubit.uId,
                      image: profileCubit.image,
                    );
                  }
                },
                text: 'Post',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (isLoading) const LinearProgressIndicator(),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(profileCubit.image),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: Text(
                        profileCubit.name,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'What is on your mind ... ',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                if (PostCubit.get(context).postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: FileImage(PostCubit.get(context).postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const CircleAvatar(
                          radius: 20.0,
                          child: Icon(Icons.close, size: 16.0),
                        ),
                        onPressed: () {
                          PostCubit.get(context).removePostImage();
                        },
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          PostCubit.get(context).getPostImage();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.image),
                            SizedBox(width: 5.0),
                            Text('Add Photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Tags logic here
                        },
                        child: const Text('# Tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
