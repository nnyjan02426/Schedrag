import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class Block {
  final String name;
  String? category = null, notes = null;
  int? id = null;

  Block(this.name);

  Map<String, Object?> toMap();
}

class BlocksDb {
  String dbFilename, tableName, executeSQL;
  bool dbIsOpen = false;
  late final db;

  BlocksDb(
      {required this.dbFilename,
      required this.tableName,
      required this.executeSQL});

  Future open() async {
    db = openDatabase(
      join(await getDatabasesPath(), dbFilename),
      version: 1,
      onCreate: (db, version) async {
        return await db.execute('''CREATE TABLE $tableName ($executeSQL)''');
      },
    );
    dbIsOpen = true;
  }

  Future<List<Map>> getAll() async {
    if (!dbIsOpen) open();

    return await db.rawQuery('SELECT * FROM $tableName');
  }

  Future<Block> insert(Block block) async {
    if (!dbIsOpen) open();

    block.id = await db.insert(tableName, block.toMap());
    return block;
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

  Future<int> getCount() async =>
      await db.execute('SELECT COUNT(*) from $tableName');
}
