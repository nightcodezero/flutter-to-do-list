import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/providers/go_router_provider.dart';
import 'package:todolist/providers/todo_provider.dart';

class AddTodoScreen extends ConsumerStatefulWidget {
  const AddTodoScreen({super.key});

  static const path = '/add-todo';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends ConsumerState<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final router = ref.read(goRouterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new To-Do List',
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
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To-Do Title",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 5 * 24.0,
                    width: double.infinity,
                    child: TextField(
                      controller: _titleController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Please key in your To-Do title here',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Start Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(children: [
                      Expanded(
                        child: Text("Select a date"),
                      ),
                      Icon(Icons.arrow_downward),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                ref.read(todoProvider.notifier).insert(Todo(
                    title: _titleController.text,
                    startDate: "startdate",
                    endDate: "endDate",
                    done: true));
                router.pop();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: const Text(
                  textAlign: TextAlign.center,
                  'Create New',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      )),
    );
  }
}
