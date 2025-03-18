import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes_page.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/widgets/statistics/mission_check_list_widget.dart';
import 'package:ttal_kkak/widgets/statistics/statistics_page.dart';

class MissionWidget extends StatefulWidget {
  final List<Clothes> clothesData;

  const MissionWidget({Key? key, required this.clothesData}) : super(key: key);

  @override
  _MissionWidgetState createState() => _MissionWidgetState();
}

class ClothesData {}

class _MissionWidgetState extends State<MissionWidget> {
  @override
  void initState() {
    super.initState();
    // 화면에 처음 나타날 때 로그 찍기
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LogService().log(LogType.view_screen, 'statistics_mission_page', null, {
        "completed_missions_count":
            MissionHelper.getMissionStatuses(widget.clothesData)
                .where((status) => status)
                .length
                .toString(),
        "completed_mission_indexs":
            MissionHelper.getMissionStatuses(widget.clothesData)
                .asMap()
                .entries
                .where((entry) => entry.value)
                .map((entry) => entry.key + 1)
                .toList()
                .toString(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: SystemColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SignatureColors.begie500, width: 1),
      ),
      child: Column(
        children: [
          SvgPicture.asset("assets/icons/statistics_mission.svg"),
          SizedBox(height: 10),
          Text(
            "아래 조건들을 달성해야\n통계 페이지를 확인할 수 있어요",
            textAlign: TextAlign.center,
            style:
                BodyTextStyles.Regular14.copyWith(color: SystemColors.gray900),
          ),
          SizedBox(height: 32),
          MissionCheckListWidget(clothesData: widget.clothesData),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await LogService().log(LogType.click_button,
                  'statistics_mission_page', 'clothing_register_button', {});
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddClothesPage(
                          isUpdate: false,
                          onClose: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainLayout(currentTabIndex: 1)),
                            );
                          },
                        )),
              );
              if (res == 'refresh') {
                setState(() {}); // 기존 페이지 리프레시
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: SystemColors.black,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "옷 등록하기",
              style: OneLineTextStyles.SemiBold16.copyWith(
                  color: SystemColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class MissionHelper {
  static bool hasEnoughClothes(List<Clothes> clothesData) {
    return clothesData.length >= 10;
  }

  static bool hasCategoryClothes(
      List<Clothes> clothesData, String categoryCode) {
    final categoryId = firstCategories
        .firstWhere((category) => category.code == categoryCode,
            orElse: () => firstCategories.first)
        .id;
    return clothesData.any((cloth) => cloth.primaryCategoryId == categoryId);
  }

  static List<bool> getMissionStatuses(List<Clothes> clothesData) {
    return [
      hasEnoughClothes(clothesData), // 미션 1: 옷 10개 이상 등록
      hasCategoryClothes(clothesData, "top"), // 미션 2: 상의 1개 이상 등록
      hasCategoryClothes(clothesData, "bottom"), // 미션 3: 하의 1개 이상 등록
      hasCategoryClothes(clothesData, "outer"), // 미션 4: 아우터 1개 이상 등록
      hasCategoryClothes(clothesData, "shoes"), // 미션 5: 신발 1개 이상 등록
    ];
  }
}
