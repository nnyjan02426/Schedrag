import 'package:schedrag/data/models/blocks.dart';

class TimeBlock extends Block {
  /* TODO: add time variables
   * 1. estimated/spend time
   * 2. deadline
   * */

  TimeBlock();
  TimeBlock.name(super.name) : super.name();
  TimeBlock.detail({super.name, super.category, super.notes}) : super.detail();
  //: super.detail(name: name, category: category, notes: notes);

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      //'estimatedTime': estimatedTime,
      //'deadline': deadline,
      'notes': notes,
    };
  }

  @override
  TimeBlock toBlock(Map<String, Object?> data) {
    return TimeBlock.detail(
      name: data['name'].toString(),
      category: data['category'].toString(),
      notes: data['notes'].toString(),
      //id: int.tryParse(data['id'].toString()),
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
