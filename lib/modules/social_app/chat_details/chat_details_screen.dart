import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_app/cubit/cubit.dart';
import 'package:social/layout/social_app/cubit/states.dart';
import 'package:social/models/social_app/message_model.dart';
import 'package:social/models/social_app/social_user_model.dart';
import 'package:social/shared/styles/colors.dart';

import '../../../shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  final SocialUserModel? userModel;

  ChatDetailsScreen({
    super.key,
    this.userModel,
  });

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: userModel!.uId,);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        userModel!.image,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(userModel!.name),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: SocialCubit.get(context).messages.isNotEmpty,
                builder:(context)=> Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                            itemBuilder: (context,index){
                              var message = SocialCubit.get(context).messages[index];
                                if (SocialCubit.get(context).userModel!.uId == message.senderId) {
                                  return buildMyMessage(message);
                                } return buildMyMessage(message);
                            },
                            separatorBuilder: (context,index)=> const SizedBox(
                              height: 15.0,
                            ),
                            itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white70,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message here ...',
                                ),
                              ),
                            ),
                            Container(
                              height: 40.0,
                              color: defaultColor,
                              child: MaterialButton(
                                onPressed: () {
                                  SocialCubit.get(context).sendMessage(
                                    receiverId: userModel!.uId,
                                    dateTime: DateTime.now().toString(),
                                    text: messageController.text,
                                  );
                                },
                                minWidth: 1.0,
                                child: const Icon(
                                  IconBroken.send,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context)=>const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      }
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
              bottomEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child:  Text(
            model.text,
          ),
        ),
      );

  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(
              .2,
            ),
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
              bottomStart: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child:  Text(
          model.text,
          ),
        ),
      );
}
