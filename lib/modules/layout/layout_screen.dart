import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/styles/icon_broken.dart';
import '../chats/chats_screen.dart';
import '../feeds/feeds_screen.dart';
import '../new_post/new_post_screen.dart';
import '../settings/settings_screen.dart';
import '../users/users_screen.dart';
import '../new_post/cubit/posts_cubit.dart';
import '../chats/cubit/messages_cubit.dart';
import '../settings/cubit/profile_cubit.dart';

class LayoutCubit extends Cubit<int> {
  final String userId;

  LayoutCubit(this.userId) : super(0);

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  // Modified screens method to use context from the widget tree
  List<Widget> getScreens(BuildContext context) => [
        BlocProvider.value(
          value: BlocProvider.of<PostCubit>(context),
          child: const FeedsScreen(),
        ),
        BlocProvider.value(
          value: BlocProvider.of<MessageCubit>(context),
          child: const ChatsScreen(),
        ),
        BlocProvider.value(
          value: BlocProvider.of<PostCubit>(context),
          child: NewPostScreen(userId: userId),
        ),
        const UsersScreen(),
        BlocProvider.value(
          value: BlocProvider.of<ProfileCubit>(context),
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
                  ),
            body: cubit.getScreens(context)[cubit.currentIndex], // Use getScreens method to pass context
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
