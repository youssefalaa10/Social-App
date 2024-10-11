import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social/shared/bloc_observer.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/styles/themes.dart';

import 'modules/Auth/login/login_screen.dart';
import 'modules/chats/cubit/messages_cubit.dart';
import 'modules/layout/layout_screen.dart';
import 'modules/new_post/cubit/posts_cubit.dart';
import 'modules/settings/cubit/profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();

  Bloc.observer = MyBlocObserver();

  String? uId = CacheHelper.getData(key: 'uId');

  Widget startWidget;
  if (uId != null) {
    
    startWidget = LayoutScreen(userId: uId); // Pass the userId to LayoutScreen
  } else {
    startWidget = LoginScreen();
  }

  runApp(MyApp(startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PostCubit()..getPosts()),
        BlocProvider(create: (context) => MessageCubit()..getUsers()),
        BlocProvider(
            create: (context) =>
                ProfileCubit()..getUserData(CacheHelper.getData(key: 'uId'))),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
