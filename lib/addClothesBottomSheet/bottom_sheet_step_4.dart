import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/draft_clear_warning_dialog.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody4 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody4(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.draftProvider,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesDraftProvider draftProvider;
  final ClothesUpdateProvider updateProvider;

  @override
  _ClothesDetailSettingsState createState() => _ClothesDetailSettingsState();

  @override
  String getTitle() {
    return "디테일";
  }
}

class _ClothesDetailSettingsState extends State<BottomSheetBody4> {
  // TopLength _selectedLength = TopLength.long;
  // SleeveLength _selectedSleeve = SleeveLength.short;
  // Neckline _selectedNeckline = Neckline.round;
  List<CategoryDetail> categoryDetails = [];
  Map<CategoryDetail, ClothesDetail> selectedDetailMap = {};
  Map<CategoryDetail, bool> dropdownVisibleMap = {};
  // bool _isLengthDropdownVisible = false;
  // bool _isSleeveDropdownVisible = false;
  // bool _isNecklineDropdownVisible = false;

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();

    ClothesDraft? draft = widget.draftProvider.currentDraft;
    Clothes? clothes = widget.updateProvider.currentClothes;
    int? secondaryCategoryId = widget.isUpdate
        ? clothes?.secondaryCategoryId
        : draft?.secondaryCategoryId;

    SecondCategory? secondCategory = secondaryCategoryId == null
        ? null
        : secondCategories.firstWhere((e) => e.id == secondaryCategoryId);

    setState(() {
      if (secondCategory != null) {
        categoryDetails = secondCategory.details;
      }

      ClothesDetails? details =
          widget.isUpdate ? clothes?.details : draft?.details;
      categoryDetails
          .map((e) => selectedDetailMap[e] = details == null
              ? e.defaultDetail
              : e.details.firstWhere(
                  (element) => details.details.contains(element),
                  orElse: () => e.details.first))
          .toList();
      if (details == null) {
        save();
      }
    });
  }

  void save() async {
    if (widget.isUpdate) {
      final clothes = widget.updateProvider.currentClothes!;
      clothes.updateDetails(
          ClothesDetails(details: selectedDetailMap.values.toList()));
      await widget.updateProvider.update(clothes);
      return;
    } else {
      ClothesDraft? draft = widget.draftProvider.currentDraft;
      if (draft != null) {
        if (draft.details != null) {
          draft.details =
              ClothesDetails(details: selectedDetailMap.values.toList());

          draft.resetFieldsAfterIndex(3);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DraftClearWarningDialog("상세설정", draft, widget.onNextStep);
            },
          );
          return;
        }

        draft.details =
            ClothesDetails(details: selectedDetailMap.values.toList());
        await widget.draftProvider.updateDraft(draft);

        // widget.onNextStep();
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categoryDetails
            .map((e) => _buildCategorySection(
                  e,
                  selectedDetailMap[e],
                  dropdownVisibleMap[e] ?? false,
                  () {
                    setState(() {
                      dropdownVisibleMap = {e: true};
                    });
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCategorySection(
    CategoryDetail categoryDetail,
    ClothesDetail? selectedValue,
    bool isDropdownVisible,
    VoidCallback toggleDropdown,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      categoryDetail.label,
                      style: OneLineTextStyles.ExtraBold16.copyWith(
                          color: SystemColors.black),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.orange, size: 16),
                      SizedBox(width: 2),
                      Text(
                        '${selectedValue == null ? categoryDetail.details.first.label : selectedValue.label} 적용됨',
                        style: OneLineTextStyles.Medium12.copyWith(
                            color: SignatureColors.orange400),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 8),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0), // 모서리 둥글게
                  color: SystemColors.black, // 배경색 설정
                ),
                child: IconButton(
                  icon: isDropdownVisible
                      ? SvgPicture.asset("assets/icons/arrow_up.svg")
                      : SvgPicture.asset("assets/icons/arrow_down.svg"),
                  iconSize: 14,
                  onPressed: toggleDropdown,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isDropdownVisible
                ? (categoryDetail.details.length / 3).ceil() * 50.0
                : 0.0,
            curve: Curves.easeInOut,
            child: Visibility(
              visible: isDropdownVisible,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(), // 그리드 뷰 내에서 스크롤 비활성화
                shrinkWrap: true, // 그리드 뷰가 컨테이너에 맞게 축소되도록 함
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 한 줄에 3개의 아이템
                  crossAxisSpacing: 10.0, // 아이템 간의 수평 간격
                  mainAxisSpacing: 10.0, // 아이템 간의 수직 간격
                  childAspectRatio: 3 / 1, // 가로 세로 비율
                ),
                itemCount: categoryDetail.details.length,
                itemBuilder: (context, index) {
                  ClothesDetail option = categoryDetail.details[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDetailMap[categoryDetail] = option;
                        save();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: selectedValue == option
                              ? Colors.black
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        option.label,
                        style: OneLineTextStyles.SemiBold16.copyWith(
                            color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
