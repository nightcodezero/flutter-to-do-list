import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/providers/go_router_provider.dart';
import 'package:todolist/providers/todo_provider.dart';
import 'package:todolist/screens/add_todo_screen.dart';
import 'package:todolist/widgets/task_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const path = '/dashboard';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(todoProvider.notifier).getAll();
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoProvider);
    final router = ref.read(goRouterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey.shade200,
                child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        task: todoList.elementAt(index),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(AddTodoScreen.path);
        },
        backgroundColor: Colors.red,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
