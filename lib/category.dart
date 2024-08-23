import 'package:ttal_kkak/clothes.dart';

class FirstCategory {
  int id;
  String name;
  int priority;
  String description;

  FirstCategory(
      {required this.id,
      required this.name,
      required this.priority,
      required this.description});
}

List<FirstCategory> firstCategories = [
  FirstCategory(
      id: 1,
      name: "상의",
      priority: 1,
      description: '티셔츠 블라우스, 니트, 조끼 등의 옷이 있어요.'),
  FirstCategory(
      id: 2,
      name: "하의",
      priority: 2,
      description: "청바지, 슬랙스, 반바지, 레깅스 등의 옷이 있어요."),
  FirstCategory(
      id: 3,
      name: "아우터",
      priority: 3,
      description: "야상, 가디건, 자켓 코트, 패딩 등의 옷이 있어요."),
  FirstCategory(
      id: 4, name: "원피스", priority: 4, description: "원피스, 점프슈트 등의 옷이 있어요."),
  FirstCategory(
      id: 5, name: "신발", priority: 5, description: "슬리퍼, 운동화, 구두 등의 옷이 있어요."),
];

class SecondCategory {
  int id;
  String name;
  int priority;
  int firstCategoryId;
  List<TopLength> topLengths;
  List<SleeveLength> sleeveLengths;
  List<Neckline> necklines;

  SecondCategory({
    required this.id,
    required this.name,
    required this.priority,
    required this.firstCategoryId,
    required this.topLengths,
    required this.sleeveLengths,
    required this.necklines,
  });
}

List<SecondCategory> secondCategories = [
  SecondCategory(
      id: 1,
      name: "티셔츠",
      priority: 1,
      firstCategoryId: 1,
      topLengths: [
        TopLength.long
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 2,
      name: "나시",
      priority: 2,
      firstCategoryId: 1,
      topLengths: [
        TopLength.long
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 3,
      name: "청바지",
      priority: 3,
      firstCategoryId: 2,
      topLengths: [
        TopLength.medium
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 4,
      name: "면바지",
      priority: 4,
      firstCategoryId: 2,
      topLengths: [
        TopLength.medium
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 5,
      name: "자켓",
      priority: 5,
      firstCategoryId: 3,
      topLengths: [
        TopLength.medium
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 6,
      name: "바람막이",
      priority: 6,
      firstCategoryId: 3,
      topLengths: [
        TopLength.medium
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 7,
      name: "원피스1",
      priority: 7,
      firstCategoryId: 4,
      topLengths: [
        TopLength.short
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 8,
      name: "원피스2",
      priority: 3,
      firstCategoryId: 4,
      topLengths: [
        TopLength.short
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 7,
      name: "구두",
      priority: 4,
      firstCategoryId: 5,
      topLengths: [
        TopLength.short
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
  SecondCategory(
      id: 8,
      name: "슬리퍼",
      priority: 1,
      firstCategoryId: 5,
      topLengths: [
        TopLength.short
      ],
      sleeveLengths: [
        SleeveLength.long,
        SleeveLength.medium,
        SleeveLength.short
      ],
      necklines: [
        Neckline.round,
        Neckline.square
      ]),
];
