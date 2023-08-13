import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/providers/todo_provider.dart';

class TaskCard extends ConsumerStatefulWidget {
  final Todo task;

  const TaskCard({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  String convertDate(String date) {
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(date);
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  int _hours = 0;
  int _minutes = 0;

  @override
  Widget build(BuildContext context) {
    final isTaskStarted = DateTime.parse(convertDate(widget.task.startDate))
        .isBefore(DateTime.now());

    if (isTaskStarted) {
      DateTime endDateTime = DateTime.parse(convertDate(widget.task.endDate));
      Duration difference = endDateTime
          .add(const Duration(hours: 23, minutes: 59))
          .difference(DateTime.now());

      _hours = difference.inHours;
      _minutes = difference.inMinutes.remainder(60);

      if (_hours < 0) {
        _hours = 0;
      }

      if (_minutes < 0) {
        _minutes = 0;
      }
    }

    if (widget.task.done) {
      _hours = 0;
      _minutes = 0;
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Start Date',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.task.startDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'End Date',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.task.endDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Time Left',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$_hours hrs $_minutes min",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(widget.task.done ? 'Completed' : 'Incomplete',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Container()),
                  const Text(
                    "Tick if completed",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      key: const Key('checkbox'),
                      value: widget.task.done,
                      onChanged: (value) {
                        ref
                            .read(todoProvider.notifier)
                            .update(widget.task.copyWith(done: value!));
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
