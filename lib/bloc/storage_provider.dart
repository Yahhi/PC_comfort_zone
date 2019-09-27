import 'dart:io';

import 'package:health_app/model/postage_index.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StorageProvider {
  Database db;
  Future _doneFuture;

  Future get initializationDone => _doneFuture;

  static StorageProvider _instance;

  factory StorageProvider({String dbFilePath}) {
    if (_instance == null) {
      _instance = new StorageProvider._internal(dbFilePath);
    }
    return _instance;
  }

  StorageProvider._internal(String dbFilePath) {
    _doneFuture = _openDbFile(dbFilePath);
  }

  Future _openDbFile(String dbPath) async {
    print("filepath is $dbPath");
    if (dbPath == null) {
      var databasesPath = await getDatabasesPath();
      dbPath = join(databasesPath, "db");
      // Make sure the directory exists
      try {
        await Directory(databasesPath).create(recursive: true);
      } catch (_) {}
    }

    db = await openDatabase(dbPath, version: 3,
        onCreate: (Database db, int version) async {
      await db.batch()
        ..execute(PostageIndex.CREATE_EXPRESSION)
        ..commit();
    });
  }

  Future insertPostageIndex(final PostageIndex postageIndex,
      {Database availableDb}) async {
    Database database = availableDb ?? db;
    await database.insert(PostageIndex.TABLE_NAME, postageIndex.toMap());
  }

  Future<List<int>> getPostureIndexes() async {
    await _doneFuture;
    List<int> list = new List();
    List<Map> maps = await db.rawQuery(
        "SELECT ${PostageIndex.COLUMN_RATE}, FROM ${PostageIndex.TABLE_NAME} ORDER BY "
        "${PostageIndex.COLUMN_ID} DESC");
    for (Map map in maps) {
      list.add(map[PostageIndex.COLUMN_RATE]);
    }
    return list;
  }
}
