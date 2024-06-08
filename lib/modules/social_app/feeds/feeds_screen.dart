import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_app/cubit/cubit.dart';
import 'package:social/layout/social_app/cubit/states.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

import '../../../models/social_app/post_model.dart';

class FeedsScreen extends StatelessWidget {

  const FeedsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.isNotEmpty && SocialCubit.get(context).userModel != null ,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5.0,
                  margin: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      const Image(
                        image: NetworkImage(
                          'https://img.freepik.com/free-photo/happy-young-caucasian-female-wearing-blue-long-sleeved-shirt-making-thumb-up-sign_176420-15015.jpg?w=996&t=st=1665531631~exp=1665532231~hmac=5001e18427e37fc7c9e438a348fc4156cf962878e50e6d7bbf8a0007f340a6fd',
                        ),
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'communicate with friends',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildPostItem(SocialCubit.get(context).posts[index],context, index),
                  separatorBuilder: (context,index) => const SizedBox(
                    height: 8.0,
                  ),
                  itemCount: SocialCubit.get(context).posts.length,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(PostModel model, context, index) {
    var cubit = SocialCubit.get(context);
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    model.image,
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            model.name,
                            style: const TextStyle(
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 16.0,
                          ),
                        ],
                      ),
                      Text(
                        model.dataTime,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                //++++++++++++++++++++++++++
                // IconButton(
                //   icon: const Icon(
                //     Icons.more_horiz,
                //     size: 16.0,
                //   ),
                //   onPressed: () {},
                // ),
                //++++++++++++++++++++++++++++
                //------------------------------
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16.0,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditPostDialog(context, cubit, model);
                      // Handle edit action
                    } else if (value == 'delete') {
                      // Handle delete action
                      cubit.deletePost(cubit.postsId[index]);
                    }
                  },
                ),
                //-------------------------------
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Text(
              model.text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
                top: 5.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 6.0,
                      ),
                      child: SizedBox(
                        height: 25.0,
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: 1.0,
                          padding: EdgeInsets.zero,
                          child: Text(
                            '#software',
                            style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: defaultColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 6.0,
                      ),
                      child: SizedBox(
                        height: 25.0,
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: 1.0,
                          padding: EdgeInsets.zero,
                          child: Text(
                            '#flutter',
                            style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: defaultColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(model.postImage != '')
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 15.0,
                ),
                child: Container(
                  height: 140.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4.0,
                    ),
                    image:  DecorationImage(
                      image: NetworkImage(
                        model.image,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.heart,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${SocialCubit.get(context).likes[index]}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconBroken.chat,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '0 comment',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage(
                            SocialCubit.get(context).userModel!.image,
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'write a comment ...',
                          style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.heart,
                        size: 16.0,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  onTap: ()
                  {
                    cubit.toggleLikePost(cubit.postsId[index]);
                    // SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//--------------------------------------------------------------------------
void _showEditPostDialog(BuildContext context, SocialCubit cubit, PostModel post) {
  var contentController = TextEditingController(text: post.text);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Post'),
        content: TextField(
          controller: contentController,
          decoration: const InputDecoration(hintText: 'Enter new content'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cubit.editPost(post.uId, contentController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}