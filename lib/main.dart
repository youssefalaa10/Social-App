import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/bloc_observer.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/styles/themes.dart';


import 'layout/social_app/social_layout.dart';
import 'modules/social_app/social_login/social_login_screen.dart';
import 'shared/DI/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  
  // Initialize GetIt
  setupGetIt();  // Call the setup function to register dependencies

  Bloc.observer = MyBlocObserver();

  String? uId = CacheHelper.getData(key: 'uId');
  
  Widget startWidget;
  if (uId != null) {
    startWidget = LayoutScreen(userId: uId);  // Pass the userId to LayoutScreen
  } else {
    startWidget = SocialLoginScreen();
  }

  runApp(MyApp(startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: startWidget,
    );
  }
}
