import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/draft_clear_warning_dialog.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody2 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody2(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.draftProvider,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesDraftProvider draftProvider;
  final ClothesUpdateProvider updateProvider;

  @override
  _BottomSheetBody2State createState() => _BottomSheetBody2State();

  @override
  String getTitle() {
    return "옷 카테고리";
  }
}

class _BottomSheetBody2State extends State<BottomSheetBody2> {
  int? selectedCategoryId;
  late ClothesDraftProvider provider;

  @override
  void initState() {
    super.initState();
    setState(() {
      provider = Provider.of<ClothesDraftProvider>(context, listen: false);
      provider.loadDraftFromLocal();
    });

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
      if (draft.primaryCategoryId != null &&
          draft.primaryCategoryId != categoryId) {
        draft.primaryCategoryId = categoryId;
        draft.resetFieldsAfterIndex(1);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DraftClearWarningDialog("상위 카테고리", draft, widget.onNextStep);
          },
        );
        return;
      }
      draft.primaryCategoryId = categoryId;
      ClothesDraftRepository().save(draft);
      provider.updateDraft(draft);

      widget.onNextStep();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0), // 카드와 그리드 간의 패딩
        child: GridView.builder(
          shrinkWrap: true,
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
              padding: const EdgeInsets.all(5.0), // 카드와 그리드 간의 패딩

              child: TextButton(
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
                              color: SystemColors.gray500,
                              width: 1.0), // 테두리 색상

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
                  )),
            );
          },
        ),
      ),
    );
  }
}
