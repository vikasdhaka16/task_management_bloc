import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_constant.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/usecases/add_task.dart';
import '../../../domain/usecases/delete_task.dart';
import '../../../domain/usecases/task_usecase.dart';
import '../../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<FilterTasksEvent>(_onFilterTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();
      emit(TaskLoaded(
        tasks: tasks,
        filteredTasks: tasks,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await addTask(event.task);
        final updatedTasks = await getTasks();
        final currentState = state as TaskLoaded;
        final filteredTasks = _filterTasks(updatedTasks, currentState.currentFilter);
        
        emit(currentState.copyWith(
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
        ));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await updateTask(event.task);
        final updatedTasks = await getTasks();
        final currentState = state as TaskLoaded;
        final filteredTasks = _filterTasks(updatedTasks, currentState.currentFilter);
        
        emit(currentState.copyWith(
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
        ));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await deleteTask(event.taskId);
        final updatedTasks = await getTasks();
        final currentState = state as TaskLoaded;
        final filteredTasks = _filterTasks(updatedTasks, currentState.currentFilter);
        
        emit(currentState.copyWith(
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
        ));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  void _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final filteredTasks = _filterTasks(currentState.tasks, event.filter);
      
      emit(currentState.copyWith(
        filteredTasks: filteredTasks,
        currentFilter: event.filter,
      ));
    }
  }

  List<Task> _filterTasks(List<Task> tasks, String filter) {
    switch (filter) {
      case 'All':
        return tasks;
      case AppConstants.statusTodo:
        return tasks.where((task) => task.status == AppConstants.statusTodo).toList();
      case AppConstants.statusInProgress:
        return tasks.where((task) => task.status == AppConstants.statusInProgress).toList();
      case AppConstants.statusDone:
        return tasks.where((task) => task.status == AppConstants.statusDone).toList();
      default:
        return tasks;
    }
  }
}