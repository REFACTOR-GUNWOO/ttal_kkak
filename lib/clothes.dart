import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/category.dart';

class Clothes {
  int? id;
  String name;
  int primaryCategoryId;
  int secondaryCategoryId;
  ClothesDetails details; // 상세 설정
  ClothesColor color;
  int? price;
  DateTime regTs = DateTime.now();
  List<DrawnLine> drawLines;
  bool isDraft = false;

  Clothes(
      {this.id,
      required this.name,
      required this.primaryCategoryId,
      required this.secondaryCategoryId,
      required this.details,
      required this.color,
      required this.price,
      required this.drawLines,
      this.isDraft = false,
      required this.regTs});

  factory Clothes.fromJson(Map<String, dynamic> json) {
    print("Clothes.fromJson: ${json['drawLines']}");
    return Clothes(
        id: json['id'],
        name: json['name'],
        primaryCategoryId: json['primaryCategoryId'],
        secondaryCategoryId: json['secondaryCategoryId'],
        details: ClothesDetails.fromJson(
            json['secondaryCategoryId'], jsonDecode(json['details'])),
        color: ClothesColor.fromValue(json['colorValue']),
        price: json["price"],
        regTs: DateTime.fromMillisecondsSinceEpoch(
            json['millisecondsSinceEpoch'] as int),
        isDraft: json["isDraft"] == 1,
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
      'colorValue': color.color.value,
      'price': price,
      'millisecondsSinceEpoch': regTs.millisecondsSinceEpoch,
      'drawLines': jsonEncode(drawLines.map((e) => (e.toJson())).toList()),
      'isDraft': isDraft ? 1 : 0
    };
  }

  void updateName(String name) {
    this.name = name;
  }

  void updatePrimaryCategoryId(int primaryCategoryId) {
    this.primaryCategoryId = primaryCategoryId;
    int secondCategoryId = secondCategories
        .where((element) => element.firstCategoryId == primaryCategoryId)
        .first
        .id;
    this.updateSecondaryCategoryId(secondCategoryId);
  }

  void updateSecondaryCategoryId(int secondaryCategoryId) {
    this.secondaryCategoryId = secondaryCategoryId;
    this.details = ClothesDetails(
        details: secondCategories
            .firstWhere((element) => element.id == secondaryCategoryId)
            .details
            .map((e) => e.defaultDetail)
            .toList());
  }

  void updateDetails(ClothesDetails clothesDetails) {
    details = clothesDetails;
  }

  void updateColor(ClothesColor color) {
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
  String get name;
}

// 상의 길이
enum TopLength with ClothesDetail {
  crop("크롭", 4, "TopLength_crop", "crop"),
  short("짧은 길이", 3, "TopLength_short", "short"),
  medium("중간 길이", 2, "TopLength_medium", "medium"),
  long("긴 길이", 1, "TopLength_long", "long");

  final String label;
  final int priority;
  final String code;
  final String name;

  const TopLength(this.label, this.priority, this.code, this.name);
}

// 팔 길이
enum SleeveLength with ClothesDetail {
  short("반팔", 1, "SleeveLength_short", "short"),
  medium("중간팔", 2, "SleeveLength_medium", "medium"),
  long("긴팔", 3, "SleeveLength_long", "long"),
  sleeveless("민소매", 4, "SleeveLength_sleeveless", "sleeveless");

  final String label;
  final int priority;
  final String code;
  final String name;

  const SleeveLength(this.label, this.priority, this.code, this.name);
}

// 넥 라인
enum Neckline with ClothesDetail {
  polo("카라", 0, "Neckline_polo", "polo"),
  deepCollar("깊은 카라", 0, "Neckline_deepCollar", "deepCollar"),
  round("라운드넥", 1, "Neckline_round", "round"),
  uNeck("u넥", 2, "Neckline_uNeck", "uNeck"),
  vNeck("브이넥", 3, "Neckline_vNeck", "vNeck"),
  square("스퀘어넥", 4, "Neckline_square", "square"),
  offShoulder("오프숄더", 5, "Neckline_offShoulder", "offShoulder"),
  high("하이", 5, "Neckline_high", "high"),
  hoodie("후드", 5, "Neckline_hoodie", "hoodie"),
  line("끈", 6, "Neckline_line", "line");

  final String label;
  final int priority;
  final String code;
  final String name;

  const Neckline(this.label, this.priority, this.code, this.name);
}

enum BottomFit with ClothesDetail {
  wide("와이드", "bottom_fit_wide", "wide"),
  straight("일자", "bottom_fit_straight", "straight"),
  slim("슬림", "bottom_fit_slim", "slim"),
  skinny("스키니", "bottom_fit_skinny", "skinny"),
  bootCut("부츠", "bottom_fit_bootcut", "bootcut"),
  flare("플레어", "bottom_fit_flare", "flare");

  final String label;
  final String code;
  final String name;

  const BottomFit(this.label, this.code, this.name);
}

enum BottomLength with ClothesDetail {
  short("짧은 길이", "bottom_length_short", "short"),
  medium("중간 길이", "bottom_length_medium", "medium"),
  long("긴 길이", "bottom_length_long", "long"),
  mini("미니", "bottom_length_mini", "mini");

  final String label;
  final String code;
  final String name;

  const BottomLength(this.label, this.code, this.name);
}

enum SkirtFit with ClothesDetail {
  aLine("a라인", "skirt_fit_a_line", "aLine"),
  hLine("h라인", "skirt_fit_h_line", "hLine"),
  tennis("테니스", "skirt_fit_tennis", "tennis");

  final String label;
  final String code;
  final String name;

  const SkirtFit(this.label, this.code, this.name);
}

enum ShoesLength with ClothesDetail {
  high("긴 길이", "shoes_length_high", "high"),
  long("긴 길이", "shoes_length_long", "long"),
  middle("중간 길이", "shoes_length_middle", "middle"),
  short("짧은 길이", "shoes_length_short", "short"),
  low("짧은 길이", "shoes_length_low", "low");

  final String label;
  final String code;
  final String name;

  const ShoesLength(this.label, this.code, this.name);
}

enum ShoesStrap with ClothesDetail {
  withStrap("있음", "shoes_strap_with", "withStrap"),
  withoutStrap("없음", "shoes_strap_without", "withoutStrap");

  final String label;
  final String code;
  final String name;

  const ShoesStrap(this.label, this.code, this.name);
}

enum ShoesHill with ClothesDetail {
  high("높은 굽", "shoes_hill_high", "high"),
  middle("중간 굽", "shoes_hill_middle", "middle"),
  low("낮은 굽", "shoes_hill_low", "low");

  final String label;
  final String code;
  final String name;

  const ShoesHill(this.label, this.code, this.name);
}

enum ClothesColor {
  // 흑백 계열
  lightBlack(Color(0xFF282828), 'Light Black', 600),
  black(Color(0xFF161616), 'Black', 800),
  white(Color(0xFFFFFFFF), 'White', 0),
  warmWhite(Color(0xFFF2EFEB), 'Warm White', 50),
  coolWhite(Color(0xFFE7E7E7), 'Cool White', 50),

  // 회색 계열
  gray50(Color(0xFFE2E2E2), 'Gray 50', 50),
  gray100(Color(0xFFC4C4C4), 'Gray 100', 100),
  gray500(Color(0xFF8D8D8D), 'Gray 500', 500),
  gray600(Color(0xFF606060), 'Gray 600', 600),
  gray800(Color(0xFF4D4C4C), 'Gray 800', 800),

  // 빨강 계열
  red50(Color(0xFFE8C9C9), 'Red 50', 50),
  red100(Color(0xFFDBA5A5), 'Red 100', 100),
  red500(Color(0xFFB37171), 'Red 500', 500),
  red600(Color(0xFF8C3737), 'Red 600', 600),
  red800(Color(0xFF6B1E1E), 'Red 800', 800),

  // 주황 계열
  orange50(Color(0xFFEDD6CA), 'Orange 50', 50),
  orange100(Color(0xFFE4B198), 'Orange 100', 100),
  orange500(Color(0xFFD48E6A), 'Orange 500', 500),
  orange600(Color(0xFFA76443), 'Orange 600', 600),
  orange800(Color(0xFF9C4B22), 'Orange 800', 800),

  // 노랑 계열
  yellow50(Color(0xFFF1ECD6), 'Yellow 50', 50),
  yellow100(Color(0xFFF0E3A3), 'Yellow 100', 100),
  yellow500(Color(0xFFE4D58B), 'Yellow 500', 500),
  yellow600(Color(0xFFC4A151), 'Yellow 600', 600),
  yellow800(Color(0xFFAA770E), 'Yellow 800', 800),

  // 베이지 계열
  beige50(Color(0xFFEFEBE3), 'Beige 50', 50),
  beige100(Color(0xFFDBD0BF), 'Beige 100', 100),
  beige500(Color(0xFFD8C6A9), 'Beige 500', 500),
  beige600(Color(0xFFB29A75), 'Beige 600', 600),
  beige800(Color(0xFF847151), 'Beige 800', 800),

  // 라이트 그린 계열
  lightGreen50(Color(0xFFE3ECDD), 'Light Green 50', 50),
  lightGreen100(Color(0xFFCFDEC7), 'Light Green 100', 100),
  lightGreen500(Color(0xFF7FA77F), 'Light Green 500', 500),
  lightGreen600(Color(0xFF68A168), 'Light Green 600', 600),
  lightGreen800(Color(0xFF467346), 'Light Green 800', 800),

  // 그린 계열
  green50(Color(0xFFD3DFCB), 'Green 50', 50),
  green100(Color(0xFF9FB294), 'Green 100', 100),
  green500(Color(0xFF627762), 'Green 500', 500),
  green600(Color(0xFF3D513D), 'Green 600', 600),
  green800(Color(0xFF323632), 'Green 800', 800),

  // 라이트 블루 계열
  lightBlue50(Color(0xFFDBE7ED), 'Light Blue 50', 50),
  lightBlue100(Color(0xFFADCAD8), 'Light Blue 100', 100),
  lightBlue500(Color(0xFF5C8DBD), 'Light Blue 500', 500),
  lightBlue600(Color(0xFF304F85), 'Light Blue 600', 600),
  lightBlue800(Color(0xFF193462), 'Light Blue 800', 800),

  // 블루 계열
  blue50(Color(0xFFC5CFDA), 'Blue 50', 50),
  blue100(Color(0xFF8095A9), 'Blue 100', 100),
  blue500(Color(0xFF43617F), 'Blue 500', 500),
  blue600(Color(0xFF32485D), 'Blue 600', 600),
  blue800(Color(0xFF293744), 'Blue 800', 800),

  // 퍼플 계열
  purple50(Color(0xFFE7E1F1), 'Purple 50', 50),
  purple100(Color(0xFFC9BDE1), 'Purple 100', 100),
  purple500(Color(0xFF9987BD), 'Purple 500', 500),
  purple600(Color(0xFF5C4588), 'Purple 600', 600),
  purple800(Color(0xFF504588), 'Purple 800', 800),

  // 쿨 핑크 계열
  coolPink50(Color(0xFFE8D8E8), 'Cool Pink 50', 50),
  coolPink100(Color(0xFFD8B9D8), 'Cool Pink 100', 100),
  coolPink500(Color(0xFFAC6BAC), 'Cool Pink 500', 500),
  coolPink600(Color(0xFF854473), 'Cool Pink 600', 600),
  coolPink800(Color(0xFF5B2D4E), 'Cool Pink 800', 800),

  // 웜 핑크 계열
  warmPink50(Color(0xFFE6CBD3), 'Warm Pink 50', 50),
  warmPink100(Color(0xFFE1B5C2), 'Warm Pink 100', 100),
  warmPink500(Color(0xFFBE7187), 'Warm Pink 500', 500),
  warmPink600(Color(0xFFA04D65), 'Warm Pink 600', 600),
  warmPink800(Color(0xFF722B3F), 'Warm Pink 800', 800),

  // 웜 브라운 계열
  warmBrown50(Color(0xFFE8DDD7), 'Warm Brown 50', 50),
  warmBrown100(Color(0xFFD2B8A9), 'Warm Brown 100', 100),
  warmBrown500(Color(0xFFA17257), 'Warm Brown 500', 500),
  warmBrown600(Color(0xFF79513A), 'Warm Brown 600', 600),
  warmBrown800(Color(0xFF593416), 'Warm Brown 800', 800),

  // 다크 브라운 계열
  darkBrown50(Color(0xFFDDD4D0), 'Dark Brown 50', 50),
  darkBrown100(Color(0xFFC5B9B2), 'Dark Brown 100', 100),
  darkBrown500(Color(0xFF89766B), 'Dark Brown 500', 500),
  darkBrown600(Color(0xFF5B483D), 'Dark Brown 600', 600),
  darkBrown800(Color(0xFF3C2F28), 'Dark Brown 800', 800);

  final Color color;
  final String name;
  final int darkness; // Added darkness field

  const ClothesColor(this.color, this.name, this.darkness);

  static List<ClothesColor> get all => values.toList();

  static ClothesColor fromValue(int value) =>
      all.firstWhere((c) => c.color.value == value, orElse: () => white);

  static ClothesColor fromName(String name) =>
      all.firstWhere((c) => c.name == name, orElse: () => white);

  // Optional: Method to get colors by darkness level
  static List<ClothesColor> getByDarkness(int darknessLevel) =>
      all.where((c) => c.darkness == darknessLevel).toList();
}

List<Clothes> generateDummyClothes() {
  return [
    Clothes(
        id: 0,
        name: '흰색긴팔티',
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
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '아이보리긴팔티',
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
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색긴팔티',
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
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정긴팔티',
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
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰색반팔티',
        primaryCategoryId: 1,
        secondaryCategoryId: 1,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.short,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '아이보리반팔티',
        primaryCategoryId: 1,
        secondaryCategoryId: 1,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.short,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색반팔티',
        primaryCategoryId: 1,
        secondaryCategoryId: 1,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.short,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정반팔티',
        primaryCategoryId: 1,
        secondaryCategoryId: 1,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.short,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰색셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 3,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
          ],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '아이보리셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 3,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
          ],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '하늘색셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 3,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
          ],
        ),
        price: 123,
        color: ClothesColor.lightBlue50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 3,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰색반팔셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 3,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.short,
          ],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '아이보리반팔셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 3,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.short,
          ],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '하늘색반팔셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 3,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.short,
          ],
        ),
        price: 123,
        color: ClothesColor.lightBlue50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색반팔셔츠',
        primaryCategoryId: 1,
        secondaryCategoryId: 3,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.short,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색후드',
        primaryCategoryId: 1,
        secondaryCategoryId: 9,
        details: ClothesDetails(
          details: [
            TopLength.long,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운후드',
        primaryCategoryId: 1,
        secondaryCategoryId: 9,
        details: ClothesDetails(
          details: [
            TopLength.long,
          ],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '네이비후드',
        primaryCategoryId: 1,
        secondaryCategoryId: 9,
        details: ClothesDetails(
          details: [
            TopLength.long,
          ],
        ),
        price: 123,
        color: ClothesColor.blue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '블랙후드',
        primaryCategoryId: 1,
        secondaryCategoryId: 9,
        details: ClothesDetails(
          details: [
            TopLength.long,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색숏후드',
        primaryCategoryId: 1,
        secondaryCategoryId: 9,
        details: ClothesDetails(
          details: [
            TopLength.short,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운숏후드',
        primaryCategoryId: 1,
        secondaryCategoryId: 9,
        details: ClothesDetails(
          details: [
            TopLength.short,
          ],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '네이비숏후드',
        primaryCategoryId: 1,
        secondaryCategoryId: 9,
        details: ClothesDetails(
          details: [
            TopLength.short,
          ],
        ),
        price: 123,
        color: ClothesColor.blue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '블랙숏후드',
        primaryCategoryId: 1,
        secondaryCategoryId: 9,
        details: ClothesDetails(
          details: [
            TopLength.short,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색맨투맨',
        primaryCategoryId: 1,
        secondaryCategoryId: 8,
        details: ClothesDetails(
          details: [TopLength.long, Neckline.round],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운맨투맨',
        primaryCategoryId: 1,
        secondaryCategoryId: 8,
        details: ClothesDetails(
          details: [TopLength.long, Neckline.round],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '네이비맨투맨',
        primaryCategoryId: 1,
        secondaryCategoryId: 8,
        details: ClothesDetails(
          details: [TopLength.long, Neckline.round],
        ),
        price: 123,
        color: ClothesColor.blue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '블랙맨투맨',
        primaryCategoryId: 1,
        secondaryCategoryId: 8,
        details: ClothesDetails(
          details: [TopLength.long, Neckline.round],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색숏맨투맨',
        primaryCategoryId: 1,
        secondaryCategoryId: 8,
        details: ClothesDetails(
          details: [TopLength.short, Neckline.round],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운숏맨투맨',
        primaryCategoryId: 1,
        secondaryCategoryId: 8,
        details: ClothesDetails(
          details: [TopLength.short, Neckline.round],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '네이비숏맨투맨',
        primaryCategoryId: 1,
        secondaryCategoryId: 8,
        details: ClothesDetails(
          details: [TopLength.short, Neckline.round],
        ),
        price: 123,
        color: ClothesColor.blue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '블랙숏맨투맨',
        primaryCategoryId: 1,
        secondaryCategoryId: 8,
        details: ClothesDetails(
          details: [TopLength.short, Neckline.round],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니진청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.lightBlue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니연청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.lightBlue100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니흰청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니검정바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.lightBlack,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자진청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.lightBlue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자연청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.lightBlue100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자흰청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자검정바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.lightBlack,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드진청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.lightBlue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드연청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.lightBlue100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드흰청바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드검정바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 21,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.lightBlack,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니진청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.lightBlue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니연청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.lightBlue100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니흰청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니검정반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.lightBlack,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자진청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.lightBlue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자연청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.lightBlue100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자흰청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자검정반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.lightBlack,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드진청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.lightBlue500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드연청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.lightBlue100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드흰청반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드검정반바지',
        primaryCategoryId: 2,
        secondaryCategoryId: 27,
        details: ClothesDetails(
          details: [BottomLength.medium, BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.lightBlack,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰색슬랙스',
        primaryCategoryId: 2,
        secondaryCategoryId: 22,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '베이지슬랙스',
        primaryCategoryId: 2,
        secondaryCategoryId: 22,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.beige500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색슬랙스',
        primaryCategoryId: 2,
        secondaryCategoryId: 22,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.gray500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정슬랙스',
        primaryCategoryId: 2,
        secondaryCategoryId: 22,
        details: ClothesDetails(
          details: [BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니트레이닝',
        primaryCategoryId: 2,
        secondaryCategoryId: 24,
        details: ClothesDetails(
          details: [BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자트레이닝',
        primaryCategoryId: 2,
        secondaryCategoryId: 24,
        details: ClothesDetails(
          details: [BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드트레이닝',
        primaryCategoryId: 2,
        secondaryCategoryId: 24,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '스키니트레이닝',
        primaryCategoryId: 2,
        secondaryCategoryId: 24,
        details: ClothesDetails(
          details: [BottomFit.skinny],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '일자트레이닝',
        primaryCategoryId: 2,
        secondaryCategoryId: 24,
        details: ClothesDetails(
          details: [BottomFit.straight],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '와이드트레이닝',
        primaryCategoryId: 2,
        secondaryCategoryId: 24,
        details: ClothesDetails(
          details: [BottomFit.wide],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰색롱패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
            Neckline.high,
          ],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '아이보리롱패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색롱패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정롱패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.long,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰색패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            SleeveLength.long,
            Neckline.high,
          ],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '아이보리패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰색숏패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.short,
            SleeveLength.long,
            Neckline.high,
          ],
        ),
        price: 123,
        color: ClothesColor.white,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '아이보리숏패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.short,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색숏패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.short,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정숏패딩',
        primaryCategoryId: 3,
        secondaryCategoryId: 19,
        details: ClothesDetails(
          details: [
            TopLength.short,
            SleeveLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '베이지롱코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.long,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.beige500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운롱코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.long,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색롱코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.long,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정롱코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.long,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '베이지코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.beige500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.medium,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '베이지숏코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.short,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.beige500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운숏코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.short,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색숏코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.short,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.gray100,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정숏코트',
        primaryCategoryId: 3,
        secondaryCategoryId: 18,
        details: ClothesDetails(
          details: [
            TopLength.short,
            Neckline.polo,
          ],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '라운드회색집업',
        primaryCategoryId: 3,
        secondaryCategoryId: 12,
        details: ClothesDetails(
          details: [
            TopLength.long,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브이넥회색집업',
        primaryCategoryId: 3,
        secondaryCategoryId: 12,
        details: ClothesDetails(
          details: [
            TopLength.long,
            Neckline.vNeck,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '하이넥회색집업',
        primaryCategoryId: 3,
        secondaryCategoryId: 12,
        details: ClothesDetails(
          details: [
            TopLength.long,
            Neckline.high,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '후드회색집업',
        primaryCategoryId: 3,
        secondaryCategoryId: 12,
        details: ClothesDetails(
          details: [
            TopLength.long,
            Neckline.hoodie,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '라운드숏집업',
        primaryCategoryId: 3,
        secondaryCategoryId: 12,
        details: ClothesDetails(
          details: [
            TopLength.short,
            Neckline.round,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브이넥숏집업',
        primaryCategoryId: 3,
        secondaryCategoryId: 12,
        details: ClothesDetails(
          details: [
            TopLength.short,
            Neckline.vNeck,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '하이넥숏집업',
        primaryCategoryId: 3,
        secondaryCategoryId: 12,
        details: ClothesDetails(
          details: [
            TopLength.short,
            Neckline.high,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '후드숏집업',
        primaryCategoryId: 3,
        secondaryCategoryId: 12,
        details: ClothesDetails(
          details: [
            TopLength.short,
            Neckline.hoodie,
          ],
        ),
        price: 123,
        color: ClothesColor.gray50,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰운동화',
        primaryCategoryId: 5,
        secondaryCategoryId: 30,
        details: ClothesDetails(
          details: [ShoesLength.low],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운운동화',
        primaryCategoryId: 5,
        secondaryCategoryId: 30,
        details: ClothesDetails(
          details: [ShoesLength.low],
        ),
        price: 123,
        color: ClothesColor.warmBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '회색운동화',
        primaryCategoryId: 5,
        secondaryCategoryId: 30,
        details: ClothesDetails(
          details: [ShoesLength.low],
        ),
        price: 123,
        color: ClothesColor.gray500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정운동화',
        primaryCategoryId: 5,
        secondaryCategoryId: 30,
        details: ClothesDetails(
          details: [ShoesLength.low],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '로퍼',
        primaryCategoryId: 5,
        secondaryCategoryId: 33,
        details: ClothesDetails(
          details: [ShoesHill.high],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '플랫슈즈',
        primaryCategoryId: 5,
        secondaryCategoryId: 34,
        details: ClothesDetails(
          details: [ShoesStrap.withStrap],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '구두',
        primaryCategoryId: 5,
        secondaryCategoryId: 32,
        details: ClothesDetails(
          details: [ShoesHill.high],
        ),
        price: 123,
        color: ClothesColor.lightBlack,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '구두',
        primaryCategoryId: 5,
        secondaryCategoryId: 38,
        details: ClothesDetails(
          details: [ShoesHill.high],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운롱부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 35,
        details: ClothesDetails(
          details: [ShoesHill.high, ShoesLength.long],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정롱부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 35,
        details: ClothesDetails(
          details: [ShoesHill.high, ShoesLength.long],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 35,
        details: ClothesDetails(
          details: [ShoesHill.high, ShoesLength.middle],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 35,
        details: ClothesDetails(
          details: [ShoesHill.high, ShoesLength.middle],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰레인부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 37,
        details: ClothesDetails(
          details: [ShoesLength.high],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정레인부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 37,
        details: ClothesDetails(
          details: [ShoesLength.high],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '흰숏레인부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 37,
        details: ClothesDetails(
          details: [ShoesLength.middle],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정숏레인부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 37,
        details: ClothesDetails(
          details: [ShoesLength.middle],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '어그부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 36,
        details: ClothesDetails(
          details: [ShoesLength.middle],
        ),
        price: 123,
        color: ClothesColor.warmBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '베이지어그부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 36,
        details: ClothesDetails(
          details: [ShoesLength.middle],
        ),
        price: 123,
        color: ClothesColor.beige600,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '숏어그부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 36,
        details: ClothesDetails(
          details: [ShoesLength.short],
        ),
        price: 123,
        color: ClothesColor.warmBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '베이지숏어그부츠',
        primaryCategoryId: 5,
        secondaryCategoryId: 36,
        details: ClothesDetails(
          details: [ShoesLength.short],
        ),
        price: 123,
        color: ClothesColor.beige600,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '브라운샌들',
        primaryCategoryId: 5,
        secondaryCategoryId: 40,
        details: ClothesDetails(
          details: [],
        ),
        price: 123,
        color: ClothesColor.darkBrown500,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '샌들',
        primaryCategoryId: 5,
        secondaryCategoryId: 40,
        details: ClothesDetails(
          details: [],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '슬리퍼',
        primaryCategoryId: 5,
        secondaryCategoryId: 39,
        details: ClothesDetails(
          details: [],
        ),
        price: 123,
        color: ClothesColor.warmWhite,
        regTs: DateTime.now(),
        drawLines: []),
    Clothes(
        id: 0,
        name: '검정슬리퍼',
        primaryCategoryId: 5,
        secondaryCategoryId: 39,
        details: ClothesDetails(
          details: [],
        ),
        price: 123,
        color: ClothesColor.black,
        regTs: DateTime.now(),
        drawLines: []),
  ].asMap().entries.map((entry) {
    int index = entry.key;
    var clothes = entry.value;
    clothes.id = index;
    return clothes;
  }).toList();
}

// 색상 이름 Enum 추가
enum ColorName {
  BLACK('검정색'),
  WHITE('흰색'),
  GRAY('회색'),
  RED('빨간색'),
  ORANGE('주황색'),
  YELLOW('노란색'),
  GREEN('초록색'),
  BLUE('파란색'),
  PURPLE('보라색'),
  MAGENTA('자주색'),
  PINK('핑크색'),
  BROWN('갈색'),
  BEIGE('베이지색');

  final String koreanName;
  const ColorName(this.koreanName);
}

// ColorContainer 클래스 수정
class ColorContainer {
  final List<ClothesColor> colors;
  final ClothesColor representativeColor;
  final ColorName representativeColorName; // Enum 타입으로 변경

  ColorContainer(
    this.colors,
    this.representativeColor,
    this.representativeColorName,
  );
}

// colorContainers 리스트 Enum 적용
final List<ColorContainer> colorContainers = [
  ColorContainer(
    [ClothesColor.lightBlack, ClothesColor.black],
    ClothesColor.lightBlack,
    ColorName.BLACK,
  ),
  ColorContainer(
    [ClothesColor.white, ClothesColor.warmWhite, ClothesColor.coolWhite],
    ClothesColor.white,
    ColorName.WHITE,
  ),
  ColorContainer(
    [
      ClothesColor.gray50,
      ClothesColor.gray100,
      ClothesColor.gray500,
      ClothesColor.gray600,
      ClothesColor.gray800
    ],
    ClothesColor.gray500,
    ColorName.GRAY,
  ),
  ColorContainer(
    [
      ClothesColor.red50,
      ClothesColor.red100,
      ClothesColor.red500,
      ClothesColor.red600,
      ClothesColor.red800
    ],
    ClothesColor.red500,
    ColorName.RED,
  ),
  ColorContainer(
    [
      ClothesColor.orange50,
      ClothesColor.orange100,
      ClothesColor.orange500,
      ClothesColor.orange600,
      ClothesColor.orange800
    ],
    ClothesColor.orange500,
    ColorName.ORANGE,
  ),
  ColorContainer(
    [
      ClothesColor.yellow50,
      ClothesColor.yellow100,
      ClothesColor.yellow500,
      ClothesColor.yellow600,
      ClothesColor.yellow800
    ],
    ClothesColor.yellow500,
    ColorName.YELLOW,
  ),
  ColorContainer(
    [
      ClothesColor.lightGreen50,
      ClothesColor.lightGreen100,
      ClothesColor.lightGreen500,
      ClothesColor.lightGreen600,
      ClothesColor.lightGreen800
    ],
    ClothesColor.lightGreen500,
    ColorName.GREEN,
  ),
  ColorContainer(
    [
      ClothesColor.green50,
      ClothesColor.green100,
      ClothesColor.green500,
      ClothesColor.green600,
      ClothesColor.green800
    ],
    ClothesColor.green500,
    ColorName.GREEN,
  ),
  ColorContainer(
    [
      ClothesColor.lightBlue50,
      ClothesColor.lightBlue100,
      ClothesColor.lightBlue500,
      ClothesColor.lightBlue600,
      ClothesColor.lightBlue800
    ],
    ClothesColor.lightBlue500,
    ColorName.BLUE,
  ),
  ColorContainer(
    [
      ClothesColor.blue50,
      ClothesColor.blue100,
      ClothesColor.blue500,
      ClothesColor.blue600,
      ClothesColor.blue800
    ],
    ClothesColor.blue500,
    ColorName.BLUE,
  ),
  ColorContainer(
    [
      ClothesColor.purple50,
      ClothesColor.purple100,
      ClothesColor.purple500,
      ClothesColor.purple600,
      ClothesColor.purple800
    ],
    ClothesColor.purple500,
    ColorName.PURPLE,
  ),
  ColorContainer(
    [
      ClothesColor.coolPink50,
      ClothesColor.coolPink100,
      ClothesColor.coolPink500,
      ClothesColor.coolPink600,
      ClothesColor.coolPink800
    ],
    ClothesColor.coolPink500,
    ColorName.MAGENTA,
  ),
  ColorContainer(
    [
      ClothesColor.warmPink50,
      ClothesColor.warmPink100,
      ClothesColor.warmPink500,
      ClothesColor.warmPink600,
      ClothesColor.warmPink800
    ],
    ClothesColor.warmPink500,
    ColorName.PINK,
  ),
  ColorContainer(
    [
      ClothesColor.warmBrown50,
      ClothesColor.warmBrown100,
      ClothesColor.warmBrown500,
      ClothesColor.warmBrown600,
      ClothesColor.warmBrown800
    ],
    ClothesColor.warmBrown500,
    ColorName.BROWN,
  ),
  ColorContainer(
    [
      ClothesColor.darkBrown50,
      ClothesColor.darkBrown100,
      ClothesColor.darkBrown500,
      ClothesColor.darkBrown600,
      ClothesColor.darkBrown800
    ],
    ClothesColor.darkBrown500,
    ColorName.BROWN,
  ),
  ColorContainer(
    [
      ClothesColor.beige50,
      ClothesColor.beige100,
      ClothesColor.beige500,
      ClothesColor.beige600,
      ClothesColor.beige800
    ],
    ClothesColor.beige500,
    ColorName.BEIGE,
  ),
];

enum ClothesDraftStatus {
  NAME,
  PRIMARY_CATEGORY,
  SECONDARY_CATEGORY,
  DETAILS,
  COLOR,
}
