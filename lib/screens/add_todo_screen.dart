import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

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
                  TextFormField(
                    controller: _startDate,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Start Date",
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () async {
                      DateTime? startPickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100));
                      if (startPickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(startPickedDate);
                        setState(() {
                          _startDate.text = formattedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "End Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _endDate,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "End Date",
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () async {
                      if (_startDate.text.isNotEmpty) {
                        String dateTime = _startDate.text;
                        DateFormat inputFormat = DateFormat('dd-MM-yyyy');
                        DateTime input = inputFormat.parse(dateTime);

                        DateTime? endPickedDate = await showDatePicker(
                          context: context,
                          initialDate: input.add(const Duration(days: 1)),
                          firstDate: input.add(const Duration(days: 1)),
                          lastDate: DateTime(2100),
                        );
                        if (endPickedDate != null) {
                          String formattedDate = DateFormat('dd-MM-yyyy')
                              .format(endPickedDate.toUtc());
                          setState(() {
                            _endDate.text = formattedDate;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('You need to select Start Date')));
                      }
                    },
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
                    startDate: _startDate.text,
                    endDate: _endDate.text,
                    done: false));
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
