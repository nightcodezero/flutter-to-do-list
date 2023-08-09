import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/screens/add_todo_screen.dart';
import 'package:todolist/screens/dashboard_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: DashboardScreen.path,
    routes: [
      GoRoute(
        path: DashboardScreen.path,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
          path: AddTodoScreen.path,
          builder: (context, state) => const AddTodoScreen()),
    ],
  );
});
