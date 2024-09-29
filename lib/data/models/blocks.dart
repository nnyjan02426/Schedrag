import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class _Time {
  DateTime startTime, endTime;
  late Duration diffTime;
  _Time(this.startTime, this.endTime, this.diffTime);
  _Time.noParams()
      : startTime = DateTime.now(),
        endTime = DateTime.now() {
    updateDiffTime();
  }

  void setStartTime(DateTime newStart) => startTime = newStart;
  void setEndTime(DateTime newEnd) => endTime = newEnd;
  void updateDiffTime() => diffTime = startTime.difference(endTime);
}

class Block {
  final String name;
  final String? category, notes;
  int? id;

  //final _Time time;

  //_Block({required this.id, required this.name, required this.time, this.category=null, this.notes=null});
  Block(
      {required this.name,
      this.id = null,
      this.category = null,
      this.notes = null});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'notes': notes,
    };
  }
  //String block2String(String tablename) {
  //  return [
  //    tablename,
  //    '{id: $id, name: $name, category: $category, notes: $notes}'
  //  ].join();
  //}
}

class BlocksDb {
  String dbFilename, tableName;
  bool dbIsOpen;
  late final db;

  BlocksDb(
      {required this.dbFilename,
      required this.tableName,
      this.dbIsOpen = false});

  Future open() async {
    db = openDatabase(
      join(await getDatabasesPath(), dbFilename),
      version: 1,
      onCreate: (db, version) async {
        return await db.execute('''CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY,
          name TEXT, category TEXT,
          spendTime DATETIME,
          deadline DATETIME,
          notes TEXT)''');
      },
    );
    dbIsOpen = true;
  }

  Future<Block> insert(Block aBlock) async {
    if (!dbIsOpen) open();

    aBlock.id = await db.insert(tableName, aBlock.toMap());
    return aBlock;
  }

  Future<int> delete(int id) async {
    if (!dbIsOpen) open();

    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Block aBlock) async {
    if (!dbIsOpen) open();

    return await db.update(tableName, aBlock.toMap(),
        where: 'id = ?', whereArgs: [aBlock.id]);
  }

  Future close() async {
    dbIsOpen = false;
    return await db.close();
  }
}
