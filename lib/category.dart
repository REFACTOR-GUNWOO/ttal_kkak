import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';

class FirstCategory {
  int id;
  String name;
  int priority;
  String description;
  String hangerUrl;
  double hangerPosition;
  FirstCategory({
    required this.id,
    required this.name,
    required this.hangerPosition,
    required this.priority,
    required this.hangerUrl,
    required this.description,
  });
}

List<FirstCategory> firstCategories = [
  FirstCategory(
      id: 1,
      name: "상의",
      priority: 1,
      hangerUrl: "assets/icons/hanger.svg",
      hangerPosition: 10,
      description: '티셔츠 블라우스, 니트, 조끼 등의 옷이 있어요.'),
  FirstCategory(
      id: 2,
      name: "하의",
      priority: 2,
      hangerPosition: 10,
      hangerUrl: "assets/icons/pants_hanger.svg",
      description: "청바지, 슬랙스, 반바지, 레깅스 등의 옷이 있어요."),
  FirstCategory(
      id: 3,
      name: "아우터",
      priority: 3,
      hangerPosition: 10,
      hangerUrl: "assets/icons/hanger.svg",
      description: "야상, 가디건, 자켓 코트, 패딩 등의 옷이 있어요."),
  FirstCategory(
      id: 4,
      name: "원피스",
      priority: 4,
      hangerPosition: 10,
      hangerUrl: "assets/icons/hanger.svg",
      description: "원피스, 점프슈트 등의 옷이 있어요."),
  FirstCategory(
      id: 5,
      name: "신발",
      priority: 5,
      hangerPosition: 121,
      hangerUrl: "assets/icons/shoes_hanger.svg",
      description: "슬리퍼, 운동화, 구두 등의 옷이 있어요."),
];

class CategoryDetail {
  int priority;
  String label;
  ClothesDetail defaultDetail;
  List<ClothesDetail> details;
  CategoryDetail(
      {required this.priority,
      required this.label,
      required this.details,
      required this.defaultDetail});
}

class SecondCategory {
  int id;
  String name;
  String code;
  int priority;
  int firstCategoryId;
  String defaultImage;
  double? clothesTopPosition;
  double? clothesBottomPosition;
  List<CategoryDetail> details;
  bool hasDecorationLayer = false;
  Color? defaultColor = ClothesColor.White;

  SecondCategory(
      {required this.id,
      required this.name,
      required this.priority,
      required this.firstCategoryId,
      required this.defaultImage,
      required this.code,
      required this.details,
      this.defaultColor,
      this.clothesTopPosition,
      this.clothesBottomPosition,
      this.hasDecorationLayer = false});
}

List<SecondCategory> secondCategories = [
  SecondCategory(
      id: 1,
      name: "티셔츠",
      code: "t-shirt",
      priority: 1,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "소매 길이",
            defaultDetail: SleeveLength.long,
            details: [SleeveLength.long, SleeveLength.short]),
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.square,
              Neckline.offShoulder
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/t-shirt_crop_long_offShoulder.svg"),
  SecondCategory(
      id: 2,
      name: "카라티",
      code: "poloShirt",
      priority: 2,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "소매 길이",
            defaultDetail: SleeveLength.long,
            details: [SleeveLength.long, SleeveLength.short]),
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/t-shirt_crop_long_offShoulder.svg"),
  SecondCategory(
      id: 3,
      name: "셔츠",
      code: "shirt",
      priority: 3,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "소매 길이",
            defaultDetail: SleeveLength.long,
            details: [SleeveLength.long, SleeveLength.short]),
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/t-shirt_crop_long_offShoulder.svg"),
  SecondCategory(
      id: 4,
      name: "블라우스",
      code: "blouse",
      priority: 4,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "소매 길이",
            defaultDetail: SleeveLength.long,
            details: [SleeveLength.long, SleeveLength.short]),
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.polo,
            details: [
              Neckline.polo,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.square,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/t-shirt_crop_long_offShoulder.svg"),
  SecondCategory(
      id: 5,
      name: "민소매",
      code: "sleeveless",
      priority: 5,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.square,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 6,
      name: "목티",
      code: "turtleneck",
      priority: 6,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "소매 길이",
            defaultDetail: SleeveLength.long,
            details: [SleeveLength.long, SleeveLength.short]),
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 7,
      name: "니트",
      code: "knit",
      priority: 7,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "소매 길이",
            defaultDetail: SleeveLength.long,
            details: [SleeveLength.long, SleeveLength.short]),
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.square,
              Neckline.offShoulder,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 8,
      name: "맨투맨",
      code: "sweatshirt",
      priority: 8,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.offShoulder,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 9,
      name: "후드티",
      code: "hoodie",
      priority: 9,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 10,
      name: "조끼/뷔스티에",
      code: "vest",
      priority: 10,
      firstCategoryId: 1,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.line,
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.square,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  // SecondCategory(
  //     id: 101,
  //     name: "민소매",
  //     code: "sleeveless",
  //     priority: 101,
  //     firstCategoryId: 1,
  //     clothesTopPosition: 12,
  //     details: [
  //       CategoryDetail(
  //           priority: 2,
  //           label: "상의 길이",
  //           defaultDetail: TopLength.medium,
  //           details: [
  //             TopLength.long,
  //             TopLength.medium,
  //             TopLength.short,
  //             TopLength.crop
  //           ]),
  //       CategoryDetail(
  //           priority: 3,
  //           label: "넥 라인",
  //           defaultDetail: Neckline.round,
  //           details: [
  //             Neckline.line,
  //             Neckline.round,
  //             Neckline.uNeck,
  //             Neckline.vNeck,
  //             Neckline.square,
  //           ]),
  //     ],
  //     defaultImage:
  //         "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 11,
      name: "가디건",
      code: "cardigan",
      priority: 11,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 12,
      name: "집업/후리스",
      code: "zip-up",
      priority: 12,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.high,
              Neckline.polo,
              Neckline.hoodie,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 13,
      name: "재킷",
      code: "jacket",
      priority: 13,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
              TopLength.crop
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.polo,
              Neckline.deepCollar,
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.high,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 14,
      name: "바람막이",
      code: "windbreaker",
      priority: 14,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.high,
            details: [Neckline.high, Neckline.vNeck, Neckline.hoodie]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 15,
      name: "무스탕",
      code: "shearling jacket",
      priority: 15,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      hasDecorationLayer: true,
      defaultColor: ClothesColor.DarkBrown600,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 16,
      name: "야상",
      code: "military jacket",
      priority: 16,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      defaultColor: ClothesColor.Green500,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 17,
      name: "트렌치 코트",
      code: "trench coat",
      priority: 17,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      hasDecorationLayer: true,
      defaultColor: ClothesColor.Beige100,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 18,
      name: "코트",
      code: "coat",
      priority: 18,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      hasDecorationLayer: true,
      details: [
        CategoryDetail(
            priority: 2,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.polo,
            details: [
              Neckline.polo,
              Neckline.deepCollar,
              Neckline.hoodie,
              Neckline.round,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 19,
      name: "패딩",
      code: "down jacket",
      priority: 19,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
            ]),
        CategoryDetail(
            priority: 2,
            label: "팔 길이",
            defaultDetail: SleeveLength.long,
            details: [SleeveLength.sleeveless, SleeveLength.long]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.polo,
            details: [
              Neckline.high,
              Neckline.round,
              Neckline.polo,
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 20,
      name: "조끼",
      code: "vest outer",
      priority: 20,
      firstCategoryId: 3,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "상의 길이",
            defaultDetail: TopLength.medium,
            details: [
              TopLength.long,
              TopLength.medium,
              TopLength.short,
            ]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.vNeck,
              Neckline.hoodie,
              Neckline.high
            ]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 21,
      name: "청바지",
      code: "jeans",
      priority: 21,
      firstCategoryId: 2,
      clothesTopPosition: 12,
      defaultColor: ClothesColor.Blue100,
      details: [
        CategoryDetail(
            priority: 1,
            label: "핏",
            defaultDetail: BottomFit.straight,
            details: [
              BottomFit.skinny,
              BottomFit.straight,
              BottomFit.bootCut,
              BottomFit.wide
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/pants_jeans.svg"),
  SecondCategory(
      id: 22,
      name: "슬랙스",
      code: "slacks",
      priority: 22,
      firstCategoryId: 2,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "핏",
            defaultDetail: BottomFit.straight,
            details: [BottomFit.straight, BottomFit.bootCut, BottomFit.wide]),
      ],
      defaultImage: "assets/images/clothes/bg/pants_slacks.svg"),
  SecondCategory(
      id: 23,
      name: "면바지",
      code: "cotton pants",
      priority: 23,
      firstCategoryId: 2,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "핏",
            defaultDetail: BottomFit.straight,
            details: [
              BottomFit.skinny,
              BottomFit.straight,
              BottomFit.bootCut,
              BottomFit.wide
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/pants_slacks.svg"),
  SecondCategory(
      id: 24,
      name: "트레이닝",
      code: "tracksuit",
      priority: 24,
      firstCategoryId: 2,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "핏",
            defaultDetail: BottomFit.straight,
            details: [BottomFit.skinny, BottomFit.straight, BottomFit.wide]),
      ],
      defaultImage: "assets/images/clothes/bg/pants_training.svg"),
  SecondCategory(
      id: 25,
      name: "레깅스",
      code: "leggings",
      priority: 25,
      clothesTopPosition: 12,
      firstCategoryId: 2,
      details: [
        CategoryDetail(
            priority: 1,
            label: "기장",
            defaultDetail: BottomLength.long,
            details: [
              BottomLength.long,
              BottomLength.medium,
              BottomLength.short
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/pants_leggings.svg"),
  SecondCategory(
      id: 26,
      name: "치마",
      code: "skirt",
      priority: 26,
      firstCategoryId: 2,
      clothesTopPosition: 12,
      details: [
        CategoryDetail(
            priority: 1,
            label: "기장",
            defaultDetail: BottomLength.short,
            details: [
              BottomLength.long,
              BottomLength.medium,
              BottomLength.short
            ]),
        CategoryDetail(
            priority: 2,
            label: "핏",
            defaultDetail: SkirtFit.aLine,
            details: [SkirtFit.aLine, SkirtFit.hLine, SkirtFit.tennis]),
      ],
      defaultImage: "assets/images/clothes/bg/pants_skirt.svg"),
  SecondCategory(
      id: 27,
      name: "반바지",
      code: "shorts pants",
      clothesTopPosition: 12,
      priority: 27,
      firstCategoryId: 2,
      details: [
        CategoryDetail(
            priority: 1,
            label: "기장",
            defaultDetail: BottomLength.medium,
            details: [BottomLength.medium, BottomLength.short]),
        CategoryDetail(
            priority: 2,
            label: "핏",
            defaultDetail: BottomFit.straight,
            details: [BottomFit.skinny, BottomFit.straight, BottomFit.wide]),
      ],
      defaultImage: "assets/images/clothes/bg/pants_shorts.svg"),
  SecondCategory(
      id: 28,
      name: "미니원피스",
      code: "mini dress",
      priority: 28,
      clothesTopPosition: 12,
      firstCategoryId: 4,
      details: [
        CategoryDetail(
            priority: 1,
            label: "팔길이",
            defaultDetail: SleeveLength.long,
            details: [
              SleeveLength.long,
              SleeveLength.short,
              SleeveLength.sleeveless
            ]),
        CategoryDetail(
            priority: 2,
            label: "목라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.square,
              Neckline.polo,
              Neckline.offShoulder
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/mini_dress.svg"),
  SecondCategory(
      id: 29,
      name: "롱원피스",
      code: "long dress",
      clothesTopPosition: 12,
      priority: 29,
      firstCategoryId: 4,
      details: [
        CategoryDetail(
            priority: 1,
            label: "팔길이",
            defaultDetail: SleeveLength.long,
            details: [
              SleeveLength.long,
              SleeveLength.short,
              SleeveLength.sleeveless
            ]),
        CategoryDetail(
            priority: 2,
            label: "목라인",
            defaultDetail: Neckline.round,
            details: [
              Neckline.round,
              Neckline.uNeck,
              Neckline.vNeck,
              Neckline.square,
              Neckline.polo,
              Neckline.offShoulder
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/long_dress.svg"),
  SecondCategory(
      id: 30,
      name: "운동화",
      code: "sneakers",
      clothesBottomPosition: 40,
      priority: 30,
      firstCategoryId: 5,
      details: [
        CategoryDetail(
            priority: 1,
            label: "길이",
            defaultDetail: ShoesLength.high,
            details: [
              ShoesLength.high,
              ShoesLength.low,
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/sneakers.svg"),
  SecondCategory(
      id: 31,
      name: "슬립온",
      code: "slip-ons",
      priority: 31,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      details: [],
      defaultImage: "assets/images/clothes/bg/slippers.svg"),
  SecondCategory(
      id: 32,
      name: "구두",
      code: "dress shoes",
      priority: 32,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      details: [
        CategoryDetail(
            priority: 1,
            label: "굽",
            defaultDetail: ShoesHill.high,
            details: [
              ShoesLength.high,
              ShoesLength.low,
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/shoes.svg"),
  SecondCategory(
      id: 33,
      name: "로퍼",
      code: "loafers",
      priority: 33,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      details: [
        CategoryDetail(
            priority: 1,
            label: "굽",
            defaultDetail: ShoesHill.high,
            details: [
              ShoesHill.high,
              ShoesHill.low,
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/loafers.svg"),
  SecondCategory(
      id: 34,
      name: "플랫",
      code: "flats",
      priority: 34,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      details: [
        CategoryDetail(
            priority: 1,
            label: "스트랩유무",
            defaultDetail: ShoesStrap.withStrap,
            details: [
              ShoesStrap.withStrap,
              ShoesStrap.withoutStrap,
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/flats.svg"),
  SecondCategory(
      id: 35,
      name: "부츠",
      code: "boots",
      priority: 35,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      details: [
        CategoryDetail(
            priority: 1,
            label: "길이",
            defaultDetail: ShoesLength.long,
            details: [
              ShoesLength.long,
              ShoesLength.middle,
              ShoesLength.short,
            ]),
        CategoryDetail(
            priority: 2,
            label: "굽",
            defaultDetail: ShoesHill.high,
            details: [
              ShoesHill.high,
              ShoesHill.low,
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/boots.svg"),
  SecondCategory(
      id: 36,
      name: "어그부츠",
      code: "ugg",
      priority: 36,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      defaultColor: ClothesColor.WarmBrown500,
      details: [
        CategoryDetail(
            priority: 1,
            label: "길이",
            defaultDetail: ShoesLength.middle,
            details: [
              ShoesLength.middle,
              ShoesLength.short,
            ]),
      ],
      hasDecorationLayer: true,
      defaultImage: "assets/images/clothes/bg/ugg_boots.svg"),
  SecondCategory(
      id: 37,
      name: "레인부츠",
      code: "rain boots",
      priority: 37,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      defaultColor: ClothesColor.Yellow100,
      details: [
        CategoryDetail(
            priority: 1,
            label: "길이",
            defaultDetail: ShoesLength.middle,
            details: [
              ShoesLength.high,
              ShoesLength.middle,
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/rain_boots.svg"),
  SecondCategory(
      id: 38,
      name: "힐",
      code: "heels",
      priority: 38,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      details: [
        CategoryDetail(
            priority: 1,
            label: "굽",
            defaultDetail: ShoesHill.high,
            details: [
              ShoesHill.high,
              ShoesHill.low,
            ]),
      ],
      defaultImage: "assets/images/clothes/bg/heels.svg"),
  SecondCategory(
      id: 39,
      name: "슬리퍼",
      code: "slippers",
      priority: 39,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      details: [],
      defaultImage: "assets/images/clothes/bg/sandals.svg"),
  SecondCategory(
      id: 40,
      name: "샌들",
      code: "sandals",
      priority: 40,
      clothesBottomPosition: 40,
      firstCategoryId: 5,
      details: [],
      defaultImage: "assets/images/clothes/bg/sandals.svg"),
];
