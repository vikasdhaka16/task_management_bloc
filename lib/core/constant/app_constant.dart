import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Task Manager';
  
  // Task Status
  static const String statusTodo = 'To Do';
  static const String statusInProgress = 'In Progress';
  static const String statusDone = 'Done';
  
  static const List<String> taskStatuses = [
    statusTodo,
    statusInProgress,
    statusDone,
  ];
  
  // Colors
  static const Color todoColor = Colors.grey;
  static const Color inProgressColor = Colors.blue;
  static const Color doneColor = Colors.green;
  
  static Color getStatusColor(String status) {
    switch (status) {
      case statusTodo:
        return todoColor;
      case statusInProgress:
        return inProgressColor;
      case statusDone:
        return doneColor;
      default:
        return todoColor;
    }
  }
}