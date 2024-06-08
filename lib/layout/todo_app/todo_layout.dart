
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/cubit/cubit.dart';
import 'package:social/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget
{
  final GlobalKey<ScaffoldState>scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  HomeLayout({super.key});

  // List<Map> tasks =[];
  // var state = AppCubit.get(context).state;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context,AppStates state) {
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context,AppStates state) {
         AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex], //في حالة تحقق condition
              fallback: (context) => const Center(child: CircularProgressIndicator()),// في حالة عدم تحقق condition
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              {
                if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value)
                    // {
                    //   getDataFormDatabase(database).then((value)
                    //   {
                    //     Navigator.pop(context);
                    //     // setState(()
                    //     // {
                    //     //   isBottomSheetShown = false;
                    //     //   fabIcon = Icons.edit;
                    //     //
                    //     //   tasks = value;
                    //     //   print(tasks);
                    //     // });
                    //
                    //   });
                    //
                    // });
                  }
                }else
                {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.all(20.0,),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                },
                                label: 'task Title',
                                prefix: Icons.title,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                onTap: ()
                                {
                                  showTimePicker(
                                    context: context,
                                    initialTime:TimeOfDay.now(),
                                  ).then((value)
                                  {
                                    timeController.text = value!.format(context).toString();
                                    if (kDebugMode) {
                                      print(value.format(context));
                                    }
                                  });
                                },
                                validate: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                                label: 'task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                onTap: ()
                                {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-8-9'),
                                  ).then((value)
                                  {
                                    dateController.text = DateFormat.yMMMEd().format(value!);
                                  });
                                },
                                validate: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                },
                                label: 'task Date',
                                prefix: Icons.calendar_today,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {
                cubit.changeIndex(index);
                // setState(()
                // {
                //   currentIndex = index;
                // });
              },
              items:
              const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //Instance of 'Future<String>'
  // Future<String> getName() async  //بيفتح مكان في background
  // {
  //   return 'Ahmed Ali';
  // }


}


