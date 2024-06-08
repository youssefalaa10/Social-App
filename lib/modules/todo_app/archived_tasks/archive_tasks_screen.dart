import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';


class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {},
      builder: (context,state) {
        var tasks = AppCubit.get(context).archiveTasks;

        return tasksBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
