import 'package:flutter/material.dart' show Color;
import 'package:schedrag/data/models/blocks.dart';

class TimeBlock extends Block {
  late DateTime startTime, endTime;

  TimeBlock()
      : startTime = DateTime.now(),
        endTime = DateTime.now();

  TimeBlock.detail(
      {required super.name,
      super.id,
      super.category,
      super.notes,
      super.color,
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
  void setDetail(
      {String? name,
      String? category,
      String? notes,
      DateTime? startTime,
      DateTime? endTime,
      Color? color}) {
    super.setDetail(name: name, category: category, notes: notes, color: color);
    if (startTime != null) this.startTime = startTime;
    if (endTime != null) this.endTime = endTime;
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
      'color': color?.value.toRadixString(16),
    };
  }

  @override
  TimeBlock toBlock(Map<String, Object?> data) {
    return TimeBlock.detail(
      name: data['name'].toString(),
      id: int.parse(data['id'].toString()),
      category: data['category'].toString(),
      startTime: DateTime.tryParse(data['startTime'].toString()),
      endTime: DateTime.tryParse(data['endTime'].toString()),
      notes: data['notes'].toString(),
      color: Color(int.parse(data['color'].toString(), radix: 16)),
    );
  }
}

class TimeBlocksDb extends BlocksDb {
  static const String _executeSQL = '''
    id INTEGER PRIMARY KEY,
    name TEXT, category TEXT,
    startTime DATETIME,
    endTime DATETIME,
    notes TEXT, color TEXT
    ''';

  TimeBlocksDb()
      : super(
            dbFilename: 'TimeBlock.db',
            tableName: 'Timetable',
            executeSQL: _executeSQL);

  Future<List<TimeBlock>?> getAll() async {
    if (!dbIsOpen) await open();
    List<Map<String, Object?>>? table =
        await db?.rawQuery('SELECT * FROM $tableName');
    notifyListeners();
    return table?.map((data) => TimeBlock().toBlock(data)).toList();
  }
}
