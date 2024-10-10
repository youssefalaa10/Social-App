import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/styles/icon_broken.dart';
import '../../modules/social_app/chats/chats_screen.dart';
import '../../modules/social_app/chats/cubit/messages_cubit.dart';
import '../../modules/social_app/edit_profile/cubit/profile_cubit.dart';
import '../../modules/social_app/feeds/feeds_screen.dart';
import '../../modules/social_app/new_post/cubit/posts_cubit.dart';
import '../../modules/social_app/new_post/new_post_screen.dart';
import '../../modules/social_app/settings/settings_screen.dart';
import '../../modules/social_app/users/users_screen.dart';

class LayoutCubit extends Cubit<int> {
  final String userId; // Add userId as a parameter

  LayoutCubit(this.userId) : super(0); // Corrected constructor

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> get screens => [
    BlocProvider(create: (context) => PostCubit()..getPosts(), child: const FeedsScreen()),  // Home feed screen
    BlocProvider(create: (context) => MessageCubit(), child: const ChatsScreen()),  // Chat screen
    BlocProvider(create: (context) => PostCubit(), child: NewPostScreen(userId: userId)),  // New post creation screen
    const UsersScreen(),  // Users screen
    BlocProvider(
      create: (context) => ProfileCubit()..getUserData(userId),
      child: SettingsScreen(),
    ),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Create Post',  // Title for NewPostScreen
    'Users',
    'Settings',
  ];

  // Handle bottom navigation
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(currentIndex);  // Emit the new screen index
  }
}

class LayoutScreen extends StatelessWidget {
  final String userId;

  const LayoutScreen({super.key, required this.userId});  // Accept userId as a parameter

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(userId),  // Pass userId to LayoutCubit
      child: BlocConsumer<LayoutCubit, int>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),  // Show the title of the current screen
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
            body: cubit.screens[cubit.currentIndex],  // Display the current screen
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,  // Highlight the current tab
              onTap: (index) {
                cubit.changeBottomNav(index);  // Change the screen when the tab is selected
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
