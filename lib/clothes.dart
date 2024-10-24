import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';

abstract class ClothesFamily {}

class Clothes implements ClothesFamily {
  int? id;
  String name;
  int primaryCategoryId;
  int secondaryCategoryId;
  ClothesDetails details; // 상세 설정
  Color color;
  int? price;
  DateTime regTs = DateTime.now();
  List<DrawnLine> drawLines;

  Clothes(
      {required this.id,
      required this.name,
      required this.primaryCategoryId,
      required this.secondaryCategoryId,
      required this.details,
      required this.color,
      required this.price,
      required this.drawLines,
      required this.regTs});

  factory Clothes.fromJson(Map<String, dynamic> json) {
    return Clothes(
        id: json['id'],
        name: json['name'],
        primaryCategoryId: json['primaryCategoryId'],
        secondaryCategoryId: json['secondaryCategoryId'],
        details: ClothesDetails.fromJson(jsonDecode(json['details'])),
        color: Color(json['colorValue']),
        price: json["price"],
        regTs: DateTime.fromMillisecondsSinceEpoch(
            json['millisecondsSinceEpoch'] as int),
        drawLines: (jsonDecode(json['drawLines']) as List)
            .map((lineJson) => DrawnLine.fromJson(lineJson))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryCategoryId': primaryCategoryId,
      'secondaryCategoryId': secondaryCategoryId,
      'details': jsonEncode(details.toJson()),
      'colorValue': color.value,
      'price': price,
      'millisecondsSinceEpoch': regTs.millisecondsSinceEpoch,
      'drawLines': jsonEncode(drawLines.map((e) => (e.toJson())).toList())
    };
  }

  void updateName(String name) {
    this.name = name;
  }

  void updatePrimaryCategoryId(int primaryCategoryId) {
    this.primaryCategoryId = primaryCategoryId;
  }

  void updateSecondaryCategoryId(int secondaryCategoryId) {
    this.secondaryCategoryId = secondaryCategoryId;
  }

  void updateDetails(ClothesDetails clothesDetails) {
    details = clothesDetails;
  }

  void updateColor(Color color) {
    this.color = color;
  }

  void updatePrice(int price) {
    this.price = price;
  }

  void updateDrawlines(List<DrawnLine> lines) {
    this.drawLines = lines;
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

mixin Descriptive {
  String get label;
}

// 상의 길이
enum TopLength with Descriptive {
  crop("크롭"),
  short("중간길이"),
  medium("짧은길이"),
  long("긴길이");

  final String label;

  const TopLength(this.label);
}

// 팔 길이
enum SleeveLength with Descriptive {
  short("반팔"),
  medium("중간팔"),
  long("긴팔"),
  sleeveless("민소매");

  final String label;

  const SleeveLength(this.label);
}

// 넥 라인
enum Neckline with Descriptive {
  round("라운드넥"),
  vNeck("브이넥"),
  square("스퀘어넥");

  final String label;

  const Neckline(this.label);
}

List<Clothes> generateDummyClothes() {
  return [
    Clothes(
        id: 1,
        name: '블랙 티셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 1,
        details: ClothesDetails(
          topLength: TopLength.medium,
          sleeveLength: SleeveLength.short,
          neckline: Neckline.round,
        ),
        price: 123,
        color: Colors.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 2,
        name: '화이트 셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 1,
        details: ClothesDetails(
          topLength: TopLength.medium,
          sleeveLength: SleeveLength.short,
          neckline: Neckline.round,
        ),
        price: 123,
        color: Colors.white,
        regTs: DateTime.now(),
        drawLines: []),
    //   Clothes(
    //       id: 3,
    //       name: '데님 재킷',
    //       primaryCategoryId: 2,
    //       secondaryCategoryId: 1,
    //       details: ClothesDetails(
    //         topLength: TopLength.medium,
    //         sleeveLength: SleeveLength.long,
    //         neckline: Neckline.round,
    //       ),
    //       price: 125,
    //       color: Colors.blue,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 4,
    //       name: '스키니 진',
    //       primaryCategoryId: 2,
    //       secondaryCategoryId: 2,
    //       details: ClothesDetails(
    //         topLength: TopLength.long,
    //         sleeveLength: SleeveLength.sleeveless,
    //         neckline: Neckline.round,
    //       ),
    //       price: 126,
    //       color: Colors.indigo,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 5,
    //       name: '블랙 스커트',
    //       primaryCategoryId: 2,
    //       secondaryCategoryId: 1,
    //       details: ClothesDetails(
    //         topLength: TopLength.short,
    //         sleeveLength: SleeveLength.sleeveless,
    //         neckline: Neckline.round,
    //       ),
    //       price: 127,
    //       color: Colors.black,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 6,
    //       name: '레드 드레스',
    //       primaryCategoryId: 3,
    //       secondaryCategoryId: 5,
    //       details: ClothesDetails(
    //         topLength: TopLength.long,
    //         sleeveLength: SleeveLength.short,
    //         neckline: Neckline.vNeck,
    //       ),
    //       price: 12300,
    //       color: Colors.red,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 7,
    //       name: '베이지 코트',
    //       primaryCategoryId: 3,
    //       secondaryCategoryId: 1,
    //       details: ClothesDetails(
    //         topLength: TopLength.long,
    //         sleeveLength: SleeveLength.long,
    //         neckline: Neckline.round,
    //       ),
    //       price: 1230,
    //       color: Colors.brown,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 8,
    //       name: '흰색 반팔 티셔츠',
    //       primaryCategoryId: 4,
    //       secondaryCategoryId: 1,
    //       details: ClothesDetails(
    //         topLength: TopLength.short,
    //         sleeveLength: SleeveLength.short,
    //         neckline: Neckline.round,
    //       ),
    //       price: 1231234,
    //       color: Colors.white,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 9,
    //       name: '카키색 치마',
    //       primaryCategoryId: 4,
    //       secondaryCategoryId: 1,
    //       details: ClothesDetails(
    //         topLength: TopLength.medium,
    //         sleeveLength: SleeveLength.sleeveless,
    //         neckline: Neckline.round,
    //       ),
    //       price: 1,
    //       color: Colors.green,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 10,
    //       name: '핑크 블라우스',
    //       primaryCategoryId: 4,
    //       secondaryCategoryId: 2,
    //       details: ClothesDetails(
    //         topLength: TopLength.medium,
    //         sleeveLength: SleeveLength.long,
    //         neckline: Neckline.vNeck,
    //       ),
    //       price: 123,
    //       color: Colors.pink,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 11,
    //       name: '블랙 티셔츠',
    //       primaryCategoryId: 4,
    //       secondaryCategoryId: 2,
    //       details: ClothesDetails(
    //         topLength: TopLength.medium,
    //         sleeveLength: SleeveLength.short,
    //         neckline: Neckline.round,
    //       ),
    //       price: 123,
    //       color: Colors.black,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 12,
    //       name: '화이트 셔츠',
    //       primaryCategoryId: 5,
    //       secondaryCategoryId: 1,
    //       details: ClothesDetails(
    //         topLength: TopLength.long,
    //         sleeveLength: SleeveLength.long,
    //         neckline: Neckline.vNeck,
    //       ),
    //       price: 123,
    //       color: Colors.white,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 13,
    //       name: '데님 재킷',
    //       primaryCategoryId: 5,
    //       secondaryCategoryId: 2,
    //       details: ClothesDetails(
    //         topLength: TopLength.medium,
    //         sleeveLength: SleeveLength.long,
    //         neckline: Neckline.round,
    //       ),
    //       price: 123,
    //       color: Colors.blue,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 14,
    //       name: '스키니 진',
    //       primaryCategoryId: 5,
    //       secondaryCategoryId: 1,
    //       details: ClothesDetails(
    //         topLength: TopLength.long,
    //         sleeveLength: SleeveLength.sleeveless,
    //         neckline: Neckline.round,
    //       ),
    //       price: 123,
    //       color: Colors.indigo,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 15,
    //       name: '블랙 스커트',
    //       primaryCategoryId: 5,
    //       secondaryCategoryId: 2,
    //       details: ClothesDetails(
    //         topLength: TopLength.short,
    //         sleeveLength: SleeveLength.sleeveless,
    //         neckline: Neckline.round,
    //       ),
    //       price: 123,
    //       color: Colors.black,
    //       regTs: DateTime.now()),
    //   Clothes(
    //       id: 16,
    //       name: '레드 드레스',
    //       primaryCategoryId: 5,
    //       secondaryCategoryId: 5,
    //       details: ClothesDetails(
    //         topLength: TopLength.long,
    //         sleeveLength: SleeveLength.short,
    //         neckline: Neckline.vNeck,
    //       ),
    //       price: 123,
    //       color: Colors.red,
    //       regTs: DateTime.now()),
  ];
}

class ColorContainer {
  final List<Color> colors;
  final Color representativeColor;

  ColorContainer(this.colors, this.representativeColor);
}

List<ColorContainer> colorContainers = [
  // 검정색
  ColorContainer([Color(0xFF282828), Color(0xFF161616)], Color(0xFF161616)),
  // 흰색
  ColorContainer([Color(0xFFFFFFFF), Color(0xFFE7E7E7)], Color(0xFFE7E7E7)),
  // 회색
  ColorContainer([Color(0xFFC4C4C4), Color(0xFF8D8D8D), Color(0xFF606060)],
      Color(0xFF8D8D8D)),
  // 빨간색
  ColorContainer([Color(0xFFDE9494), Color(0xFFC46060), Color(0xFFA84A4A)],
      Color(0xFFC46060)),
  // 주황색
  ColorContainer([Color(0xFFE4B198), Color(0xFFD48E6A), Color(0xFFA76443)],
      Color(0xFFD48E6A)),
  // 주황색#2
  ColorContainer([Color(0xFFF0E3A3), Color(0xFFE4D58B), Color(0xFFC4A151)],
      Color(0xFFE4D58B)),
  // 초록색
  ColorContainer([Color(0xFFB6D9A1), Color(0xFF68A168), Color(0xFF467346)],
      Color(0xFF68A168)),
  // 초록색#2
  ColorContainer([Color(0xFF9FB294), Color(0xFF627762), Color(0xFF3D513D)],
      Color(0xFF627762)),
  // 파란색
  ColorContainer([Color(0xFFADCAD8), Color(0xFF5C8DBD), Color(0xFF304F85)],
      Color(0xFF5C8DBD)),
  // 파란색#2
  ColorContainer([Color(0xFF8095A9), Color(0xFF43617F), Color(0xFF32485D)],
      Color(0xFF43617F)),
  // 보라색
  ColorContainer([Color(0xFFB9A8DB), Color(0xFF957CC8), Color(0xFF5C4588)],
      Color(0xFF957CC8)),
  // 쿨핑크
  ColorContainer([Color(0xFFD8B9D8), Color(0xFFAC6BAC), Color(0xFFA04D89)],
      Color(0xFFAC6BAC)),
  // 웜핑크
  ColorContainer([Color(0xFFE1B5C2), Color(0xFFBE7187), Color(0xFFA04D65)],
      Color(0xFFBE7187)),
];
