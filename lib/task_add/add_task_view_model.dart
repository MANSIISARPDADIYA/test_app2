import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/task_add/task_model.dart';
import 'package:test_app/task_add/add_task_repository.dart';

import '../display_task_list/task_list_view_model.dart';

final taskViewModelProvider = ChangeNotifierProvider((ref) => TaskViewModel());

class TaskViewModel extends ChangeNotifier {
  final AddTaskRepository repository = AddTaskRepository();
  DateTime? selectedDate;
  String? selectedPriority = 'Low';

  Future<void> addTask(String title, String description, int isCompleted, String data, String priority) async {
    await repository.addTask(Task(title: title, description: description, isCompleted: isCompleted, date: data, priority: priority));
  }

  void updateDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updatePriority(String priority) {
    selectedPriority = priority;
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await repository.updateTask(task);
    TaskListViewModel().fetchTasks();
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await repository.deleteTask(id);
    TaskListViewModel().fetchTasks();
    notifyListeners();
  }
}
