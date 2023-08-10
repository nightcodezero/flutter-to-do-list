import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/models/todo.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>(
  (ref) => TodoNotifier(),
);

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super(const []);

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'todo.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE ${Todo.tableTodo} (
            ${Todo.columnId} INTEGER PRIMARY KEY autoincrement,
            ${Todo.columnTitle} TEXT NOT NULL,
            ${Todo.columnStartDate} TEXT NOT NULL,
            ${Todo.columnEndDate} TEXT NOT NULL,
            ${Todo.columnDone} INTEGER NOT NULL)
          ''');
      },
    );
  }

  Future<List<Todo>> getAll() async {
    final db = await database;
    List<Map> maps = await db.query(
      Todo.tableTodo,
      columns: [
        Todo.columnId,
        Todo.columnTitle,
        Todo.columnStartDate,
        Todo.columnEndDate,
        Todo.columnDone,
      ],
    );

    if (maps.isEmpty) {
      return [];
    }

    state = List.generate(maps.length,
        (index) => Todo.fromMap(maps[index] as Map<String, dynamic>));

    return List.generate(maps.length,
        (index) => Todo.fromMap(maps[index] as Map<String, dynamic>));
  }

  Future<Todo> getById(int id) async {
    final db = await database;
    List<Map> maps = await db.query(
      Todo.tableTodo,
      columns: [
        Todo.columnId,
        Todo.columnTitle,
        Todo.columnStartDate,
        Todo.columnEndDate,
        Todo.columnDone,
      ],
      where: '${Todo.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return Todo(
        id: 0,
        title: '',
        startDate: '',
        endDate: '',
        done: false,
      );
    }

    return Todo.fromMap(maps.first as Map<String, dynamic>);
  }

  Future<Todo> create(Todo todo) async {
    final db = await database;
    todo.id = await db.insert(Todo.tableTodo, todo.toMap());
    state = [...state, todo];

    return todo;
  }

  Future<void> update(Todo todo) async {
    final db = await database;
    await db.update(
      Todo.tableTodo,
      todo.toMap(),
      where: '${Todo.columnId} = ?',
      whereArgs: [todo.id],
    );

    state = state.map((element) {
      if (element.id == todo.id) {
        return todo;
      } else {
        return element;
      }
    }).toList();
  }

  Future<void> delete(Todo todo) async {
    final db = await database;
    await db.delete(
      Todo.tableTodo,
      where: '${Todo.columnId} = ?',
      whereArgs: [todo.id],
    );

    state = state.where((element) => element.id != todo.id).toList();
  }
}
