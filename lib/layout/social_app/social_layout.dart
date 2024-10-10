import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/styles/icon_broken.dart';
import '../../modules/social_app/chats/chats_screen.dart';

import '../../modules/social_app/feeds/feeds_screen.dart';
import '../../modules/social_app/new_post/new_post_screen.dart';
import '../../modules/social_app/settings/settings_screen.dart';
import '../../modules/social_app/users/users_screen.dart';
import 'package:get_it/get_it.dart';
import '../../modules/social_app/chats/cubit/messages_cubit.dart';
import '../../modules/social_app/new_post/cubit/posts_cubit.dart';
import '../../modules/social_app/edit_profile/cubit/profile_cubit.dart';

final getIt = GetIt.instance;

class LayoutCubit extends Cubit<int> {
  final String userId;

  LayoutCubit(this.userId) : super(0);

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> get screens => [
        // Using GetIt to provide cubits
        BlocProvider.value(
          value: getIt<PostCubit>()..getPosts(),
          child: const FeedsScreen(),
        ),
        BlocProvider.value(
          value: getIt<MessageCubit>(),
          child: const ChatsScreen(),
        ),
        BlocProvider.value(
          value: getIt<PostCubit>(),
          child: NewPostScreen(userId: userId),
        ),
        const UsersScreen(),
        BlocProvider.value(
          value: getIt<ProfileCubit>()..getUserData(userId),
          child: const SettingsScreen(),
        ),
      ];

  List<String> titles = [
    'Home',
    'Chats',
    'Create Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(currentIndex);
  }
}

class LayoutScreen extends StatelessWidget {
  final String userId;

  const LayoutScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(userId),
      child: BlocConsumer<LayoutCubit, int>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);

          return Scaffold(
            appBar: cubit.currentIndex == 2
                ? null // No AppBar for Create Post screen
                : AppBar(
                    title: Text(cubit.titles[cubit.currentIndex]),
                    actions: [
                      IconButton(
                        icon: const Icon(IconBroken.notification),
                        onPressed: () {
                          // Add actions for notifications
                        },
                      ),
                      IconButton(
                        icon: const Icon(IconBroken.search),
                        onPressed: () {
                          // Add actions for search
                        },
                      ),
                    ],
                  ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.chat),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.paperUpload),
                  label: 'Post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.location),
                  label: 'Users',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.setting),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
