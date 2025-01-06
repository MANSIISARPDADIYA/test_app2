import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:test_app/main.dart';

import '../display_task_list/task_list_view_model.dart';
import 'add_task_view_model.dart';

class AddTaskBottomSheet extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  AddTaskBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var date = ref.watch(taskViewModelProvider.select((value) => value.selectedDate));
    var priority = ref.watch(taskViewModelProvider.select((value) => value.selectedPriority));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        'Add New Task',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close)),
                    ],
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
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
                    child: Text(
                      date == null ? 'Select Date' : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(date!)}',
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: priority,
                    dropdownColor: Colors.white,
                    items: ['Low', 'Medium', 'High']
                        .map((priority) => DropdownMenuItem<String>(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(color: Colors.black),
                              ),
                            ))
                        .toList(),
                    onChanged: (newPriority) {
                      if (newPriority != null) {
                        ref.read(taskViewModelProvider.notifier).updatePriority(newPriority);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please select a priority' : null,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await ref
                            .read(taskViewModelProvider.notifier)
                            .addTask(
                              titleController.text,
                              descriptionController.text,
                              0,
                              date?.toString() ?? DateTime.now().toString(),
                              priority ?? 'Low',
                            )
                            .whenComplete(
                          () {
                            ref.read(taskListViewModelProvider).fetchTasks();
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                    child: Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
