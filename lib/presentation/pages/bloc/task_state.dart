import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';


abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final String currentFilter;

  const TaskLoaded({
    required this.tasks,
    required this.filteredTasks,
    this.currentFilter = 'All',
  });

  TaskLoaded copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    String? currentFilter,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object> get props => [tasks, filteredTasks, currentFilter];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}