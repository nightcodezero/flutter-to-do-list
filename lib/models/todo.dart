class Todo {
  int? id;
  String title;
  String startDate;
  String endDate;
  bool done;

  static const String tableTodo = 'todo';
  static const String columnId = '_id';
  static const String columnTitle = 'title';
  static const String columnStartDate = 'startDate';
  static const String columnEndDate = 'endDate';
  static const String columnDone = 'done';

  Todo({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.done,
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnId: id,
      columnTitle: title,
      columnStartDate: startDate,
      columnEndDate: endDate,
      columnDone: done == true ? 1 : 0,
    };

    return map;
  }

  Todo.fromMap(Map<String, Object?> map)
      : id = map[columnId] as int,
        title = map[columnTitle] as String,
        startDate = map[columnStartDate] as String,
        endDate = map[columnEndDate] as String,
        done = (map[columnDone] as int) == 1;

  Todo copyWith({
    int? id,
    String? title,
    String? startDate,
    String? endDate,
    bool? done,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      done: done ?? this.done,
    );
  }
}
