import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes_page.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/common_bottom_sheet.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/models/display_message_dto.dart';
import 'package:ttal_kkak/repositories/display_message_repository.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/utils/text_formatter.dart';
import 'package:ttal_kkak/widgets/statistics/category_statistics_widget.dart';
import 'package:ttal_kkak/widgets/statistics/color_distribution_chart_widget.dart';
import 'package:ttal_kkak/widgets/statistics/darkness_distribution_chart_widget.dart';
import 'package:ttal_kkak/repositories/mission_repository.dart';
import 'package:ttal_kkak/widgets/statistics/mission_check_list_widget.dart';
import 'package:ttal_kkak/widgets/statistics/mission_widget.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Clothes>? clothesData; // null로 초기화
  bool isMissionCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    LogService().log(LogType.view_screen, "statistics_page", null, {});

    List<Clothes> loadedClothes = await ClothesRepository().loadClothes();
    bool wasMissionCompleted = await MissionRepository().isMissionCompleted();

    setState(() {
      clothesData = loadedClothes.where((element) => !element.isDraft).toList();
    });

    bool isNowCompleted = _checkMissionCompleted();
    if (isNowCompleted && !wasMissionCompleted) {
      _showMissionCompletedBottomSheet();
      await MissionRepository().updateMissionStatus(true);
    }

    setState(() {
      isMissionCompleted = isNowCompleted || wasMissionCompleted;
    });
  }

  bool _checkMissionCompleted() {
    if (clothesData == null || clothesData!.length < 10) return false;
    return ["top", "bottom", "outer", "shoes"].every(_hasCategoryClothes);
  }

  bool _hasCategoryClothes(String categoryCode) {
    final categoryId = firstCategories
        .firstWhere((category) => category.code == categoryCode,
            orElse: () => firstCategories.first)
        .id;
    return clothesData!.any((cloth) => cloth.primaryCategoryId == categoryId);
  }

  void _showMissionCompletedBottomSheet() {
    LogService().log(LogType.view_screen,
        "statistics_mission_complete_bottom_sheet", null, {});

    showModalBottomSheet(
      context: context,
      barrierColor: SystemColors.gray700.withOpacity(0.5),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: CommonBottomSheet(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 32),
                Lottie.asset(
                  'assets/lotties/firecrackers.json',
                  width: 126,
                  height: 126,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 12),
                Text(
                  "축하해요!\n이제 통계를 확인할 수 있어요",
                  style: BodyTextStyles.Bold24,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: MissionCheckListWidget(clothesData: clothesData!),
                ),
                SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      LogService().log(
                          LogType.click_button,
                          "statistics_mission_complete_bottom_sheet",
                          "confirm_button", {});
                      Navigator.pop(context);
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
                      "확인",
                      style: OneLineTextStyles.SemiBold16.copyWith(
                          color: SystemColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignatureColors.begie200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: SignatureColors.begie200,
        title: Text('통계',
            style:
                OneLineTextStyles.Bold18.copyWith(color: SystemColors.black)),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: clothesData == null
          ? Center(child: CircularProgressIndicator()) // 데이터 로딩 중
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 12),
                  !isMissionCompleted
                      ? MissionWidget(clothesData: clothesData!)
                      : Container(),
                  Center(
                    child: isMissionCompleted
                        ? StatisticsTitleWidget(
                            clothes: clothesData!,
                            isMissionCompleted: isMissionCompleted,
                          )
                        : Container(),
                  ),
                  SizedBox(height: 12),
                  CategoryStatisticsContainerWidget(
                    clothesData: clothesData!,
                    isMissionCompleted: isMissionCompleted,
                  ),
                  SizedBox(height: 12),
                  ColorDistributionWidget(
                    clothesData: clothesData!,
                    isMissionCompleted: isMissionCompleted,
                  ),
                  SizedBox(height: 12),
                  DarknessDistributionWidget(
                    clothesData: clothesData!,
                    isMissionCompleted: isMissionCompleted,
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: SystemColors.white,
                      border:
                          Border.all(color: SignatureColors.begie500, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Text(
                      "앞으로 더 많은 통계가 추가될 예정이에요!",
                      style: BodyTextStyles.Regular14,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

class StatisticsTitleWidget extends StatefulWidget {
  final List<Clothes> clothes;
  final String? displayMessage;
  final bool isMissionCompleted;
  StatisticsTitleWidget(
      {required this.clothes,
      this.displayMessage,
      required this.isMissionCompleted});

  @override
  _StatisticsTitleWidgetState createState() => _StatisticsTitleWidgetState();
}

class _StatisticsTitleWidgetState extends State<StatisticsTitleWidget> {
  DisplayMessageDto message =
      DisplayMessageDto.fromDisplayMessage(DisplayMessage.unknown());

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('ClothesItem initState');
      DisplayMessage _message = await _getDisplayMessage();
      print("message: ${_message.analysisType.name}");
      DisplayMessage? savedMessage =
          await DisplayMessageRepository().getLatestMessage();
      print("savedMessage: ${savedMessage?.analysisType.name}");
      // if (savedMessage == null ||
      //     (_message.analysisType != savedMessage.analysisType)) {
      //   int a = await DisplayMessageRepository().insertMessage(_message);
      //   print("inserted message id: $a");
      //   setState(() {
      //     message = _message;
      //   });
      // } else {
      //   setState(() {
      //     message = savedMessage;
      //   });
      // }
      setState(() {
        message = DisplayMessageDto.fromDisplayMessage(_message);
      });

      LogService().log(LogType.view_screen, "statistics_main_page", null, {
        "title": message.title,
        "description": message.description,
        "addClothesDescription": message.addClothesDescription,
        "analysisType": message.analysisType.name,
        "clothesCount": widget.clothes.length.toString(),
      });
    });
  }

  // Determine the display message based on the table logic
  Future<DisplayMessage> _getDisplayMessage() async {
    try {
      final primaryCategoryCount = <FirstCategory, int>{};
      final secondCategoryCount = <SecondCategory, int>{};
      final representativeClothesColorCount = <ColorName, int>{};

      for (var category in firstCategories) {
        if (category.code == "dress") continue;
        primaryCategoryCount[category] = 0;
      }
      for (var cloth in widget.clothes) {
        // Count by category
        final FirstCategory category = firstCategories
            .firstWhere((element) => element.id == cloth.primaryCategoryId);
        primaryCategoryCount[category] =
            (primaryCategoryCount[category] ?? 0) + 1;

        final SecondCategory secondCategory = secondCategories
            .firstWhere((element) => element.id == cloth.secondaryCategoryId);
        secondCategoryCount[secondCategory] =
            (secondCategoryCount[secondCategory] ?? 0) + 1;
        // Count by color
        final repreentativeColor = colorContainers
            .firstWhere((element) => element.colors.contains(cloth.color))
            .representativeColorName;
        representativeClothesColorCount[repreentativeColor] =
            (representativeClothesColorCount[repreentativeColor] ?? 0) + 1;
      }

      final minimumPrimaryCategory = primaryCategoryCount.entries
          .where((element) => element.key.code != "dress" && element.value < 3)
          .fold<MapEntry<FirstCategory, int>?>(
              null,
              (prev, element) =>
                  prev == null || element.value < prev.value ? element : prev);

      if (widget.clothes.length <= 15) {
        final List<MapEntry<String, String>> titles = [
          MapEntry("미니멀리스트", "image_minimalist_4.svg"),
          MapEntry("맨몸 패셔니스타", "image_minimalist_3.svg"),
          MapEntry("돌려입기 마스터", "image_minimalist_1.svg"),
          MapEntry("미니멀 끝판왕", "image_minimalist_2.svg"),
        ];

        final List<String> descriptions = ["가지고 있는 옷이\n매우 적은 편인 것 같아요!"];
        final List<String> addClothesDescriptions = [
          "옷을 더 등록하면 정확한 결과를 확인할 수 있어요",
          "아직 옷을 등록 중이시겠죠?\n더 등록하고 정확한 유형을 확인하세요",
          "이렇게 옷이 적으실리 없어요!\n옷을 더 등록해 주세요🥲"
        ];
        return DisplayMessage.of(titles, descriptions, addClothesDescriptions,
            null, ClosetAnalysisType.clothingCountLow);
      }

      if (minimumPrimaryCategory != null) {
        final List<MapEntry<String, String?>> titles = [
          MapEntry("${minimumPrimaryCategory.key.name} 미니멀리스트", null),
          MapEntry("${minimumPrimaryCategory.key.name} 무소유", null),
          MapEntry("작고 귀여운 ${minimumPrimaryCategory.key.name}", null),
          MapEntry("${minimumPrimaryCategory.key.name} 자리 고비", null)
        ];

        final List<String> descriptions = [
          "가지고 있는 ${getPostposition(minimumPrimaryCategory.key.name)}\n매우 적으신 편인 것 같아요!"
        ];

        final List<String> addClothesDescriptions = [
          "혹시 가지고 있는 ${getObjectMarker(minimumPrimaryCategory.key.name)}\n덜 등록하신 건 아닐까요?👀",
          "서둘러 ${getObjectMarker(minimumPrimaryCategory.key.name)}\n더 등록해보세요🥲"
        ];

        return DisplayMessage.of(
            titles,
            descriptions,
            addClothesDescriptions,
            "image_minimalist_${minimumPrimaryCategory.key.code}.svg",
            ClosetAnalysisType.primaryCategoryClothesCountLow);
      }

      final topColor = representativeClothesColorCount.entries
          .fold<MapEntry<ColorName, int>?>(
              null,
              (prev, element) =>
                  prev == null || element.value > prev.value ? element : prev);

      if (topColor != null &&
          topColor.value >= widget.clothes.length * 4 / 10) {
        final List<MapEntry<String, String?>> titles = [
          MapEntry("${topColor.key.englishName} 러버", null),
          MapEntry("${topColor.key.englishName} 사랑꾼", null),
        ];

        final List<String> descriptions = [
          "${topColor.key.shortKoreanName} 옷을 엄청\n많이 가지고 계시군요?"
        ];

        final List<String> addClothesDescriptions = [
          "혹시 다른 색깔 옷은\n더 없으신 건가요...?👀",
          "분명 다른 색깔 옷을\n덜 등록하신 걸 거예요!🥲"
        ];

        return DisplayMessage.of(
            titles,
            descriptions,
            addClothesDescriptions,
            "image_color_${topColor.key.name.toLowerCase()}.svg",
            ClosetAnalysisType.colorDominant);
      }

      if (((representativeClothesColorCount[ColorName.BLACK] ?? 0) +
              (representativeClothesColorCount[ColorName.WHITE] ?? 0) +
              (representativeClothesColorCount[ColorName.GRAY] ?? 0)) >=
          widget.clothes.length * 5 / 10) {
        final List<MapEntry<String, String>> titles = [
          MapEntry("흑백 사진관", "image_흑백사진관.svg"),
          MapEntry("수묵담채화", "image_수묵담채화.svg")
        ];

        final List<String> descriptions = [
          "모노톤을 좋아하시군요?\n대부분 흰색, 검정색, 회색 옷이에요!"
        ];

        final List<String> addClothesDescriptions = [
          "혹시 다른 색깔 옷은\n더 없으신 건가요...?👀",
          "컬러감 있는 옷이\n분명 더 있으실 거예요🥲"
        ];

        return DisplayMessage.of(titles, descriptions, addClothesDescriptions,
            null, ClosetAnalysisType.monochromeDominant);
      }

      final MapEntry<String, int> topDarknessDistribution =
          getDarknessDistribution(widget.clothes).entries.reduce(
              (prev, element) => element.value > prev.value ? element : prev);

      if (topDarknessDistribution.value >= (widget.clothes.length * 7 / 10)) {
        if (topDarknessDistribution.key == "진한톤") {
          final List<MapEntry<String, String>> darkToneTitles = [
            MapEntry("다크나이트", "image_darknight.svg"),
            MapEntry("어두컴컴애호가", "image_어두컴컴애호가.svg"),
          ];

          final List<String> darkToneDescriptions = [
            "어두운 톤의 옷을 70% 이상\n가지고 계시군요?"
          ];

          final List<String> darkToneAddClothesDescriptions = [
            "혹시 밝은 옷은\n정말 없으신 건가요...?👀",
            "잊고 있었던 밝은 옷을\n더 등록해 주세요!"
          ];

          return DisplayMessage.of(
              darkToneTitles,
              darkToneDescriptions,
              darkToneAddClothesDescriptions,
              null,
              ClosetAnalysisType.darkToneDominant);
        }
        if (topDarknessDistribution.key == "밝은톤") {
          final List<MapEntry<String, String>> brightToneTitles = [
            MapEntry("파스텔톤 마니아", "image_파스텔톤매니아.svg"),
            MapEntry("봄날의 햇살", "image_sunshine.svg"),
          ];

          final List<String> brightToneDescriptions = [
            "밝은 톤의 옷을 70% 이상\n가지고 계시군요?"
          ];

          final List<String> brightToneAddClothesDescriptions = [
            "혹시 등록하지 못한\n어두운 톤의 옷 없나요?👀",
            "잊고 있었던 어두운 옷을\n더 등록해 주세요!"
          ];
          return DisplayMessage.of(
              brightToneTitles,
              brightToneDescriptions,
              brightToneAddClothesDescriptions,
              null,
              ClosetAnalysisType.lightToneDominant);
        }
      }

      if (representativeClothesColorCount.entries.length <= 3) {
        final List<MapEntry<String, String>> minimalColorTitles = [
          MapEntry("컬러 미니멀리스트", "image_컬러미니멀리스트.svg")
        ];
        final List<String> minimalColorDescriptions = ["가지고 있는 컬러가 많이 적으시네요!"];

        final List<String> minimalColorAddClothesDescriptions = [
          "정말 다른 색깔 옷은 더 없으신 건가요...?👀",
          "분명 생각하지 못한 다른 색 옷이 있을 거예요!"
        ];

        return DisplayMessage.of(
            minimalColorTitles,
            minimalColorDescriptions,
            minimalColorAddClothesDescriptions,
            null,
            ClosetAnalysisType.colorLimited);
      }

      if (representativeClothesColorCount.entries.length >= 7) {
        final List<MapEntry<String, String>> minimalColorTitles = [
          MapEntry("카멜레온", "image_chameleon.svg"),
          MapEntry("보기 힘든 무지개", "image_rainbow.svg"),
        ];

        final List<String> minimalColorDescriptions = [
          "가지고 있는 옷 컬러가\n정말 다양하시군요!"
        ];

        final List<String> minimalColorAddClothesDescriptions = [
          "옷을 더 등록하고\n옷 부자 결과를 받아보세요💪🏻"
        ];

        return DisplayMessage.of(
            minimalColorTitles,
            minimalColorDescriptions,
            minimalColorAddClothesDescriptions,
            null,
            ClosetAnalysisType.colorDominant);
      }

      int topSecondCategoryCount = 0;
      if (secondCategoryCount.isNotEmpty) {
        topSecondCategoryCount = secondCategoryCount.entries
            .map((e) => e.value)
            .toList()
            .reduce((a, b) => a >= b ? a : b);
      }

      final List<MapEntry<SecondCategory, int>> topSecondCategories =
          secondCategoryCount.entries
              .where((element) => element.value == topSecondCategoryCount)
              .toList();

      if (topSecondCategoryCount >= 2) {
        if (topSecondCategories.length == 1) {
          final List<MapEntry<String, String?>> categoryCollectorTitles = [
            MapEntry("${topSecondCategories.first.key.name} 수집가", null),
          ];

          final List<String> categoryCollectorDescriptions = [
            "${topSecondCategories.first.key.name}가 엄청 많으시군요?"
          ];

          final List<String> categoryCollectorAddClothesDescriptions = [
            "혹시 다른 ${topSecondCategories.first.key.name} 종류를\n덜 등록하신 건 아닐까요?👀",
            "${topSecondCategories.first.key.name} 말고 다른 옷을\n떠올려보세요 👀"
          ];
          return DisplayMessage.of(
              categoryCollectorTitles,
              categoryCollectorDescriptions,
              categoryCollectorAddClothesDescriptions,
              "image_collector.svg",
              ClosetAnalysisType.secondCategoryClothesCountHigh);
        }

        if (topSecondCategories.length >= 2) {
          final topSecnodCategoryText = topSecondCategories.sublist(0, 2).map(
            (e) {
              return e.key.name;
            },
          ).join(",");
          final List<MapEntry<String, String?>> categoryCollectorTitles = [
            MapEntry("${topSecnodCategoryText} 수집가", null),
          ];

          final List<String> categoryCollectorDescriptions = [
            "${topSecnodCategoryText}가 엄청 많으시군요?"
          ];

          final List<String> categoryCollectorAddClothesDescriptions = [
            "혹시 다른 ${topSecnodCategoryText} 종류를\n덜 등록하신 건 아닐까요?👀",
            "${topSecnodCategoryText} 말고 다른 옷을\n떠올려보세요 👀"
          ];

          return DisplayMessage.of(
              categoryCollectorTitles,
              categoryCollectorDescriptions,
              categoryCollectorAddClothesDescriptions,
              "image_수집가.svg",
              ClosetAnalysisType.secondCategoriesClothesCountHigh);
        }
      }
    } catch (e) {
      print("error : ${e.toString()}");
    }

    final List<MapEntry<String, String?>> unknownStyleTitles = [
      MapEntry("아직 스타일을 알 수 없어요", "image_default.svg")
    ];

    final List<String> unknownStyleDescriptions = ["우리에겐 아직 미스터리한 당신"];

    final List<String> unknownStyleAddClothesDescriptions = [
      "옷을 조금만 더 등록해\n저희에게 힌트를 주세요🥲",
      "옷을 더 등록해서 정확한\n분석 결과를 받아보세요💪🏻"
    ];

    return DisplayMessage.of(
        unknownStyleTitles,
        unknownStyleDescriptions,
        unknownStyleAddClothesDescriptions,
        null,
        ClosetAnalysisType.unknownStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bear Icon
              Container(
                child: SvgPicture.asset(message.iconUrl),
              ),
              // Placeholder Image (X shape)
            ],
          ),
          SizedBox(height: 16),
          // Title Text
          Text(
            "옷장 분석 결과 당신은",
            style: BodyTextStyles.Medium14.copyWith(
                color: SignatureColors.begie800),
            textAlign: TextAlign.center,
          ),
          // Display Message
          SizedBox(height: 4),

          Text(
            message.title,
            style: BodyTextStyles.Bold24,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),

          Text(
            message.description,
            style:
                BodyTextStyles.Medium16.copyWith(color: SystemColors.gray800),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 32),
          Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(message.addClothesDescription,
                          style: BodyTextStyles.Medium14,
                          textAlign: TextAlign.left),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    message.showAddClothesButton
                        ? GestureDetector(
                            onTap: () async {
                              LogService().log(
                                  LogType.click_button,
                                  "statistics_main_page",
                                  "clothing_register_button", {});

                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddClothesPage(
                                          isUpdate: false,
                                          onClose: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainLayout(
                                                              currentTabIndex:
                                                                  1,
                                                            )));
                                          },
                                        )), // 이동할 페이지
                              );
                              print("res: $res");
                              if (res == 'refresh') {
                                setState(() {}); // 기존 페이지 리프레시
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: SystemColors.black,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  Text(
                                    "옷 등록",
                                    style: OneLineTextStyles.Bold14.copyWith(
                                        color: SystemColors.white),
                                  ),
                                  SizedBox(width: 4),
                                  Container(
                                      width: 14,
                                      height: 14,
                                      child: SvgPicture.asset(
                                        'assets/icons/add.svg',
                                        color: SystemColors.white,
                                      ))
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ]),
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SystemColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SignatureColors.begie500, width: 1),
              ))
        ],
      ),
    );
  }
}
