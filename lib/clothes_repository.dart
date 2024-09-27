import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:path/path.dart';

class ClothesRepository {
  static Database? _database;

  static const String _tableName = 'clothes';
  static const String _dbName = 'clothes_test.db';

  Future<List<Clothes>> loadClothes() async {
    final res = await (await database).rawQuery("SELECT * FROM ${_tableName}");
    return List.generate(res.length, (index) {
      print("loadClothes : ${res[index]}");
      return Clothes.fromJson(res[index]);
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
      version: 3,
      onCreate: (db, version) async {
        // 'todos' 테이블을 생성하는 SQL 쿼리를 실행합니다.
        await db.execute('''
          CREATE TABLE clothes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT not null,
            primaryCategoryId INTEGER not null,
            secondaryCategoryId INTEGER not null,
            colorValue INTEGER not null,
            price INTEGER,
            millisecondsSinceEpoch INTEGER not null,
            drawLines TEXT not null,
            details TEXT not null
          )
        ''');
      },
    );
  }

  Future<void> addClothes(Clothes clothes) async {
    print("addClothes: ${clothes}");

    final db = await database;
    clothes.id = null;

    final res = await db.insert(_tableName, clothes.toJson());
  }

  Future<void> updateClothes(Clothes clothes) async {
    final db = await database;
    await db.update(_tableName, clothes.toJson(),
        where: 'id = ?', whereArgs: [clothes.id]);
  }

  Future<void> addClothesList(Set<Clothes> clothesList) async {
    final db = await database;
    print("addClothesList: ${clothesList.length}");
    // final batch = db.batch();
    // clothesList.map((e) => batch.insert(_tableName, e.toJson()));
    // await batch.commit();
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
}
