import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/draft_clear_warning_dialog.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody3 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody3(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesUpdateProvider updateProvider;
  @override
  bool Function() get canGoNext => () => true;

  @override
  _BottomSheetBody3State createState() => _BottomSheetBody3State();

  @override
  String getTitle() {
    return "하위 카테고리";
  }
}

class _BottomSheetBody3State extends State<BottomSheetBody3> {
  List<SecondCategory> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();

    int? primaryCategoryId =
        widget.updateProvider.currentClothes?.primaryCategoryId;

    setState(() {
      categories = secondCategories
          .where((element) => element.firstCategoryId == primaryCategoryId)
          .toList();

      selectedCategoryId =
          widget.updateProvider.currentClothes?.secondaryCategoryId;
    });
  }

  void save(int categoryId) async {
    SecondCategory category =
        secondCategories.firstWhere((element) => element.id == categoryId);
    final clothes = widget.updateProvider.currentClothes!;
    if (widget.isUpdate) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DraftClearWarningDialog(
              draftFieldName: "하위 카테고리",
              draft: clothes,
              onNextStep: () {
                clothes.updateSecondaryCategoryId(categoryId);

                widget.onNextStep();
              });
        },
      );

      return;
    }

    clothes.updateSecondaryCategoryId(categoryId);

    clothes.updateColor(category.defaultColor ?? clothes.color);

    await widget.updateProvider.update(clothes);
    widget.onNextStep();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 3.5,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: categories.length,
        (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: selectedCategoryId == categories[index].id
                  ? Border.all(color: SystemColors.black, width: 1.5)
                  : Border.all(
                      color: SystemColors.gray500, width: 1.0), // 테두리 색상

              borderRadius: BorderRadius.circular(6.0), // 모서리 둥글게
              color: Colors.white,
            ),
            child: TextButton(
              // style: TextButton.styleFrom(
              //   padding: EdgeInsets.zero, // 패딩 제거
              // ),
              onPressed: () => save(categories[index].id),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categories[index].name,
                    style: OneLineTextStyles.Bold14.copyWith(
                        color: SystemColors.black),
                  ),
                  SvgPicture.asset(
                    "assets/images/clothes/categoryImage/${categories[index].code}.svg",
                    width: 32,
                    height: 32,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
