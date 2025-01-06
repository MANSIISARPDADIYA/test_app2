import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:test_app/main.dart';

import '../display_task_list/task_list_view_model.dart';
import '../task_add/task_model.dart';
import '../task_add/add_task_view_model.dart';
import '../task_add/widgets/edit_task_dialogue.dart';

class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red[400]!;
      case 'medium':
        return Colors.orange[400]!;
      case 'low':
        return Colors.green[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final bool isCompleted = task.isCompleted == 1;
    final priorityColor = _getPriorityColor(task.priority);

    final formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.parse(task.date));

    return Card(
      elevation: 8,
      shadowColor: isCompleted ? Color(0xFF88D3CE).withOpacity(0.4) : Color(0xFF4158D0).withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showDialog(
          context: context,
          builder: (_) {
            ref.read(taskViewModelProvider.notifier).selectedDate = DateTime.parse(task.date);
            ref.read(taskViewModelProvider.notifier).selectedPriority = task.priority;
            return EditTaskDialog(task: task);
          },
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isCompleted ? theme.primary : theme.secondary,
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: isCompleted,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          activeColor: theme.primary,
                          onChanged: (value) async {
                            final updatedTask = Task(
                              id: task.id,
                              title: task.title,
                              description: task.description,
                              isCompleted: value! ? 1 : 0,
                              date: task.date,
                              priority: task.priority,
                            );
                            await ref.read(taskViewModelProvider).updateTask(updatedTask);
                            ref.read(taskListViewModelProvider).fetchTasks();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: priorityColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  task.priority.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                        splashRadius: 24,
                        onPressed: () async {
                          final bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Task'),
                              content: Text('Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ref.read(taskViewModelProvider).deleteTask(task.id!);
                            ref.read(taskListViewModelProvider).fetchTasks();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    task.description,
                    style: TextStyle(
                      color: Colors.black87,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
