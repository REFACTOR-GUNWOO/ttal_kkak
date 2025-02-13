import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/draft_clear_warning_dialog.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody4 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody4(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesUpdateProvider updateProvider;
  @override
  bool Function() get canGoNext => () => true;

  @override
  _ClothesDetailSettingsState createState() => _ClothesDetailSettingsState();

  @override
  String getTitle() {
    return "디테일";
  }
}

class _ClothesDetailSettingsState extends State<BottomSheetBody4> {
  List<CategoryDetail> categoryDetails = [];
  Map<CategoryDetail, ClothesDetail> selectedDetailMap = {};
  Map<CategoryDetail, bool> dropdownVisibleMap = {};

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Clothes? clothes = widget.updateProvider.currentClothes;
    int? secondaryCategoryId = clothes?.secondaryCategoryId;

    SecondCategory? secondCategory = secondaryCategoryId == null
        ? null
        : secondCategories.firstWhere((e) => e.id == secondaryCategoryId);

    setState(() {
      if (secondCategory != null) {
        categoryDetails = secondCategory.details;
      }

      ClothesDetails? details = clothes?.details;
      categoryDetails
          .map((e) => selectedDetailMap[e] = details == null
              ? e.defaultDetail
              : e.details.firstWhere(
                  (element) => details.details.contains(element),
                  orElse: () => e.details.first))
          .toList();
      if (details == null) {
        save(force: true);
      }
    });
  }

  void save({bool force = false}) async {
    final clothes = widget.updateProvider.currentClothes!;
    clothes.updateDetails(
        ClothesDetails(details: selectedDetailMap.values.toList()));

    await widget.updateProvider.update(clothes);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return categoryDetails.isEmpty
        ? SliverToBoxAdapter(
            child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: SignatureColors.begie300,
            ),
            child: Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset("assets/icons/coach_mark.svg",
                      width: 20, height: 20, color: SignatureColors.orange400),
                  SizedBox(width: 8),
                  Text(
                    '변경 가능한 디테일 옵션이 없어요',
                    style: OneLineTextStyles.SemiBold16.copyWith(
                        color: SystemColors.black),
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ))
        : SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categoryDetails
                  .map((e) => Padding(
                        child: _buildCategorySection(
                          e,
                          selectedDetailMap[e],
                          dropdownVisibleMap[e] ?? false,
                          () {
                            setState(() {
                              final bool visible =
                                  dropdownVisibleMap[e] ?? false;
                              dropdownVisibleMap = {e: !visible};
                            });
                          },
                        ),
                        padding: EdgeInsets.only(bottom: 32),
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
    print("_buildCategorySection : ${categoryDetail.details.toString()}");
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
                  padding: EdgeInsets.zero,
                  icon: isDropdownVisible
                      ? SvgPicture.asset(
                          "assets/icons/arrow_up.svg",
                        )
                      : SvgPicture.asset(
                          "assets/icons/arrow_down.svg",
                        ),
                  iconSize: 14,
                  onPressed: toggleDropdown,
                ),
              ),
            ],
          ),
          SizedBox(height: 0),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            alignment: Alignment.bottomCenter,
            height: isDropdownVisible
                ? ((categoryDetail.details.length / 3).ceil() *
                        (MediaQuery.of(context).size.width - 40) /
                        9) +
                    12
                // 아이템 개수 기반 동적 높이
                : 0.0,
            curve: Curves.easeInOut,
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
              padding: EdgeInsets.zero,
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
        ],
      ),
    );
  }
}
