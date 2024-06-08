import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/cubit/cubit.dart';
import 'package:social/shared/cubit/states.dart';

import '../../../shared/components/components.dart';


class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});


  @override
  Widget build(BuildContext context) {
 return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {},
      builder: (context,state) {
        var tasks = AppCubit.get(context).newTasks;

        return tasksBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
