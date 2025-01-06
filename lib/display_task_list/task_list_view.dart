import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/display_task_list/task_list_view_model.dart';
import 'package:test_app/main.dart';
import 'package:test_app/task_add/add_task_view.dart';
import 'package:test_app/utils/task_card.dart';
import 'package:lottie/lottie.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: theme.surface),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(color: theme.primary),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Task Management',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Consumer(
                              builder: (context, ref, _) {
                                final tasks = ref.watch(taskListViewModelProvider).tasks;
                                final pendingTasks = tasks.where((task) => task.isCompleted == 0).toList();
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'} available',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${pendingTasks.length} ${pendingTasks.length == 1 ? 'task' : 'tasks'} pending',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: Consumer(
                builder: (context, ref, child) {
                  var taskViewModel = ref.watch(taskListViewModelProvider);
                  if (taskViewModel.tasks.isEmpty) {
                    return SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/json/Animation - 1735625677158.json',
                            height: 200,
                          ),
                          SizedBox(height: 24),
                          Text(
                            'No tasks yet',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: theme.onSurface,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your first task by tapping the button below',
                            style: GoogleFonts.poppins(
                              color: theme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = taskViewModel.tasks[index];
                        return TaskCard(task: task);
                      },
                      childCount: taskViewModel.tasks.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: theme.primary,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6a11cb).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => showDialog(
            useSafeArea: false,
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AddTaskBottomSheet(),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: Text(
            'Add Task',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}
