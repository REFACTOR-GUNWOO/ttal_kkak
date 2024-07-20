class FirstCategory {
  int id;
  String name;
  int priority;

  FirstCategory({
    required this.id,
    required this.name,
    required this.priority,
  });
}

List<FirstCategory> firstCategories = [
  FirstCategory(
    id: 1,
    name: "상의",
    priority: 1,
  ),
  FirstCategory(
    id: 2,
    name: "하의",
    priority: 2,
  ),
  FirstCategory(
    id: 3,
    name: "아우터",
    priority: 3,
  ),
  FirstCategory(
    id: 4,
    name: "원피스",
    priority: 4,
  ),
  FirstCategory(
    id: 5,
    name: "신발",
    priority: 5,
  ),
];

class SecondCategory {
  int id;
  String name;
  int priority;
  int firstCategoryId;

  SecondCategory(
      {required this.id,
      required this.name,
      required this.priority,
      required this.firstCategoryId});
}

List<SecondCategory> secondCategories = [
  SecondCategory(id: 1, name: "티셔츠", priority: 1, firstCategoryId: 1),
  SecondCategory(id: 2, name: "나시", priority: 2, firstCategoryId: 1),
  SecondCategory(id: 3, name: "청바지", priority: 3, firstCategoryId: 2),
  SecondCategory(id: 4, name: "면바지", priority: 4, firstCategoryId: 2),
  SecondCategory(id: 5, name: "자켓", priority: 5, firstCategoryId: 3),
  SecondCategory(id: 6, name: "바람막이", priority: 6, firstCategoryId: 3),
  SecondCategory(id: 7, name: "원피스1", priority: 7, firstCategoryId: 4),
  SecondCategory(id: 8, name: "원피스2", priority: 3, firstCategoryId: 4),
  SecondCategory(id: 7, name: "구두", priority: 4, firstCategoryId: 5),
  SecondCategory(id: 8, name: "슬리퍼", priority: 1, firstCategoryId: 5),
];
