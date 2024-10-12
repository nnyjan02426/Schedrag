import 'package:schedrag/data/models/blocks.dart';

class TodoBlock extends Block {
  late DateTime estimatedTime, deadline;

  TodoBlock()
      : estimatedTime = DateTime.now(),
        deadline = DateTime.now();
  TodoBlock.name(super.name)
      : estimatedTime = DateTime.now(),
        deadline = DateTime.now(),
        super.name();

  TodoBlock.detail(
      {super.name,
      super.category,
      super.notes,
      DateTime? estimatedTime,
      DateTime? deadline})
      : super.detail() {
    if (estimatedTime == null) {
      this.estimatedTime = DateTime.now();
    } else {
      this.estimatedTime = estimatedTime;
    }
    if (deadline == null) {
      this.deadline = DateTime.now();
    } else {
      this.deadline = deadline;
    }
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'estimatedTime': estimatedTime.toString(),
      'deadline': deadline.toString(),
      'notes': notes,
    };
  }

  DateTime setTime(
          {int month = 0, int day = 0, int hour = 0, int minute = 0}) =>
      DateTime(2000, month, day, hour, minute);

  @override
  TodoBlock toBlock(Map<String, Object?> data) {
    return TodoBlock.detail(
      name: data['name'].toString(),
      category: data['category'].toString(),
      estimatedTime: DateTime.tryParse(data['estimatedTime'].toString()),
      deadline: DateTime.tryParse(data['deadline'].toString()),
      notes: data['notes'].toString(),
    );
  }
}

class TodoBlocksDb extends BlocksDb {
  static const String _executeSQL = '''
    id INTEGER PRIMARY KEY,
    name TEXT, category TEXT,
    estimatedTime DATETIME,
    deadline DATETIME,
    notes TEXT''';

  TodoBlocksDb()
      : super(
            dbFilename: 'TodoBlock.db',
            tableName: 'Todos',
            executeSQL: _executeSQL);

  Future<List<TodoBlock>?> getAll() async {
    if (!dbIsOpen) open();

    List<Map<String, Object?>>? table =
        await db?.rawQuery('SELECT * FROM $tableName');
    notifyListeners();
    return table?.map((data) => TodoBlock().toBlock(data)).toList();
  }
}
