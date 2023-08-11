import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todolist/main.dart';
import 'package:todolist/screens/add_todo_screen.dart';

void main() {
  setUp(() {
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfiNoIsolate;
  });

  tearDownAll(() {
    databaseFactoryFfiNoIsolate.deleteDatabase('todo.db');
  });

  testWidgets('Test Dashboard Screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('To-Do List'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Test Add Screen', (WidgetTester tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AddTodoScreen())));

    expect(find.text('Add new To-Do List'), findsOneWidget);
    expect(find.text('Please key in your To-Do title here'), findsOneWidget);
    expect(find.text('Select a date'), findsNWidgets(2));
    expect(find.text('Create Now'), findsOneWidget);
  });
}
