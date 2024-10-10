import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:social/shared/components/components.dart';

import '../../models/user_model.dart';
import 'chat_details_screen.dart';
import 'cubit/messages_cubit.dart';
import 'cubit/messages_state.dart';

final getIt = GetIt.instance;

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = getIt<MessageCubit>(); // Retrieve MessageCubit from get_it

    return BlocConsumer<MessageCubit, MessageState>(
      listener: (context, state) {
        if (state is MessageErrorState) {
          // Handle errors if necessary
          print("Error loading users: ${state.error}");
        }
      },
      builder: (context, state) {
        // Ensure to load users if not already loaded
        if (cubit.users.isEmpty) {
          cubit.getUsers(); // Fetch users when the screen is built
        }

        return Scaffold(
         
          body: ConditionalBuilder(
            condition: cubit.users.isNotEmpty || state is! MessageLoadingState,
            builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildChatItem(cubit.users[index], context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: cubit.users.length,
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
        onTap: () {
          // Navigate to chat details when a user is clicked
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: getIt<MessageCubit>(),
                child: ChatDetailsScreen(userModel: model),
              ),
            ),
          );
     
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
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
              Text(
                model.name,
                style: const TextStyle(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
}
