import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

abstract class Block {
  String? name;
  String? category, notes;
  int? id;
  Color? color;

  Block() : color = Colors.white;
  Block.detail(
      {required String this.name,
      int? id,
      String? category,
      String? notes,
      this.color = Colors.white}) {
    if (id != null) this.id = id;
    if (category != null) this.category = category;
    if (notes != null) this.notes = notes;
  }

  Map<String, Object?> toMap();
  Block toBlock(Map<String, Object?> data);
  void setDetail(
      {String? name, String? category, String? notes, Color? color}) {
    if (name != null) this.name = name;
    if (category != null) this.category = category;
    if (notes != null) this.notes = notes;
    if (color != null) this.color = color;
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future open() async {
    db = await openDatabase(
      join(await _localPath, dbFilename),
      //dbFilename,
      version: 2,
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

    int? id = await db?.insert(tableName, block.toMap());
    if (id == null) print("Faild to insert block");

    block.id = id;
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

  Future<int?> update(Block block) async {
    if (!dbIsOpen) await open();
    if (block.id == null) {
      throw Exception("The block ID is null, cannot update the record.");
    }

    int? counter = await db?.update(tableName, block.toMap(),
        where: 'id = ?', whereArgs: [block.id]);
    notifyListeners();
    return counter;
  }

  Future close() async {
    dbIsOpen = false;
    return await db?.close();
  }

  Future getCount() async =>
      await db?.execute('SELECT COUNT(*) from $tableName');
}
