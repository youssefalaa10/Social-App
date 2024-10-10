import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/models/social_app/message_model.dart';
import 'package:social/models/social_app/social_user_model.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';
import '../chats/cubit/messages_cubit.dart';
import '../chats/cubit/messages_state.dart';

class ChatDetailsScreen extends StatelessWidget {
  final SocialUserModel? userModel;

  ChatDetailsScreen({super.key, this.userModel});

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // Fetch messages when the screen is built
        MessageCubit.get(context).getMessages(receiverId: userModel!.uId);
        return BlocConsumer<MessageCubit, MessageState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: buildAppBarTitle(context),
              ),
              body: ConditionalBuilder(
                condition: MessageCubit.get(context).messages.isNotEmpty,
                builder: (context) => buildChatContent(context),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundImage: NetworkImage(userModel!.image),
        ),
        const SizedBox(width: 15.0),
        Text(userModel!.name),
      ],
    );
  }

  Widget buildChatContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var message = MessageCubit.get(context).messages[index];
                if (MessageCubit.get(context).userModel!.uId == message.senderId) {
                  return buildMyMessage(message);
                }
                return buildMessage(message);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 15.0),
              itemCount: MessageCubit.get(context).messages.length,
            ),
          ),
          buildMessageInput(context),
        ],
      ),
    );
  }

  Widget buildMessageInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70, width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: messageController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type your message here...',
              ),
            ),
          ),
          Container(
            height: 40.0,
            color: defaultColor,
            child: MaterialButton(
              onPressed: () {
                if (messageController.text.trim().isNotEmpty) {
                  MessageCubit.get(context).sendMessage(
                    receiverId: userModel!.uId,
                    dateTime: DateTime.now().toString(),
                    text: messageController.text,
                  );
                  messageController.clear();
                }
              },
              minWidth: 1.0,
              child: const Icon(IconBroken.send, size: 16.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              bottomEnd: Radius.circular(10.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Text(model.text ?? ''),
        ),
      );

  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.2),
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              bottomStart: Radius.circular(10.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Text(model.text ?? ''),
        ),
      );
}
