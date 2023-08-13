import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/providers/todo_provider.dart';

void main() {
  late ProviderContainer container;
  late TodoListNotifier notifier;

  setUp(() {
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfiNoIsolate;
    container = ProviderContainer();
    notifier = container.read(todoProvider.notifier);
  });

  tearDownAll(() {
    container.dispose();
    databaseFactoryFfiNoIsolate.deleteDatabase('todo.db');
  });

  test('To do list start empty', () {
    expect(notifier.debugState, []);
  });

  test('Get all to do list', () async {
    await notifier.getAll();
    for (var i = 0; i < 5; i++) {
      await notifier.create(Todo(
          title: 'Test',
          startDate: "02/09/2023",
          endDate: "03/09/2023",
          done: false));
    }

    await notifier.getAll();
    expect(notifier.debugState.length, 5);
  });

  test('Create to do list', () async {
    await notifier.create(Todo(
        title: 'Test',
        startDate: "02/09/2023",
        endDate: "03/09/2023",
        done: false));

    expect(notifier.debugState.length, 1);
  });

  test('Get to do list by Id', () async {
    final todo = await notifier.create(Todo(
        title: 'Test',
        startDate: "02/09/2023",
        endDate: "03/09/2023",
        done: false));

    expect(notifier.debugState.firstWhere((element) => element.id == todo.id),
        isNotNull);
  });

  test('Update to do list', () async {
    final todo = await notifier.create(Todo(
        title: 'Test',
        startDate: "02/09/2023",
        endDate: "03/09/2023",
        done: false));

    await notifier.update(Todo(
        id: todo.id,
        title: 'Update Test',
        startDate: "05/09/2023",
        endDate: "09/09/2023",
        done: true));

    expect(notifier.debugState.length, 1);
    expect(notifier.debugState[0].title, 'Update Test');
    expect(notifier.debugState[0].startDate, '05/09/2023');
    expect(notifier.debugState[0].endDate, '09/09/2023');
    expect(notifier.debugState[0].done, true);
  });

  test('Delete to do list', () async {
    final todo = await notifier.create(Todo(
        title: 'Test',
        startDate: "02/09/2023",
        endDate: "03/09/2023",
        done: false));

    await notifier.delete(todo);

    expect(notifier.debugState.length, 0);
  });
}
