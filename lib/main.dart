import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/task_add/task_model.dart';
import 'package:test_app/display_task_list/task_list_view.dart';

import 'package:test_app/task_add/add_task_view_model.dart';
import 'package:test_app/utils/theme.dart';

void main() async {
  await Hive.initFlutter();
  runApp(ProviderScope(child: MyApp()));
}

var theme = Theme.of(navigatorKey.currentContext!).colorScheme;
GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Task Management',
      theme: AppThemes.lightTheme,
      themeMode: ThemeMode.system,
      darkTheme: AppThemes.darkTheme,
      home: TaskScreen(),
    );
  }
}
