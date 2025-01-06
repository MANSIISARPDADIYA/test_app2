import 'package:test_app/task_add/task_model.dart';

import '../utils/db_helper.dart';

class DisplayTaskRepository {
  final DBHelper dbHelper = DBHelper.instance;

  Future<List<Task>> getTasks() => dbHelper.fetchTasks();
}
