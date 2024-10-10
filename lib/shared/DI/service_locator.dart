import 'package:get_it/get_it.dart';

import '../../modules/chats/cubit/messages_cubit.dart';
import '../../modules/comments/cubit/comments_cubit.dart';
import '../../modules/new_post/cubit/posts_cubit.dart';
import '../../modules/settings/cubit/profile_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton(() => PostCubit());
  getIt.registerLazySingleton(() => MessageCubit());
  getIt.registerLazySingleton(() => ProfileCubit());
  getIt.registerLazySingleton(() => CommentCubit());
}
