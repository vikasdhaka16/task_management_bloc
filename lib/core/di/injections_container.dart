import 'package:get_it/get_it.dart';

import '../../data/data_source/task_data_source.dart';
import '../../data/repositories/task_repo_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';

import '../../domain/usecases/task_usecase.dart';
import '../../domain/usecases/update_task.dart';
import '../../presentation/pages/bloc/task_bloc.dart';


final getIt = GetIt.instance;

void setupDependencies() {
  // Data sources
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetTasks(getIt()));
  getIt.registerLazySingleton(() => AddTask(getIt()));
  getIt.registerLazySingleton(() => UpdateTask(getIt()));
  getIt.registerLazySingleton(() => DeleteTask(getIt()));

  // BLoC
  getIt.registerFactory(() => TaskBloc(
        getTasks: getIt(),
        addTask: getIt(),
        updateTask: getIt(),
        deleteTask: getIt(),
      ));
}