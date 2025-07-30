import 'package:flutter/material.dart';
import '../../../core/constant/app_constant.dart';
import '../../../domain/entities/task.dart';

class CustomProgressIndicator extends StatelessWidget {
  final List<Task> tasks;

  const CustomProgressIndicator({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final totalTasks = tasks.length;
    final completedTasks = tasks
        .where((task) => task.status == AppConstants.statusDone)
        .length;
    final inProgressTasks = tasks
        .where((task) => task.status == AppConstants.statusInProgress)
        .length;

    final completedPercentage = totalTasks == 0
        ? 0.0
        : completedTasks / totalTasks;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        surfaceTintColor: Colors.transparent,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Completed',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '$completedTasks/$totalTasks',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: completedPercentage,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppConstants.doneColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircularProgressIndicator(
                    value: completedPercentage,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppConstants.doneColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusCount(
                    context,
                    'To Do',
                    tasks
                        .where((task) => task.status == AppConstants.statusTodo)
                        .length,
                    AppConstants.todoColor,
                  ),
                  _buildStatusCount(
                    context,
                    'In Progress',
                    inProgressTasks,
                    AppConstants.inProgressColor,
                  ),
                  _buildStatusCount(
                    context,
                    'Done',
                    completedTasks,
                    AppConstants.doneColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCount(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
