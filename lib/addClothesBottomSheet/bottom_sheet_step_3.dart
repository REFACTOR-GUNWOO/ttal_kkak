import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/draft_clear_warning_dialog.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody3 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody3(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.draftProvider,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesDraftProvider draftProvider;
  final ClothesUpdateProvider updateProvider;

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

    ClothesDraft? draft = widget.draftProvider.currentDraft;
    int? primaryCategoryId = widget.isUpdate
        ? widget.updateProvider.currentClothes?.primaryCategoryId
        : draft?.primaryCategoryId;

    setState(() {
      categories = secondCategories
          .where((element) => element.firstCategoryId == primaryCategoryId)
          .toList();

      selectedCategoryId = widget.isUpdate
          ? widget.updateProvider.currentClothes?.secondaryCategoryId
          : draft?.secondaryCategoryId;
    });
  }

  void save(int categoryId) async {
    if (widget.isUpdate) {
      final clothes = widget.updateProvider.currentClothes!;
      clothes.updateSecondaryCategoryId(categoryId);
      await widget.updateProvider.update(clothes);
      widget.onNextStep();
      return;
    } else {
      ClothesDraft? draft = widget.draftProvider.currentDraft;
      if (draft != null) {
        if (draft.secondaryCategoryId != null) {
          draft.secondaryCategoryId = categoryId;

          draft.resetFieldsAfterIndex(2);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DraftClearWarningDialog(
                  "하위 카테고리", draft, widget.onNextStep);
            },
          );
          return;
        }
        draft.secondaryCategoryId = categoryId;
        widget.draftProvider.updateDraft(draft);

        widget.onNextStep();
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 한 행에 두 개의 아이템
          // crossAxisSpacing: 6.0, // 수평 간격
          // mainAxisSpacing: 6.0, // 수직 간격
          childAspectRatio: 3.5, // 아이템의 가로세로 비율
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
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
                      style: OneLineTextStyles.SemiBold16.copyWith(
                          color: SystemColors.black),
                    ),
                    SvgPicture.asset(
                      "assets/images/clothes/bg/tshirt_top_length_crop_sleeve_length_long_neck_line_round.svg",
                      width: 24,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
