import 'package:schedrag/data/models/blocks.dart';

class TimeBlock extends Block {
  late DateTime startTime, endTime;

  TimeBlock()
      : startTime = DateTime.now(),
        endTime = DateTime.now();
  TimeBlock.name(super.name)
      : startTime = DateTime.now(),
        endTime = DateTime.now(),
        super.name();

  TimeBlock.detail(
      {super.name,
      super.category,
      super.notes,
      DateTime? startTime,
      DateTime? endTime})
      : super.detail() {
    if (startTime == null) {
      this.startTime = DateTime.now();
    } else {
      this.startTime = startTime;
    }
    if (endTime == null) {
      this.endTime = DateTime.now();
    } else {
      this.endTime = endTime;
    }
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
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
      startTime: DateTime.tryParse(data['startTime'].toString()),
      endTime: DateTime.tryParse(data['endTime'].toString()),
      notes: data['notes'].toString(),
    );
  }
}

class TimeBlocksDb extends BlocksDb {
  static const String _executeSQL = '''
    id INTEGER PRIMARY KEY,
    name TEXT, category TEXT,
    startTime DATETIME,
    endTime DATETIME,
    notes TEXT''';

  TimeBlocksDb()
      : super(
            dbFilename: 'TimeBlock.db',
            tableName: 'Timetable',
            executeSQL: _executeSQL);

  Future<List<TimeBlock>?> getAll() async {
    if (!dbIsOpen) open();

    List<Map<String, Object?>>? table =
        await db?.rawQuery('SELECT * FROM $tableName');
    notifyListeners();
    return table?.map((data) => TimeBlock().toBlock(data)).toList();
  }
}
