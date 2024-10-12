import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

abstract class Block {
  String? name;
  String? category, notes;
  int? id;

  Block();
  Block.name(this.name);
  Block.detail({this.name, this.category, this.notes});

  Map<String, Object?> toMap();
  Block toBlock(Map<String, Object?> data);
  void setID(int id) {
    this.id = id;
  }
}

abstract class BlocksDb extends ChangeNotifier {
  String dbFilename, tableName, executeSQL;
  bool dbIsOpen;
  Database? db;

  BlocksDb(
      {required this.dbFilename,
      required this.tableName,
      required this.executeSQL})
      : dbIsOpen = false;

  DateTime setTime(
          {int month = 0, int day = 0, int hour = 0, int minute = 0}) =>
      DateTime(2000, month, day, hour, minute);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future open() async {
    db = await openDatabase(
      join(await _localPath, dbFilename),
      //dbFilename,
      version: 1,
      onOpen: (db) {
        dbIsOpen = true;
      },
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $tableName ($executeSQL)''');
      },
    );
    notifyListeners();
    return null;
  }

  Future<Block> insert(Block block) async {
    if (!dbIsOpen) await open();

    block.id = await db?.insert(tableName, block.toMap());
    if (kDebugMode) {
      print('$tableName: ${block.name} inserted');
    }
    notifyListeners();
    return block;
  }

  Future<void> delete(int id) async {
    if (!dbIsOpen) await open();

    await db?.delete(tableName, where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  Future<void> update(Block block) async {
    if (!dbIsOpen) await open();

    await db?.update(tableName, block.toMap(),
        where: 'id = ?', whereArgs: [block.id]);
    notifyListeners();
  }

  Future close() async {
    dbIsOpen = false;
    return await db?.close();
  }

  Future getCount() async =>
      await db?.execute('SELECT COUNT(*) from $tableName');
}
