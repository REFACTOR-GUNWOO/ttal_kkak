import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum ClosetAnalysisType {
  clothingCountLow, // (우선순위 1) 옷 개수가 적음
  primaryCategoryClothesCountLow, // (1-2) 상위 카테고리 옷 개수가 적음
  secondCategoryClothesCountHigh, // (1-3) 하위 카테고리 옷 개수가 많음
  secondCategoriesClothesCountHigh,
  colorDominant, // (우선순위 2) 특정 컬러가 많음
  monochromeDominant, // (2-2) 모노톤 컬러가 많음
  darkToneDominant,
  lightToneDominant, // (2-3) 컬러 진하기가 강함
  colorLimited, // (2-4) 컬러가 부족함
  colorVaried, // (2-4) 컬러가 다양함
  clothingCountHigh, // (우선순위 3) 옷이 부족함
  unknownStyle; // (기타) 스타일을 알 수 없음
}

class DisplayMessage {
  final int? id;
  final String title;
  final String description;
  final bool showAddClothesButton;
  final List<String> addClothesDescriptions;
  final DateTime createdAt;
  final String iconUrl;
  final ClosetAnalysisType analysisType;

  DisplayMessage({
    this.id,
    required this.title,
    required this.description,
    this.showAddClothesButton = true,
    required this.analysisType,
    required this.addClothesDescriptions,
    required this.iconUrl,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'showAddClothesButton': showAddClothesButton ? 1 : 0,
      'addClothesDescriptions': jsonEncode(addClothesDescriptions),
      'analysisType': analysisType.name,
      'iconUrl': iconUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DisplayMessage.fromMap(Map<String, dynamic> map) {
    return DisplayMessage(
      id: map['id'],
      title: map['title'],
      iconUrl: map['iconUrl'],
      description: map['description'],
      showAddClothesButton: map['showAddClothesButton'] == 1,
      addClothesDescriptions: List<String>.from(jsonDecode(map['addClothesDescriptions'] ?? '[]')),
      createdAt: DateTime.parse(map['createdAt']),
      analysisType: ClosetAnalysisType.values.firstWhere(
        (type) => type.name == map['analysisType'],
        orElse: () => ClosetAnalysisType.unknownStyle,
      ),
    );
  }

  static DisplayMessage unknown() {
    final List<MapEntry<String, String>> unknownStyleTitles = [
      MapEntry("아직 스타일을 알 수 없어요", "image_default.svg")
    ];

    final List<String> unknownStyleDescriptions = ["우리에겐 아직 미스터리한 당신"];

    final List<String> unknownStyleAddClothesDescriptions = [
      "옷을 조금만 더 등록해\n저희에게 힌트를 주세요🥲",
      "옷을 더 등록해서 정확한\n분석 결과를 받아보세요💪🏻"
    ];

    return DisplayMessage.of(
        unknownStyleTitles,
        unknownStyleDescriptions,
        unknownStyleAddClothesDescriptions,
        null,
        ClosetAnalysisType.unknownStyle);
  }

  static DisplayMessage of(
    List<MapEntry<String, String?>> titleAndImageMaps,
    List<String> descriptions,
    List<String> addClothesDescriptions,
    String? defaultUrl,
    ClosetAnalysisType analysisType,
  ) {
    final titleAndImageMap =
        titleAndImageMaps[Random().nextInt(titleAndImageMaps.length)];

    return DisplayMessage(
      title: titleAndImageMap.key,
      iconUrl:
          "assets/icons/statisticsTitle/${titleAndImageMap.value ?? defaultUrl}",
      description: descriptions[Random().nextInt(descriptions.length)],
      showAddClothesButton: true,
      addClothesDescriptions: addClothesDescriptions,
      analysisType: analysisType,
    );
  }
}

class DisplayMessageRepository {
  static final DisplayMessageRepository _instance =
      DisplayMessageRepository._internal();
  static Database? _database;

  // 싱글톤 패턴 구현
  factory DisplayMessageRepository() {
    return _instance;
  }

  DisplayMessageRepository._internal();

  // 데이터베이스 가져오기 (없으면 초기화)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  String getDbName() {
    return 'display_messages_v2_${kDebugMode ? "dev" : "live"}';
  }

  // 데이터베이스 초기화
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), getDbName() + ".db");
    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDb,
    );
  }

  // 테이블 생성
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${getDbName()}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        iconUrl TEXT NOT NULL,
        showAddClothesButton INTEGER NOT NULL,
        addClothesDescriptions TEXT NOT NULL,
        analysisType TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // CRUD 작업 구현
  // 1. 메시지 추가
  Future<int> insertMessage(DisplayMessage message) async {
    final db = await database;
    return await db.insert(
      getDbName(),
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 4. 가장 최근 메시지 조회
  Future<DisplayMessage?> getLatestMessage() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      getDbName(),
      orderBy: 'createdAt DESC',
      limit: 1,
    );

    print("maps: $maps");
    if (maps.isNotEmpty) {
      return DisplayMessage.fromMap(maps.first);
    }
    return null;
  }
}
