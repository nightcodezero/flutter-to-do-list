import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/providers/go_router_provider.dart';
import 'package:todolist/providers/todo_provider.dart';

class AddTodoScreen extends ConsumerStatefulWidget {
  final int? id;

  const AddTodoScreen({super.key, this.id});

  static const path = '/add-todo';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends ConsumerState<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      ref.read(todoProvider.notifier).getById(widget.id!).then((value) {
        _titleController.text = value.title;
        _startDate.text = value.startDate;
        _endDate.text = value.endDate;
        _isCompleted = value.done;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.read(goRouterProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            Text(widget.id == null ? 'Add new To-Do List' : 'Edit To-Do List',
                textAlign: TextAlign.left,
                style: const TextStyle(
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
                      key: const Key('title_field'),
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
                    key: const Key('start_date_field'),
                    controller: _startDate,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Select a date",
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () async {
                      DateTime? startPickedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate.text.isEmpty
                              ? DateTime.now()
                              : DateFormat('dd-MM-yyyy').parse(_startDate.text),
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
                    key: const Key('end_date_field'),
                    controller: _endDate,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Select a date",
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () async {
                      if (_startDate.text.isNotEmpty) {
                        DateTime? endPickedDate = await showDatePicker(
                            context: context,
                            initialDate: _endDate.text.isEmpty
                                ? DateTime.now()
                                : DateFormat('dd-MM-yyyy').parse(_endDate.text),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if (endPickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(endPickedDate);
                          setState(() {
                            _endDate.text = formattedDate;
                          });
                        }
                      } else {
                        showErrorMsg('You need to select Start Date first');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          TextButton(
              key: const Key('create_button'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                if (_titleController.text.trim().isEmpty) {
                  showErrorMsg('You need to key in To-Do Title');
                  return;
                }

                if (_startDate.text.isEmpty) {
                  showErrorMsg('You need to select Start Date');
                  return;
                }

                if (_endDate.text.isEmpty) {
                  showErrorMsg('You need to select End Date');
                  return;
                }

                if (widget.id != null) {
                  ref.read(todoProvider.notifier).update(Todo(
                      id: widget.id,
                      title: _titleController.text.trim(),
                      startDate: _startDate.text,
                      endDate: _endDate.text,
                      done: _isCompleted));
                } else {
                  ref.read(todoProvider.notifier).create(Todo(
                      title: _titleController.text.trim(),
                      startDate: _startDate.text,
                      endDate: _endDate.text,
                      done: false));
                }

                router.pop();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Text(
                  widget.id == null ? 'Create Now' : 'Save',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      )),
    );
  }

  void showErrorMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(msg, style: const TextStyle(color: Colors.white)),
          ],
        )));
  }
}
