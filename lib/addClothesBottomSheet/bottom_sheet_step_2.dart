import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/draft_clear_warning_dialog.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody2 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody2(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.updateProvider
      });
  final bool isUpdate;
  final ClothesUpdateProvider updateProvider;
  
  @override
  _BottomSheetBody2State createState() => _BottomSheetBody2State();

  @override
  String getTitle() {
    return "상위 카테고리";
  }
  
  @override
  bool Function() get canGoNext => () => true;
}

class _BottomSheetBody2State extends State<BottomSheetBody2> {
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Clothes? clothes = widget.updateProvider.currentClothes;
      int? primaryCategoryId = clothes?.primaryCategoryId;
      setState(() {
        selectedCategoryId = primaryCategoryId;
      });
    });
  }

  void save(int categoryId) async {
    final clothes = widget.updateProvider.currentClothes;
    if (clothes == null) {
      return;
    }
    print("update : ${clothes.name}");

    clothes.updatePrimaryCategoryId(categoryId);
    if (widget.isUpdate) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DraftClearWarningDialog(
              draftFieldName: "상위 카테고리",
              draft: clothes,
              onNextStep: widget.onNextStep);
        },
      );
    } else {
      print("update2 : ${clothes.id}");
      print("update2 : ${clothes.name}");
      print("update2 : ${clothes.primaryCategoryId}");
      print("update2 : ${clothes.secondaryCategoryId}");
      print("update2 : ${clothes.details}");
      await widget.updateProvider.update(clothes);
      widget.onNextStep();
    }
    if (clothes.isDraft) {
      print("draft");
      clothes.isDraft = false;
      await widget.updateProvider.update(clothes);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final category = firstCategories[index];

          return TextButton(
            onPressed: () async => {save(category.id)},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // 패딩 제거
              minimumSize: Size(0, 0), // 버튼의 최소 크기 제거
            ),
            child: Container(
              decoration: BoxDecoration(
                border: selectedCategoryId == category.id
                    ? Border.all(color: SystemColors.black, width: 1.5)
                    : Border.all(
                        color: SystemColors.gray500, width: 1.0), // 테두리 색상

                borderRadius: BorderRadius.circular(6.0), // 모서리 둥글게
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: OneLineTextStyles.SemiBold16.copyWith(
                          color: SystemColors.black),
                    ),
                    SizedBox(height: 8.0),
                    Text(category.description,
                        style: BodyTextStyles.Medium12.copyWith(
                            color: SystemColors.gray700)),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: firstCategories.length,
      ),
    );
  }
}
