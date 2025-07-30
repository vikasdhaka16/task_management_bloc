import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constant/app_constant.dart';
import '../../domain/entities/task.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_event.dart';
import 'bloc/task_state.dart';
import 'widgets/edit_task_page.dart';
import 'widgets/progress_indicator.dart';
import 'widgets/task_item.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TaskBloc>().add(LoadTasks());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(LoadTasks());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TaskLoaded) {
            return Column(
              children: [
                CustomProgressIndicator(tasks: state.tasks),

                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFilterChip(context, 'All', state.currentFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        AppConstants.statusTodo,
                        state.currentFilter,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        AppConstants.statusInProgress,
                        state.currentFilter,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        AppConstants.statusDone,
                        state.currentFilter,
                      ),
                    ],
                  ),
                ),

                // Task List
                Expanded(
                  child: state.filteredTasks.isEmpty
                      ? _buildEmptyState(context, state.currentFilter)
                      : ListView.builder(
                          itemCount: state.filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = state.filteredTasks[index];
                            return TaskItem(
                              task: task,
                              onTap: () => _navigateToEditTask(context, task),
                              onDelete: () => _showDeleteDialog(context, task),
                              onStatusChanged: (newStatus) {
                                final updatedTask = task.copyWith(
                                  status: newStatus,
                                  updatedAt: DateTime.now(),
                                );
                                context.read<TaskBloc>().add(
                                  UpdateTaskEvent(updatedTask),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddTask(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String filter,
    String currentFilter,
  ) {
    final isSelected = filter == currentFilter;

    return FilterChip(
      label: Text(
        filter,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      selected: isSelected,
      checkmarkColor: isSelected ? Colors.white : Colors.black,
      onSelected: (selected) {
        if (selected) {
          context.read<TaskBloc>().add(FilterTasksEvent(filter));
        }
      },

      selectedColor: Colors.teal,

      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildEmptyState(BuildContext context, String filter) {
    String message;
    IconData icon;

    switch (filter) {
      case AppConstants.statusTodo:
        message = 'No pending tasks!\nYou\'re all caught up.';
        icon = Icons.check_circle_outline;
        break;
      case AppConstants.statusInProgress:
        message = 'No tasks in progress.\nTime to start working!';
        icon = Icons.hourglass_empty;
        break;
      case AppConstants.statusDone:
        message = 'No completed tasks yet.\nGet started on your goals!';
        icon = Icons.flag_outlined;
        break;
      default:
        message = 'No tasks found.\nCreate your first task!';
        icon = Icons.task_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (filter == 'All')
            ElevatedButton.icon(
              onPressed: () => _navigateToAddTask(context),
              icon: const Icon(Icons.add),
              label: const Text('Create Task'),
            ),
        ],
      ),
    );
  }

  void _navigateToAddTask(BuildContext context) {
    final taskBloc = context
        .read<TaskBloc>(); // read using current context (correct!)

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: taskBloc, child: AddEditTaskPage()),
      ),
    );
  }

  void _navigateToEditTask(BuildContext context, Task task) {
    final taskBloc = context.read<TaskBloc>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: taskBloc,
          child: AddEditTaskPage(task: task),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Task task) {
    final taskBloc = context.read<TaskBloc>(); // ✅ Capture outside

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              taskBloc.add(DeleteTaskEvent(task.id)); // ✅ Use captured instance
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
