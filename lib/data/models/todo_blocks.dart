import 'package:schedrag/data/models/blocks.dart';
import 'package:flutter/material.dart' show Color;

class TodoBlock extends Block {
  late DateTime estimatedTime, deadline;

  TodoBlock()
      : estimatedTime = DateTime.now(),
        deadline = DateTime.now();

  TodoBlock.detail({
    required super.name,
    super.id,
    super.category,
    super.notes,
    DateTime? estimatedTime,
    DateTime? deadline,
    super.color,
  }) : super.detail() {
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
  void setDetail(
      {String? name,
      String? category,
      String? notes,
      DateTime? estimatedTime,
      DateTime? deadline,
      Color? color}) {
    super.setDetail(name: name, category: category, notes: notes, color: color);
    if (estimatedTime != null) this.estimatedTime = estimatedTime;
    if (deadline != null) this.deadline = deadline;
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
      'color': color?.value.toRadixString(16),
    };
  }

  @override
  TodoBlock toBlock(Map<String, Object?> data) {
    return TodoBlock.detail(
      name: data['name'].toString(),
      id: int.parse(data['id'].toString()),
      category: data['category'].toString(),
      estimatedTime: DateTime.tryParse(data['estimatedTime'].toString()),
      deadline: DateTime.tryParse(data['deadline'].toString()),
      notes: data['notes'].toString(),
      color: Color(int.parse(data['color'].toString(), radix: 16)),
    );
  }
}

class TodoBlocksDb extends BlocksDb {
  static const String _executeSQL = '''
    id INTEGER PRIMARY KEY,
    name TEXT, category TEXT,
    estimatedTime DATETIME,
    deadline DATETIME,
    notes TEXT, color TEXT
    ''';

  TodoBlocksDb()
      : super(
            dbFilename: 'TodoBlock.db',
            tableName: 'Todos',
            executeSQL: _executeSQL);

  Future<List<TodoBlock>?> getAll() async {
    if (!dbIsOpen) await open();

    List<Map<String, Object?>>? table =
        await db?.rawQuery('SELECT * FROM $tableName');
    notifyListeners();
    return table?.map((data) => TodoBlock().toBlock(data)).toList();
  }
}
