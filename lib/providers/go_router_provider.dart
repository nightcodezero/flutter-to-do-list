import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/screens/dashboard_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: DashboardScreen.path,
    routes: [
      GoRoute(
        path: DashboardScreen.path,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
});
