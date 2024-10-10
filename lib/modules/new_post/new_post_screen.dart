import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/icon_broken.dart';
import 'cubit/posts_cubit.dart';
import 'cubit/posts_state.dart';

class NewPostScreen extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  final String userId;

  NewPostScreen({super.key, required this.userId});

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
        var cubit = PostCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
            actions: [
              defaultTextButton(
                function: () {
                  if (textController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post content cannot be empty')),
                    );
                    return;
                  }
                  final now = DateTime.now();
                  if (cubit.postImage == null) {
                    cubit.createPost(
                      dateTime: now.toString(),
                      text: textController.text,
                      name: cubit.userModel!.name,
                      uId: cubit.userModel!.uId,
                      image: cubit.userModel!.image,
                    );
                  } else {
                    cubit.uploadPostImage(
                      dateTime: now.toString(),
                      text: textController.text,
                      name: cubit.userModel!.name,
                      uId: cubit.userModel!.uId,
                      image: cubit.userModel!.image,
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
                      backgroundImage: NetworkImage(
                        'https://img.freepik.com/free-photo/pretty-smiling-joyfully-female-with-fair-hair-dressed-casually-looking-with-satisfaction_176420-15187.jpg?w=996&t=st=1665531661~exp=1665532261~hmac=11fd387eee878ce97f048ca33c4d86f1a5c0c29f5092933c0632cf80a8d85d12',
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: Text(
                        cubit.userModel!.name,
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
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
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
                          cubit.removePostImage();
                        },
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
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
                        onPressed: () {},
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
