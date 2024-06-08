import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_app/cubit/cubit.dart';
import 'package:social/layout/social_app/cubit/states.dart';
import 'package:social/modules/social_app/new_post/new_post_screen.dart';
import 'package:social/shared/components/components.dart';

import '../../shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state)
      {
        if(state is SocialNewPostState)
          {
            navigateTo(context, NewPostScreen(),);
          }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  IconBroken.notification,
                ),
                onPressed: (){},
              ),
              IconButton(
                icon: const Icon(
                  IconBroken.search,
                ),
                onPressed: (){},
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
                icon: Icon(
                  IconBroken.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.chat,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.paperUpload,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.location,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
