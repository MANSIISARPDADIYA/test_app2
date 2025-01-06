import 'package:test_app/task_add/task_model.dart';

import '../utils/db_helper.dart';

class AddTaskRepository {
  final DBHelper dbHelper = DBHelper.instance;

  Future<int> addTask(Task task) => dbHelper.insertTask(task);

  Future<int> updateTask(Task task) => dbHelper.updateTask(task);

  Future<int> deleteTask(int id) => dbHelper.deleteTask(id);
}
