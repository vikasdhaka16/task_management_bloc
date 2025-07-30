import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_management/core/di/injections_container.dart';
import 'core/theme/app_theme.dart';
import 'data/models/task_model.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/delete_task.dart';
import 'domain/usecases/task_usecase.dart';
import 'domain/usecases/update_task.dart';
import 'presentation/pages/bloc/task_bloc.dart';
import 'presentation/pages/bloc/task_event.dart';
import 'presentation/pages/task_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasks');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      title: 'Task Manager',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => TaskBloc(
          getTasks: GetTasks(getIt()),
          addTask: AddTask(getIt()),
          updateTask: UpdateTask(getIt()),
          deleteTask: DeleteTask(getIt()),
        )..add(LoadTasks()),
        child: TaskListPage(),
      ),
    );
  }
}
