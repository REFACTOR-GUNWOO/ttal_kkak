import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';

abstract class ClothesFamily {}

class Clothes implements ClothesFamily{
  String id;
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
        details: ClothesDetails.fromJson(json['details']),
        color: Color(json['color']),
        price: json["price"],
        regTs: DateTime.fromMillisecondsSinceEpoch(json['regTs'] as int),
        drawLines: (json['drawLines'] as List)
            .map((lineJson) => DrawnLine.fromJson(lineJson))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryCategoryId': primaryCategoryId,
      'secondaryCategoryId': secondaryCategoryId,
      'details': details.toJson(),
      'color': color.value,
      'price': price,
      'regTs': regTs.millisecondsSinceEpoch,
      'drawLines': drawLines.map((e) => e.toJson()).toList()
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
        id: "123",
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
    // Clothes(
    //     id: "1234",
    //     name: '화이트 셔츠',
    //     primaryCategoryId: 1,
    //     secondaryCategoryId: 2,
    //     details: ClothesDetails(
    //       topLength: TopLength.long,
    //       sleeveLength: SleeveLength.long,
    //       neckline: Neckline.vNeck,
    //     ),
    //     price: 124,
    //     color: Colors.white,
    //     regTs: DateTime.now(),
    //     drawLines: []),
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
