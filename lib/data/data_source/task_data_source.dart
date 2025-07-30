
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/constant/app_constant.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  static const String _boxName = 'tasks';
  final _uuid = const Uuid();

  Box<TaskModel> get _box => Hive.box<TaskModel>(_boxName);

  Future<List<TaskModel>> getTasks() async {
   
    if (_box.isEmpty) {
      await _addDummyData();
    }
    
    return _box.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  Future<void> deleteTask(String taskId) async {
    await _box.delete(taskId);
  }

  Future<void> _addDummyData() async {
    final now = DateTime.now();
    final dummyTasks = [
      TaskModel(
        id: _uuid.v4(),
        title: 'Complete Flutter Project',
        description: 'Finish the task manager app with all features',
        status: AppConstants.statusInProgress,
        dueDate: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Review Code',
        description: 'Review the pull request from team member',
        status: AppConstants.statusTodo,
        dueDate: now.add(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Write Documentation',
        description: 'Document the API endpoints and usage',
        status: AppConstants.statusDone,
        dueDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Team Meeting',
        description: 'Weekly standup meeting with the development team',
        status: AppConstants.statusTodo,
        dueDate: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];

    for (final task in dummyTasks) {
      await _box.put(task.id, task);
    }
  }
}