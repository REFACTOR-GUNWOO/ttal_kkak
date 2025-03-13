import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum ClosetAnalysisType {
  clothingCountLow, // (우선순위 1) 옷 개수가 많음
  primaryCategoryClothesCountLow, // (1-2) 상위 카테고리 옷 개수가 많음
  secondCategoryClothesCountHigh,
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
  final String addClothesDescription;
  final DateTime createdAt;
  final ClosetAnalysisType analysisType;

  DisplayMessage({
    this.id,
    required this.title,
    required this.description,
    this.showAddClothesButton = true,
    required this.analysisType,
    required this.addClothesDescription,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  static DisplayMessage unknown() {
    final List<String> unknownStyleTitles = ["아직 스타일을 알 수 없어요"];

    final List<String> unknownStyleDescriptions = ["우리에겐 아직 미스터리한 당신"];

    final List<String> unknownStyleAddClothesDescriptions = [
      "옷을 조금만 더 등록해\n저희에게 힌트를 주세요🥲",
      "옷을 더 등록해서 정확한\n분석 결과를 받아보세요💪🏻"
    ];

    return DisplayMessage.of(unknownStyleTitles, unknownStyleDescriptions,
        unknownStyleAddClothesDescriptions, ClosetAnalysisType.unknownStyle);
  }

  static DisplayMessage of(
    List<String> titles,
    List<String> descriptions,
    List<String> addClothesDescriptions,
    ClosetAnalysisType analysisType,
  ) {
    return DisplayMessage(
      title: titles[Random().nextInt(titles.length)],
      description: descriptions[Random().nextInt(descriptions.length)],
      showAddClothesButton: true,
      addClothesDescription: addClothesDescriptions[
          Random().nextInt(addClothesDescriptions.length)],
      analysisType: analysisType,
    );
  }

  // DisplayMessage를 Map으로 변환 (DB 저장용)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'showAddClothesButton': showAddClothesButton ? 1 : 0,
      'addClothesDescription': addClothesDescription,
      'analysisType': analysisType.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Map에서 DisplayMessage 객체 생성 (DB 조회 결과 변환용)
  factory DisplayMessage.fromMap(Map<String, dynamic> map) {
    return DisplayMessage(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      showAddClothesButton: map['showAddClothesButton'] == 1,
      addClothesDescription: map['addClothesDescription'],
      createdAt: DateTime.parse(map['createdAt']),
      analysisType: ClosetAnalysisType.values.firstWhere(
        (type) => type.name == map['analysisType'],
        orElse: () => ClosetAnalysisType.unknownStyle,
      ),
    );
  }

  // 객체 복제 및 속성 업데이트
  DisplayMessage copyWith({
    int? id,
    String? title,
    String? description,
    bool? showAddClothesButton,
    String? addClothesDescription,
    DateTime? createdAt,
    ClosetAnalysisType? analysisType,
  }) {
    return DisplayMessage(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      showAddClothesButton: showAddClothesButton ?? this.showAddClothesButton,
      addClothesDescription:
          addClothesDescription ?? this.addClothesDescription,
      createdAt: createdAt ?? this.createdAt,
      analysisType: analysisType ?? this.analysisType,
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
    return 'display_messages_${kDebugMode ? "dev" : "live"}';
  }

  // 데이터베이스 초기화
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), getDbName() + ".db");
    return await openDatabase(
      path,
      version: 4,
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
        showAddClothesButton INTEGER NOT NULL,
        addClothesDescription TEXT NOT NULL,
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
