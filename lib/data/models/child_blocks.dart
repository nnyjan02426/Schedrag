import 'package:schedrag/data/models/blocks.dart';

class TimeBlock extends Block {
  /* TODO: add time variables
   * 1. estimated/spend time
   * 2. deadline
   * */

  TimeBlock(super.name);

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
}
