import 'package:schedrag/data/models/blocks.dart';

class TimeBlock extends Block {
  DateTime estimatedTime, deadline;

  TimeBlock()
      : estimatedTime = DateTime.now(),
        deadline = DateTime.now();
  TimeBlock.name(super.name)
      : estimatedTime = DateTime.now(),
        deadline = DateTime.now(),
        super.name();
  TimeBlock.detail({super.name, super.category, super.notes})
      //required this.estimatedTime,
      //required this.deadline})
      : estimatedTime = DateTime.now(),
        deadline = DateTime.now(),
        super.detail();

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'estimatedTime': estimatedTime.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'notes': notes,
    };
  }

  DateTime setTime(
          {int month = 0, int day = 0, int hour = 0, int minute = 0}) =>
      DateTime(2000, month, day, hour, minute);

  @override
  TimeBlock toBlock(Map<String, Object?> data) {
    return TimeBlock.detail(
      name: data['name'].toString(),
      category: data['category'].toString(),
      //estimatedTime: DateTime.parse(data['estimatedTime'].toString()),
      //deadline: DateTime.parse(data['deadline'].toString()),
      notes: data['notes'].toString(),
    );
  }
}

class TimeBlocksDb extends BlocksDb {
  static const String _executeSQL = '''
    id INTEGER PRIMARY KEY,
    name TEXT, category TEXT,
    estimatedTime DATETIME,
    deadline DATETIME,
    notes TEXT''';

  TimeBlocksDb()
      : super(
            dbFilename: 'timeBlock.db',
            tableName: 'Todos',
            executeSQL: _executeSQL);

  Future<List<TimeBlock>?> getAll() async {
    if (!dbIsOpen) open();

    List<Map<String, Object?>> table =
        await db.rawQuery('SELECT * FROM $tableName');
    notifyListeners();
    return table.map((data) => TimeBlock().toBlock(data)).toList();
  }
}
