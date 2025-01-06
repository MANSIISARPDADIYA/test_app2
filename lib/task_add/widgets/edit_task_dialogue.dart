import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../display_task_list/task_list_view_model.dart';
import '../task_model.dart';
import '../add_task_view_model.dart';
import '../../utils/custom_textfield.dart';

class EditTaskDialog extends ConsumerWidget {
  final Task task;
  final _formKey = GlobalKey<FormState>();

  EditTaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    var date = ref.watch(taskViewModelProvider.select((value) => value.selectedDate));
    var priority = ref.watch(taskViewModelProvider.select((value) => value.selectedPriority));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Task',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: titleController,
                label: 'Task Title',
                prefixIcon: Icons.edit,
                validator: (value) => value?.isEmpty ?? true ? 'Title required' : null,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: descriptionController,
                label: 'Description',
                prefixIcon: Icons.subject,
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Description required' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: date ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != date) {
                    ref.read(taskViewModelProvider.notifier).updateDate(pickedDate);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Consumer(builder: (context, ref, _) {
                  return Text(
                    date == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(date),
                    style: TextStyle(fontSize: 16),
                  );
                }),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: priority,
                onChanged: (String? newValue) {
                  ref.read(taskViewModelProvider.notifier).selectedPriority = newValue;
                  priority = newValue;
                },
                items: ['Low', 'Medium', 'High']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Priority',
                  prefixIcon: Icon(Icons.priority_high),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Priority required' : null,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await ref
                              .read(taskViewModelProvider)
                              .updateTask(
                                Task(
                                  id: task.id,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  isCompleted: task.isCompleted,
                                  date: DateFormat('yyyy-MM-dd').format(date!),
                                  priority: priority ?? 'Low',
                                ),
                              )
                              .whenComplete(() async {
                            await ref.read(taskListViewModelProvider).fetchTasks();
                            Navigator.pop(context);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
