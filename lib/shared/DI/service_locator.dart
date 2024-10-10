import 'package:get_it/get_it.dart';
import 'package:social/modules/social_app/chats/cubit/messages_cubit.dart';
import 'package:social/modules/social_app/edit_profile/cubit/profile_cubit.dart';
import 'package:social/modules/social_app/new_post/cubit/posts_cubit.dart';

import '../../modules/comments/cubit/comments_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton(() => PostCubit());
  getIt.registerLazySingleton(() => MessageCubit());
  getIt.registerLazySingleton(() => ProfileCubit());
  getIt.registerLazySingleton(() => CommentCubit());
}
