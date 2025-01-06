import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test_app/display_task_list/task_list_repository.dart';
import 'package:test_app/task_add/task_model.dart';
import 'package:test_app/task_add/add_task_repository.dart';

final taskListViewModelProvider = ChangeNotifierProvider((ref) => TaskListViewModel());

class TaskListViewModel extends ChangeNotifier {
  TaskListViewModel() {
    fetchTasks();
  }

  final DisplayTaskRepository repository = DisplayTaskRepository();
  List<Task> tasks = [];

  Future<void> fetchTasks() async {
    tasks = await repository.getTasks();
    print('Tasks fetched: $tasks');
    notifyListeners();
  }
}
