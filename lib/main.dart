import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_app/cubit/cubit.dart';
import 'package:social/layout/social_app/social_layout.dart';
import 'package:social/modules/social_app/social_login/social_login_screen.dart';
import 'package:social/shared/bloc_observer.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/cubit/cubit.dart';
import 'package:social/shared/cubit/states.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/styles/themes.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  showToast(text: 'on message background', state: ToastStates.success);
}
void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var token = FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((event) {
      showToast(text: 'on message', state: ToastStates.success);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast(text: 'on message opened app', state: ToastStates.success);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  // DioHelper.init();
  await CacheHelper.init();

  // bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

//social app
  uId = CacheHelper.getData(key: 'uId');

  //social app

  if (uId != null) {
    widget = const SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(
    // isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // constructor
  // build
  final bool? isDark;
  final Widget? startWidget;

  const MyApp({
    super.key,
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getUserData()
            ..getPost(),
            // ..getPost(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
