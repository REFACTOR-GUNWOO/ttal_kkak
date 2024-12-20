import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/category.dart';

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
        details: ClothesDetails.fromJson(
            json['secondaryCategoryId'], jsonDecode(json['details'])),
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
  List<ClothesDetail> details;

  ClothesDetails({required this.details});

  factory ClothesDetails.fromJson(
      int secondCategoryId, Map<String, dynamic> json) {
    List<ClothesDetail> allDetails = secondCategories
        .firstWhere((element) => element.id == secondCategoryId)
        .details
        .expand((e) => e.details)
        .toList();

    List<String> detailCodes =
        (json["details"] as List<dynamic>).map((e) => e.toString()).toList();

    return ClothesDetails(
        details: detailCodes
            .map((code) => allDetails.firstWhere(
                (element) => element.code == code,
                orElse: () => allDetails.first))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {"details": details.map((e) => e.code).toList()};
  }
}

mixin ClothesDetail {
  String get label;
  String get code;
}

// 상의 길이
enum TopLength with ClothesDetail {
  crop("크롭", 4, "top_length_crop"),
  short("짧은길이", 3, "top_length_short"),
  medium("중간길이", 2, "top_length_medium"),
  long("긴길이", 1, "top_length_long");

  final String label;
  final int priority;
  final String code;

  const TopLength(this.label, this.priority, this.code);
}

// 팔 길이
enum SleeveLength with ClothesDetail {
  short("반팔", 1, "sleeve_length_short"),
  medium("중간팔", 2, "sleeve_length_medium"),
  long("긴팔", 3, "sleeve_length_long"),
  sleeveless("민소매", 4, "sleeve_length_sleeveless");

  final String label;
  final int priority;
  final String code;

  const SleeveLength(this.label, this.priority, this.code);
}

// 넥 라인
enum Neckline with ClothesDetail {
  polo("카라", 0, "neck_line_polo"),
  deepCollar("깊은 카라", 0, "neck_line_deep_collar"),
  round("라운드넥", 1, "neck_line_round"),
  uNeck("u넥", 2, "neck_line_uNeck"),
  vNeck("브이넥", 3, "neck_line_vNeck"),
  square("스퀘어넥", 4, "neck_line_square"),
  offShoulder("오프숄더", 5, "neck_line_off_shoulder"),
  high("하이", 5, "neck_line_high"),
  hoodie("후드", 5, "neck_line_hoodie"),
  line("끈", 6, "neck_line_line");

  final String label;
  final int priority;
  final String code;

  const Neckline(this.label, this.priority, this.code);
}

enum BottomFit with ClothesDetail {
  wide("와이드", "bottom_fit_wide"),
  straight("일자", "bottom_fit_straight"),
  slim("슬림", "bottom_fit_slim"),
  skinny("스키니", "bottom_fit_skinny"),
  bootCut("부츠", "bottom_fit_bootcut"),
  flare("플레어", "bottom_fit_flare");

  final String label;
  final String code;

  const BottomFit(this.label, this.code);
}

enum BottomLength with ClothesDetail {
  short("짧은길이", "bottom_length_short"),
  medium("중간길이", "bottom_length_medium"),
  long("긴길이", "bottom_length_long"),
  mini("미니", "bottom_length_mini");

  final String label;
  final String code;

  const BottomLength(this.label, this.code);
}

enum SkirtFit with ClothesDetail {
  aLine("a라인", "skirt_fit_a_line"),
  hLine("h라인", "skirt_fit_h_line"),
  tennis("테니스", "skirt_fit_tennis");

  final String label;
  final String code;

  const SkirtFit(this.label, this.code);
}

enum ShoesLength with ClothesDetail {
  high("하이", "shoes_length_high"),
  long("롱", "shoes_length_long"),
  middle("미들", "shoes_length_middle"),
  short("숏", "shoes_length_short"),
  low("로우", "shoes_length_low");

  final String label;
  final String code;

  const ShoesLength(this.label, this.code);
}

enum ShoesStrap with ClothesDetail {
  withStrap("있음", "shoes_strap_with"),
  withoutStrap("없음", "shoes_strap_without");

  final String label;
  final String code;

  const ShoesStrap(this.label, this.code);
}

enum ShoesHill with ClothesDetail {
  high("높은", "shoes_hill_high"),
  middle("미들", "shoes_hill_middle"),
  low("낮은", "shoes_hill_low");

  final String label;
  final String code;

  const ShoesHill(this.label, this.code);
}

List<Clothes> generateDummyClothes() {
  return [
    Clothes(
        id: 1,
        name: '블랙 티셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 1,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            SleeveLength.short,
            Neckline.round,
          ],
        ),
        price: 123,
        color: colorContainers[0].representativeColor,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 2,
        name: '화이트 셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 1,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: colorContainers[1].representativeColor,
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
