import 'package:flutter/material.dart';
import 'package:ClassViz/models/Task.dart';
import 'package:ClassViz/util/notification_service.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
    await NotificationService().scheduleDeadlineNotifications(task);
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
