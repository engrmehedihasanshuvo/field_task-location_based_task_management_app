import 'package:flutter/material.dart';
import '../pages/tasks_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerate(RouteSettings s) {
    switch (s.name) {
      case '/':
      default:
        return MaterialPageRoute(builder: (_) => const TasksPage());
    }
  }
}
