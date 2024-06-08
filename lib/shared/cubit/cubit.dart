import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:social/shared/cubit/states.dart';
import 'package:social/shared/network/local/cache_helper.dart';

import '../../modules/todo_app/archived_tasks/archive_tasks_screen.dart';
import '../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../modules/todo_app/new_tasks/new_tasks_screen.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles =[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void createDatabase()
  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version)
      {
        //ID INTEGER
        //Title String
        //date TEXT String
        //Time String
        //Status String

        debugPrint('database created');
        database.execute('CREATE TABLE (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT )').then((value)
        {
          debugPrint('table create');
        }).catchError((error){
          debugPrint('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFormDatabase(database);
        debugPrint('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database.transaction((txn)
    async{
      return txn.
      rawInsert(
        'INSERT INTO tasks(title,date, time, status) VALUES("$title","$date","$time","new")',
      ).then((value)
      {
        debugPrint('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFormDatabase(database);
      }).catchError((error)
      {
        debugPrint('Error when Inserting New Record ${error.toString()}');
      });
    });
  }

void getDataFormDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element) {
       if(element['status']== 'new') {
         newTasks.add(element);
       } else if(element['status']== 'done') {
         doneTasks.add(element);
       } else {
         archiveTasks.add(element);
       }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
  required String status,
  required int id,
}) async
  {
     database.rawUpdate(
        'UPDATE tasks SET status = ?,  WHERE id = ?',
        [status,id],
    ).then((value) 
     {
       getDataFormDatabase(database);
      emit(AppUpdateDatabaseState());
     });
  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',  [id])
        .then((value)
    {
      getDataFormDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void changeBottomSheetState({
   required bool isShow,
   required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    
    emit(AppChangeBottomSheetState());
  }
  bool isDark = false;

  void changeAppMode({bool? fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    }else{
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}