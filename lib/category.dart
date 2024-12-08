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
  List<CategoryDetail> details;

  SecondCategory({
    required this.id,
    required this.name,
    required this.priority,
    required this.firstCategoryId,
    required this.defaultImage,
    required this.code,
    required this.details,
  });
}

List<SecondCategory> secondCategories = [
  SecondCategory(
      id: 1,
      name: "티셔츠",
      code: "tshirt",
      priority: 1,
      firstCategoryId: 1,
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
            details: [TopLength.long, TopLength.medium, TopLength.short]),
        CategoryDetail(
            priority: 3,
            label: "넥 라인",
            defaultDetail: Neckline.round,
            details: [Neckline.round, Neckline.square, Neckline.vNeck]),
      ],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
  SecondCategory(
      id: 2,
      name: "나시",
      code: "thsirt",
      priority: 2,
      firstCategoryId: 1,
      details: [],
      defaultImage:
          "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg"),
];
