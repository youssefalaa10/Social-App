import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/settings/cubit/profile_cubit.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/icon_broken.dart';
import 'cubit/posts_cubit.dart';
import 'cubit/posts_state.dart';

class NewPostScreen extends StatefulWidget {
  final String userId;

  NewPostScreen({super.key, required this.userId});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController textController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post Created Successfully!')),
          );
          Navigator.pop(context);
        } else if (state is PostErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        var cubit = ProfileCubit.get(context).userModel;
    

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

                  if (cubit!.image.isEmpty) {
                    PostCubit.get(context).createPost(
                      dateTime: now.toString(),
                      text: textController.text,
                      name: cubit.name,
                      uId: cubit.uId,
                      image: cubit.image,
                    ).then(
                      (value) {
                        Navigator.pop(context);
                      },
                    );
                  
                  } else {
                    PostCubit.get(context).uploadPostImage(
                      dateTime: now.toString(),
                      text: textController.text,
                      name: cubit.name,
                      uId: cubit.uId,
                      image: cubit.image,
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
                if (state is PostLoadingState) const LinearProgressIndicator(),
                Row(
                  children: [
                    CircleAvatar(
                        radius: 25.0,
                        // backgroundImage: AssetImage('assets/images/profile.jpeg')),
                        backgroundImage: NetworkImage(cubit!.image)),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: Text(
                        cubit.name,
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
                if (cubit.image == '')
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            // image: AssetImage('assets/images/profile.jpeg'),
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
