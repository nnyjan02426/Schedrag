import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class Block {
  String? name;
  String? category = null, notes = null;
  int? id = null;

  Block();
  Block.name(this.name);
  Block.detail({this.name, this.category, this.notes, this.id});

  Map<String, Object?> toMap();
  Block toBlock(Map<String, Object?> data);
}

abstract class BlocksDb {
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
        dbIsOpen = true;
        print('$dbIsOpen');
        return await db.execute('''CREATE TABLE $tableName ($executeSQL)''');
      },
    );
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
