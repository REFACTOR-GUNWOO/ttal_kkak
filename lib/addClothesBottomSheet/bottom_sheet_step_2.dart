import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody2 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody2({super.key, required this.onNextStep});

  @override
  _BottomSheetBody2State createState() => _BottomSheetBody2State();

  @override
  String getTitle() {
    return "옷 카테고리";
  }
}

class _BottomSheetBody2State extends State<BottomSheetBody2> {
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ClothesDraft? draft = await ClothesDraftRepository().load();
      int? primaryCategoryId = draft?.primaryCategoryId;

      setState(() {
        selectedCategoryId = primaryCategoryId;
      });
    });
  }

  void save(int categoryId) async {
    ClothesDraft? draft = await ClothesDraftRepository().load();
    if (draft != null) {
      draft.primaryCategoryId = categoryId;
      ClothesDraftRepository().save(draft);
      widget.onNextStep();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          childAspectRatio: 3 / 2,
        ),
        itemCount: firstCategories.length,
        itemBuilder: (context, index) {
          final category = firstCategories[index];

          return Padding(
            padding: const EdgeInsets.all(0.0), // 카드와 그리드 간의 패딩

            child: TextButton(
                onPressed: () async => {save(category.id)},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // 패딩 제거
                  minimumSize: Size(0, 0), // 버튼의 최소 크기 제거
                ),
                child: Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: selectedCategoryId == category.id
                        ? BorderSide(
                            color: SystemColors.black, // 테두리 색상
                            width: 1.5, // 테두리 두께
                          )
                        : BorderSide(
                            color: SystemColors.gray500, // 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                )),
          );
        },
      ),
    );
  }
}
