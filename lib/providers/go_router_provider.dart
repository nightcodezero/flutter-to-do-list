import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];

            return AddTodoScreen(id: id == null ? null : int.parse(id));
          }),
    ],
  );
});
