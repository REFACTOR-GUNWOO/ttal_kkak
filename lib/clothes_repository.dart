import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:path/path.dart';
import 'dart:io';

class ClothesRepository {
  static Database? _database;

  static const String _tableName = 'clothes';
  static const String _dbName = 'clothes_test${kDebugMode ? "debug" : ""}.db';

  Future<List<Clothes>> loadClothes() async {
    final res = await (await database).rawQuery("SELECT * FROM ${_tableName}");
    return List.generate(res.length, (index) {
      Clothes clothes = Clothes.fromJson(res[index]);
      compareDataSizes(clothes.drawLines);
      return clothes;
    });
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  /// 데이터베이스를 초기화하고 'todos' 테이블이 없으면 생성합니다.
  Future<Database> initDatabase() async {
    // 데이터베이스 파일 경로를 얻어옵니다 ('todo.db').
    String path = join(await getDatabasesPath(), _dbName);
    // 지정된 버전 및 생성 콜백으로 데이터베이스를 엽니다.
    return await openDatabase(
      path,
      version: 26,
      onCreate: (db, version) async {
        // 'todos' 테이블을 생성하는 SQL 쿼리를 실행합니다.
        await _createTableV2(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print("upgrade $oldVersion to $newVersion");
        var batch = db.batch();
        if (oldVersion <= 25) {
          updateTableToV2(batch);
        }
        await batch.commit();
      },
    );
  }

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        primaryCategoryId INTEGER NOT NULL,
        secondaryCategoryId INTEGER NOT NULL,
        colorValue INTEGER NOT NULL,
        price INTEGER,
        millisecondsSinceEpoch INTEGER NOT NULL,
        drawLines TEXT NOT NULL,
        details TEXT NOT NULL
      )
    ''');
  }

  void updateTableToV2(Batch batch) async {
    batch.execute('ALTER TABLE $_tableName ADD isDraft INTEGER');
  }

  Future<void> _createTableV2(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        primaryCategoryId INTEGER NOT NULL,
        secondaryCategoryId INTEGER NOT NULL,
        colorValue INTEGER NOT NULL,
        price INTEGER,
        millisecondsSinceEpoch INTEGER NOT NULL,
        drawLines TEXT NOT NULL,
        details TEXT NOT NULL,
        isDraft INTEGER
      )
    ''');
  }

  Future<void> _dropTable(Database db) async {
    await db.execute('DROP TABLE IF EXISTS $_tableName');
  }

  Future<Clothes> addClothes(Clothes clothes) async {
    final db = await database;
    clothes.id = null;
    final res = await db.insert(_tableName, clothes.toJson());
    clothes.id = res;
    return clothes;
  }

  Future<void> updateClothes(Clothes clothes) async {
    final db = await database;
    await db.update(_tableName, clothes.toJson(),
        where: 'id = ?', whereArgs: [clothes.id]);
  }

  Future<void> addClothesList(Set<Clothes> clothesList) async {
    final db = await database;
    Future.wait(clothesList.map((e) async => await addClothes(e)));
  }

  Future<void> removeClothes(Clothes clothes) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [clothes.id]);
  }

  Future<void> deleteAllClothes() async {
    final db = await database;
    await db.delete(_tableName);
  }

  Future<void> compareDataSizes(List<DrawnLine> lines) async {
    // 원본 데이터를 JSON으로 인코딩
    final jsonData = jsonEncode(lines.map((line) => line.toJson()).toList());
    final originalDataSize = utf8.encode(jsonData).length;

    // 데이터를 압축하여 인코딩
    final compressed = gzip.encode(utf8.encode(jsonData));
    final compressedDataSize = compressed.length;

    print('Original Data Size: $originalDataSize bytes');
    print('Compressed Data Size: $compressedDataSize bytes');
  }
}
