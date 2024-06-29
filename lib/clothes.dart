import 'package:flutter/material.dart';

class Clothes {
  int id;
  String name;
  String primaryCategory;
  String secondaryCategory;
  ClothesDetails details; // 상세 설정
  Color color;
  DateTime regTs = DateTime.now();

  Clothes(
      {required this.id,
      required this.name,
      required this.primaryCategory,
      required this.secondaryCategory,
      required this.details,
      required this.color,
      required this.regTs});

  factory Clothes.fromJson(Map<String, dynamic> json) {
    return Clothes(
        id: json['id'],
        name: json['name'],
        primaryCategory: json['primaryCategory'],
        secondaryCategory: json['secondaryCategory'],
        details: ClothesDetails.fromJson(json['details']),
        color: Color(json['color']),
        regTs: DateTime.fromMillisecondsSinceEpoch(json['regTs'] as int));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryCategory': primaryCategory,
      'secondaryCategory': secondaryCategory,
      'details': details.toJson(),
      'color': color.value,
      'regTs': regTs.millisecondsSinceEpoch
    };
  }
}

class ClothesDetails {
  TopLength topLength;
  SleeveLength sleeveLength;
  Neckline neckline;

  ClothesDetails({
    required this.topLength,
    required this.sleeveLength,
    required this.neckline,
  });

  factory ClothesDetails.fromJson(Map<String, dynamic> json) {
    return ClothesDetails(
      topLength:
          TopLength.values.firstWhere((e) => e.toString() == json['topLength']),
      sleeveLength: SleeveLength.values
          .firstWhere((e) => e.toString() == json['sleeveLength']),
      neckline:
          Neckline.values.firstWhere((e) => e.toString() == json['neckline']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topLength': topLength.toString(),
      'sleeveLength': sleeveLength.toString(),
      'neckline': neckline.toString(),
    };
  }
}

// 상의 길이
enum TopLength {
  short,
  medium,
  long,
}

// 팔 길이
enum SleeveLength {
  short,
  medium,
  long,
  sleeveless,
}

// 넥 라인
enum Neckline {
  round,
  vNeck,
  offShoulder,
}

List<Clothes> generateDummyClothes() {
  return [
    Clothes(
        id: 1,
        name: '블랙 티셔츠',
        primaryCategory: '상의',
        secondaryCategory: '티셔츠',
        details: ClothesDetails(
          topLength: TopLength.medium,
          sleeveLength: SleeveLength.short,
          neckline: Neckline.round,
        ),
        color: Colors.black,
        regTs: DateTime.now()),
    Clothes(
        id: 2,
        name: '화이트 셔츠',
        primaryCategory: '상의',
        secondaryCategory: '셔츠',
        details: ClothesDetails(
          topLength: TopLength.long,
          sleeveLength: SleeveLength.long,
          neckline: Neckline.vNeck,
        ),
        color: Colors.white,
        regTs: DateTime.now()),
    Clothes(
        id: 3,
        name: '데님 재킷',
        primaryCategory: '아우터',
        secondaryCategory: '재킷',
        details: ClothesDetails(
          topLength: TopLength.medium,
          sleeveLength: SleeveLength.long,
          neckline: Neckline.round,
        ),
        color: Colors.blue,
        regTs: DateTime.now()),
    Clothes(
        id: 4,
        name: '스키니 진',
        primaryCategory: '하의',
        secondaryCategory: '바지',
        details: ClothesDetails(
          topLength: TopLength.long,
          sleeveLength: SleeveLength.sleeveless,
          neckline: Neckline.round,
        ),
        color: Colors.indigo,
        regTs: DateTime.now()),
    Clothes(
        id: 5,
        name: '블랙 스커트',
        primaryCategory: '하의',
        secondaryCategory: '스커트',
        details: ClothesDetails(
          topLength: TopLength.short,
          sleeveLength: SleeveLength.sleeveless,
          neckline: Neckline.round,
        ),
        color: Colors.black,
        regTs: DateTime.now()),
    Clothes(
        id: 6,
        name: '레드 드레스',
        primaryCategory: '원피스',
        secondaryCategory: '드레스',
        details: ClothesDetails(
          topLength: TopLength.long,
          sleeveLength: SleeveLength.short,
          neckline: Neckline.offShoulder,
        ),
        color: Colors.red,
        regTs: DateTime.now()),
    Clothes(
        id: 7,
        name: '베이지 코트',
        primaryCategory: '아우터',
        secondaryCategory: '코트',
        details: ClothesDetails(
          topLength: TopLength.long,
          sleeveLength: SleeveLength.long,
          neckline: Neckline.round,
        ),
        color: Colors.brown,
        regTs: DateTime.now()),
    Clothes(
        id: 8,
        name: '흰색 반팔 티셔츠',
        primaryCategory: '상의',
        secondaryCategory: '티셔츠',
        details: ClothesDetails(
          topLength: TopLength.short,
          sleeveLength: SleeveLength.short,
          neckline: Neckline.round,
        ),
        color: Colors.white,
        regTs: DateTime.now()),
    Clothes(
        id: 9,
        name: '카키색 치마',
        primaryCategory: '하의',
        secondaryCategory: '치마',
        details: ClothesDetails(
          topLength: TopLength.medium,
          sleeveLength: SleeveLength.sleeveless,
          neckline: Neckline.round,
        ),
        color: Colors.green,
        regTs: DateTime.now()),
    Clothes(
        id: 10,
        name: '핑크 블라우스',
        primaryCategory: '상의',
        secondaryCategory: '블라우스',
        details: ClothesDetails(
          topLength: TopLength.medium,
          sleeveLength: SleeveLength.long,
          neckline: Neckline.vNeck,
        ),
        color: Colors.pink,
        regTs: DateTime.now()),
    Clothes(
        id: 11,
        name: '블랙 티셔츠',
        primaryCategory: '상의',
        secondaryCategory: '티셔츠',
        details: ClothesDetails(
          topLength: TopLength.medium,
          sleeveLength: SleeveLength.short,
          neckline: Neckline.round,
        ),
        color: Colors.black,
        regTs: DateTime.now()),
    Clothes(
        id: 12,
        name: '화이트 셔츠',
        primaryCategory: '상의',
        secondaryCategory: '셔츠',
        details: ClothesDetails(
          topLength: TopLength.long,
          sleeveLength: SleeveLength.long,
          neckline: Neckline.vNeck,
        ),
        color: Colors.white,
        regTs: DateTime.now()),
    Clothes(
        id: 13,
        name: '데님 재킷',
        primaryCategory: '아우터',
        secondaryCategory: '재킷',
        details: ClothesDetails(
          topLength: TopLength.medium,
          sleeveLength: SleeveLength.long,
          neckline: Neckline.round,
        ),
        color: Colors.blue,
        regTs: DateTime.now()),
    Clothes(
        id: 14,
        name: '스키니 진',
        primaryCategory: '하의',
        secondaryCategory: '바지',
        details: ClothesDetails(
          topLength: TopLength.long,
          sleeveLength: SleeveLength.sleeveless,
          neckline: Neckline.round,
        ),
        color: Colors.indigo,
        regTs: DateTime.now()),
    Clothes(
        id: 15,
        name: '블랙 스커트',
        primaryCategory: '하의',
        secondaryCategory: '스커트',
        details: ClothesDetails(
          topLength: TopLength.short,
          sleeveLength: SleeveLength.sleeveless,
          neckline: Neckline.round,
        ),
        color: Colors.black,
        regTs: DateTime.now()),
    Clothes(
        id: 16,
        name: '레드 드레스',
        primaryCategory: '원피스',
        secondaryCategory: '드레스',
        details: ClothesDetails(
          topLength: TopLength.long,
          sleeveLength: SleeveLength.short,
          neckline: Neckline.offShoulder,
        ),
        color: Colors.red,
        regTs: DateTime.now()),
  ];
}
