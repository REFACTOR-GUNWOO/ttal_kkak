enum SortType {
  regTs(code: "regTs", label: "등록일순"),
  category(code: "category", label: "카테고리순"),
  color(code: "color", label: "컬러순"),
  ;

  final String label;
  final String code;

  const SortType({
    required this.label,
    required this.code,
  });
}
