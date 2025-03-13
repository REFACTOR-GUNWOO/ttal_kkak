import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes_page.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/utils/text_formatter.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LogService().log(LogType.view_screen, "statistics_page", null, {});
      List<Clothes> loadedClothes = await ClothesRepository().loadClothes();

      setState(() {
        clothesData =
            loadedClothes.where((element) => !element.isDraft).toList();
      });
    });
  }

  List<Clothes> clothesData = [];

  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: Colors.blue, width: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignatureColors.begie200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //앱바
        backgroundColor: SignatureColors.begie200,
        title: Text('통계',
            style:
                OneLineTextStyles.Bold18.copyWith(color: SystemColors.black)),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(height: 12),
        Center(
            child: StatisticsTitleWidget(
          clothes: clothesData,
        )),
        // Container(
        //     margin: EdgeInsets.symmetric(horizontal: 20),
        //     height: 50,
        //     decoration: BoxDecoration(
        //       color: SignatureColors.begie300, // 배경색 설정
        //       border: Border.all(
        //         color: SignatureColors.begie500, // 아웃라인 색상 설정
        //         width: 1, // 아웃라인 두께 설정
        //       ),
        //       borderRadius:
        //           BorderRadius.circular(10), // 테두리 모서리를 둥글게 설정 (선택 사항)
        //     ),
        //     child: Row(mainAxisSize: MainAxisSize.min, children: [
        //       Flexible(
        //           child: Text("아우터(이)가 부족해요. 계절에 맞는 아우터를 추가해보세요.",
        //               style: BodyTextStyles.Regular16.copyWith(
        //                   color: SystemColors.black))), // 텍스트 스타일 설정
        //       Text("옷 등록하기")
        //     ])),
        SizedBox(height: 12),

        CategoryStatisticsContainerWidget(clothesData: clothesData),
        SizedBox(height: 12),

        ColorDistributionWidget(
          clothesData: clothesData,
        ),
        SizedBox(height: 12),

        DarknessDistributionWidget(clothesData: clothesData),
        SizedBox(
          height: 12,
        ),
        Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
                color: SystemColors.white,
                border: Border.all(color: SignatureColors.begie500, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(
              "앞으로 더 많은 통계가 추가될 예정이에요!",
              style: BodyTextStyles.Regular14,
              textAlign: TextAlign.center,
            )),
        SizedBox(
          height: 40,
        ) // Add new widget
      ])),
    );
  }
}

class CategoryStatisticsContainerWidget extends StatefulWidget {
  final List<Clothes> clothesData;

  CategoryStatisticsContainerWidget({required this.clothesData});

  @override
  _CategoryStatisticsContainerWidgetState createState() =>
      _CategoryStatisticsContainerWidgetState();
}

class _CategoryStatisticsContainerWidgetState
    extends State<CategoryStatisticsContainerWidget> {
  final List<FirstCategory> categories = firstCategories.where((element) {
    return element.code != "dress";
  }).toList(); // 예제 카테고리
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    FirstCategory selectedCategory = categories[selectedIndex];

    // 현재 선택된 카테고리에 해당하는 아이템 필터링
    List<Clothes> filteredData = widget.clothesData
        .where((item) => item.primaryCategoryId == selectedCategory.id)
        .toList();

    // 카테고리별 개수 집계
    Map<String, int> itemCount = {};

    for (var secondCategory in secondCategories.where(
      (element) {
        return element.firstCategoryId == selectedCategory.id;
      },
    )) {
      itemCount[secondCategory.name] = 0;
    }
    for (var item in filteredData) {
      String categoryName = secondCategories
          .firstWhere((element) => element.id == item.secondaryCategoryId)
          .name;
      itemCount[categoryName] = (itemCount[categoryName] ?? 0) + 1;
    }

    // 데이터를 리스트 형태로 변환 (막대 차트용)
    List<Map<String, dynamic>> categoryData = itemCount.entries
        .map((entry) => {'name': entry.key, 'count': entry.value})
        .toList();

    // 개수 순 정렬
    categoryData.sort((a, b) => b['count'].compareTo(a['count']));

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: SystemColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SignatureColors.begie500, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 카테고리 선택 (좌우 화살표 포함)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = (selectedIndex - 1 + categories.length) %
                          categories.length;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: SystemColors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: SystemColors.gray500, width: 1),
                    ),
                    child: Container(
                        width: 16,
                        height: 16,
                        child: SvgPicture.asset(
                          color: SystemColors.black,
                          'assets/icons/arrow_left.svg',
                        )),
                  )),
              SizedBox(
                width: 12,
              ),
              Text(
                selectedCategory.name + " 카테고리",
                style: OneLineTextStyles.Bold18,
              ),
              SizedBox(
                width: 12,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = (selectedIndex + 1) % categories.length;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: SystemColors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: SystemColors.gray500, width: 1),
                    ),
                    child: Container(
                        width: 16,
                        height: 16,
                        child: SvgPicture.asset(
                          color: SystemColors.black,
                          'assets/icons/arrow_right.svg',
                        )),
                  )),
            ],
          ),

          SizedBox(height: 10),

          // 카테고리 통계 위젯
          categoryData.isNotEmpty
              ? CategoryStatisticsWidget(
                  categoryData: categoryData,
                  categoryName: selectedCategory.name)
              : Text("데이터 없음", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class CategoryStatisticsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categoryData;
  final String categoryName;
  CategoryStatisticsWidget(
      {required this.categoryData, required this.categoryName});

  @override
  _CategoryStatisticsWidgetState createState() =>
      _CategoryStatisticsWidgetState();
}

class _CategoryStatisticsWidgetState extends State<CategoryStatisticsWidget> {
  @override
  Widget build(BuildContext context) {
    // Sort the data by count in descending order
    List<Map<String, dynamic>> sortedData = List.from(widget.categoryData);
    sortedData.sort((a, b) => b['count'].compareTo(a['count']));

    // Limit to top 5 categories, group the rest into "기타"
    List<Map<String, dynamic>> displayData = [];
    int otherCount = 0;

    for (int i = 0; i < sortedData.length; i++) {
      if (i < 5) {
        // Add the top 5 categories to displayData
        displayData.add(sortedData[i]);
      } else {
        // Sum the counts of the remaining categories into "기타"
        otherCount += sortedData[i]['count'] as int;
      }
    }

    // Add "기타" category if there are more than 5 categories
    if (otherCount > 0 || displayData.length < 6) {
      // Include "기타" even if otherCount is 0 to ensure 5 bars if less than 5 categories
      displayData.add({'name': '기타', 'count': otherCount > 0 ? otherCount : 0});
    }

    // Find the most frequent item among the displayed categories
    final mostFrequent = displayData.first;

    String _getMostFrequentItemsText() {
      // 가장 많은 개수 찾기

      final maxCount = displayData.first['count'];

      // 카테고리 내 전체 옷 수 계산
      final totalCount =
          displayData.fold(0, (sum, item) => sum + (item['count'] as int));

      if (totalCount == 0) {
        return "${getObjectMarker(widget.categoryName)} 더 등록하고 정확한 통계를 확인하세요";
      }

      print("totalCount: ${totalCount}");
      // 백분율 계산 (소수점 제거)
      final percentValue =
          totalCount > 0 ? ((maxCount as int) * 100 / totalCount).round() : 0;

      // 동일한 최대 개수를 가진 항목들 모두 찾기
      final mostFrequentItems = displayData
          .where((item) => item['count'] == maxCount && item['name'] != '기타')
          .map((item) => item['name'])
          .toList();

      String itemsText;
      if (mostFrequentItems.length == 1) {
        // 가장 많은 항목이 하나만 있는 경우
        itemsText = "${getPostposition(mostFrequentItems[0])}";
      } else if (mostFrequentItems.length == 2) {
        // 가장 많은 항목이 두 개인 경우
        itemsText =
            "${getPostposition("${mostFrequentItems[0]}, ${mostFrequentItems[1]}")}";
      } else {
        // 가장 많은 항목이 세 개 이상인 경우
        itemsText =
            "${mostFrequentItems[0]}, ${mostFrequentItems[1]} 외 ${mostFrequentItems.length - 2}이";
      }

      return "${widget.categoryName} 중 ${itemsText} 각 ${percentValue}%로 가장 많아요";
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
        ),
        // 막대 차트 애니메이션 적용
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: 1), // 0부터 1까지 변화
          builder: (context, animationValue, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: mostFrequent['count'].toDouble() *
                      124 /
                      100, // Set maxY to the highest count
                  barGroups: displayData.map((data) {
                    final count = data['count'] as int;
                    // Ensure a minimum height of 1.0 for visibility
                    final effectiveHeight = count > 0 ? count.toDouble() : 0.1;
                    // Determine if this bar is the most frequent (1st place)
                    final isMostFrequent =
                        count == mostFrequent['count'] && count != 0;
                    print("animationValue: $animationValue");
                    return BarChartGroupData(
                      showingTooltipIndicators: [0],
                      x: displayData.indexOf(data),
                      barRods: [
                        BarChartRodData(
                          toY: effectiveHeight * animationValue, // 애니메이션 값 적용
                          color: isMostFrequent
                              ? SignatureColors
                                  .orange200 // Blue for the most frequent category
                              : data['name'].startsWith('기타')
                                  ? SystemColors.gray600 // Darker grey for "기타"
                                  : SignatureColors
                                      .begie500, // Default grey for others
                          width: 24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 40,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                              meta: meta,
                              space: 12,
                              child: Container(
                                  width: 44,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                            child: Text(
                                          displayData[value.toInt()]['name'],
                                          style: OneLineTextStyles.Medium12,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ))
                                      ])));
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: EdgeInsets.zero,
                      fitInsideVertically: true,
                      tooltipMargin: 4,
                      getTooltipColor: (group) => Colors.transparent,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        print("rod.toY: ${rod.toY}");
                        return BarTooltipItem(
                          rod.toY.round().toString(),
                          OneLineTextStyles.Bold14.copyWith(
                              color: SystemColors.gray900),
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 24),

        // 하단 설명 텍스트
        Container(
          width: double.infinity - 40,
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: SignatureColors.begie200,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _getMostFrequentItemsText(),
            style: BodyTextStyles.Medium12,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // 가장 많은 항목들을 표시하는 텍스트 생성
}

class ColorDistributionWidget extends StatefulWidget {
  final List<Clothes> clothesData;

  ColorDistributionWidget({required this.clothesData});

  @override
  _ColorDistributionWidgetState createState() =>
      _ColorDistributionWidgetState();
}

class _ColorDistributionWidgetState extends State<ColorDistributionWidget> {
  double startDegreeOffset = 180;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          startDegreeOffset = 270;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorData = _getColorData();
    if (colorData.isEmpty) {
      return Center(
        child: Text("옷을 더 등록하고 정확한 통계를 확인하세요",
            style: TextStyle(color: Colors.white)),
      );
    }

    final totalItems = colorData.values.fold(0, (sum, item) => sum + item);
    final topColors = _getTopColors(colorData);
    final mostFrequent = topColors.first;
    final mostFrequentPercentage = (mostFrequent['count'] / totalItems) * 100;

    // 카테고리 정보를 백분율과 함께 가져오도록 수정
    final mostFrequentCategoryData =
        _getMostFrequentCategory(mostFrequent['name']);
    final mostFrequentCategory = mostFrequentCategoryData["category"];
    final mostFrequentCategoryCount = mostFrequentCategoryData["count"];
    final mostFrequentCategoryPercent = mostFrequentCategoryData["percent"];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SystemColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SignatureColors.begie500, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("컬러 분포",
              style:
                  OneLineTextStyles.Bold18.copyWith(color: SystemColors.black)),
          SizedBox(height: 20),
          Container(
              height: 144,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: PieChart(
                      curve: Curves.easeOut,
                      duration: Duration(milliseconds: 2000),
                      PieChartData(
                        sections:
                            _generatePieChartSections(topColors, totalItems),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        startDegreeOffset: startDegreeOffset,
                        centerSpaceRadius: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: 32),
                  Container(
                    height: 140,
                    width: 108,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: topColors.map(_buildColorRow).toList(),
                    ),
                  )
                ],
              )),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: SignatureColors.begie200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  "${mostFrequent['name']} 옷이 ${mostFrequentPercentage.toStringAsFixed(0)}%로 가장 많아요",
                  style: BodyTextStyles.Medium12,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "${mostFrequent['name']} 옷 중 ${mostFrequentCategory}가 ${mostFrequentCategoryPercent}%로 가장 많아요",
                  style: BodyTextStyles.Medium12,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<ColorName, int> _getColorData() {
    Map<ColorName, int> colorData = {};
    for (var item in widget.clothesData) {
      ColorName color = colorContainers
          .firstWhere((element) => element.colors.contains(item.color))
          .representativeColorName;
      colorData[color] = (colorData[color] ?? 0) + 1;
    }
    return colorData;
  }

  List<Map<String, dynamic>> _getTopColors(Map<ColorName, int> colorData) {
    List<MapEntry<ColorName, int>> sortedColors = colorData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<Map<String, dynamic>> topColors = [];
    int otherCount = 0;
    for (int i = 0; i < sortedColors.length; i++) {
      if (i < 3) {
        topColors.add({
          'name': sortedColors[i].key.koreanName,
          'count': sortedColors[i].value
        });
      } else {
        otherCount += sortedColors[i].value;
      }
    }
    if (otherCount > 0) {
      topColors.add({'name': '기타', 'count': otherCount});
    }
    return topColors;
  }

  Map<String, dynamic> _getMostFrequentCategory(String color) {
    // 해당 색상의 옷만 필터링
    List<Clothes> colorClothes = widget.clothesData
        .where((item) =>
            colorContainers
                .firstWhere((element) => element.colors.contains(item.color))
                .representativeColorName
                .koreanName ==
            color)
        .toList();

    // 카테고리별로 분류
    Map<String, int> categoryCount = {};
    for (var item in colorClothes) {
      String categoryName = firstCategories
          .firstWhere((element) => element.id == (item.primaryCategoryId))
          .name;
      categoryCount[categoryName] = (categoryCount[categoryName] ?? 0) + 1;
    }

    // 가장 많은 카테고리 찾기
    final mostFrequentEntry =
        categoryCount.entries.reduce((a, b) => a.value > b.value ? a : b);

    // 전체 개수에 대한 백분율 계산
    final totalCount = colorClothes.length;
    final percent = totalCount > 0
        ? ((mostFrequentEntry.value / totalCount) * 100).round()
        : 0;

    return {
      "category": mostFrequentEntry.key,
      "count": mostFrequentEntry.value,
      "percent": percent
    };
  }

  List<PieChartSectionData> _generatePieChartSections(
      List<Map<String, dynamic>> colorData, int totalItems) {
    print("colorData: $colorData");
    final sortedColorData = colorData.toList()
      ..sort((a, b) {
        try {
          // 비교 항목이 null이 아닌지 확인
          final aName = a['name'] ?? "알 수 없음";
          final bName = b['name'] ?? "알 수 없음";

          // count 키가 존재하는지 확인
          final aCount = a['count'] ?? 0;
          final bCount = b['count'] ?? 0;

          // "기타" 항목은 항상 맨 뒤로 정렬
          if (aName == "기타" && bName != "기타") {
            return 1; // a가 뒤로
          }
          if (aName != "기타" && bName == "기타") {
            return -1; // b가 뒤로
          }

          // 둘 다 "기타"가 아니면 count 기준 내림차순 정렬
          return bCount.compareTo(aCount);
        } catch (e) {
          LogService().log(LogType.error, "statistics_page", "color_sort_error",
              {"error": e.toString(), "a": a.toString(), "b": b.toString()});
          return 0; // 오류 발생 시 정렬 변경 없음
        }
      });

    try {
      return sortedColorData.map((entry) {
        double percentage = (entry['count'] / totalItems) * 100;
        return PieChartSectionData(
          value: percentage,
          color: (entry['name'] == "기타")
              ? SystemColors.gray700
              : ClothesColor.fromName(colorContainers
                      .firstWhere((element) =>
                          element.representativeColorName.koreanName ==
                          entry['name'])
                      .representativeColor
                      .name)
                  .color,
          radius: 30,
          title: "",
        );
      }).toList();
    } catch (e) {
      LogService().log(LogType.error, "statistics_page", "color_map_error",
          {"error": e.toString()});
      // 오류 발생 시 빈 리스트 반환
      return [];
    }
  }

  Widget _buildColorRow(Map<String, dynamic> entry) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                color: (entry['name'] == "기타")
                    ? SystemColors.gray700
                    : ClothesColor.fromName(colorContainers
                            .firstWhere((element) =>
                                element.representativeColorName.koreanName ==
                                entry['name'])
                            .representativeColor
                            .name)
                        .color,
                borderRadius: BorderRadius.circular(4),
                border: (entry['name'] == "흰색")
                    ? Border.all(color: SystemColors.gray700, width: 1)
                    : null,
              ),
            ),
            SizedBox(width: 8),
            Text("${entry['name']} ${entry['count']}",
                style: OneLineTextStyles.Bold14.copyWith(
                    color: SystemColors.black)),
          ],
        ));
  }
}

class DarknessDistributionWidget extends StatefulWidget {
  final List<Clothes> clothesData;

  DarknessDistributionWidget({required this.clothesData});

  @override
  _DarknessDistributionWidgetState createState() =>
      _DarknessDistributionWidgetState();
}

class _DarknessDistributionWidgetState
    extends State<DarknessDistributionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final darknessDistribution = _getDarknessDistribution(widget.clothesData);
    if (darknessDistribution.values.every((count) => count == 0)) {
      return Center(
        child: Text("옷을 더 등록하고 정확한 통계를 확인하세요",
            style: TextStyle(color: Colors.white)),
      );
    }

    // Find the maximum count for scaling the chart
    final maxCount =
        darknessDistribution.values.reduce((a, b) => a > b ? a : b);

    // 전체 옷 개수 계산
    final totalCount =
        darknessDistribution.values.fold(0, (sum, count) => sum + count);

    // 가장 많은 톤 찾기
    final mostFrequentTone = darknessDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    // 백분율 계산 (반올림)
    final percentValue = totalCount > 0
        ? ((mostFrequentTone.value / totalCount) * 100).round()
        : 0;

    // 표시할 메시지 생성
    String message;
    if (darknessDistribution['진한톤']! > darknessDistribution['밝은톤']!) {
      message = "진한톤의 옷이 ${percentValue}%로 가장 많아요";
    } else if (darknessDistribution['밝은톤']! > darknessDistribution['진한톤']!) {
      message = "밝은톤의 옷이 ${percentValue}%로 가장 많아요";
    } else {
      message = "진한톤과 밝은톤의 옷이 각 50%로 균형있게 있어요";
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SystemColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SignatureColors.begie500, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("컬러 진하기",
              style:
                  OneLineTextStyles.Bold18.copyWith(color: SystemColors.black)),
          SizedBox(height: 20),

          // ✅ 애니메이션 추가
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
            tween: Tween(begin: 0, end: 1), // 0부터 1까지 변화
            builder: (context, animationValue, child) {
              return SizedBox(
                height: 140,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxCount.toDouble() / 94 * 116,
                    barGroups: darknessDistribution.entries.map((entry) {
                      return BarChartGroupData(
                        x: darknessDistribution.keys
                            .toList()
                            .indexOf(entry.key),
                        showingTooltipIndicators: [0],
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.toDouble() *
                                animationValue, // ✅ 애니메이션 반영
                            color: entry.key == '진한톤'
                                ? SignatureColors.begie800
                                : SignatureColors.begie300,
                            width: 40,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 27,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final labels = darknessDistribution.keys.toList();

                            return SideTitleWidget(
                                space: 12,
                                child: value.toInt() < labels.length
                                    ? Text(
                                        labels[value.toInt()],
                                        style: OneLineTextStyles.Medium12,
                                      )
                                    : const SizedBox.shrink(),
                                meta: meta);
                          },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 0,
                        getTooltipColor: (group) => Colors.transparent,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(rod.toY.round().toString(),
                              OneLineTextStyles.Medium14);
                        },
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        direction: TooltipDirection.top,
                      ),
                      handleBuiltInTouches: true,
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: SignatureColors.begie200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  message,
                  style: BodyTextStyles.Medium12,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayMessage {
  final String title;
  final String description;
  final bool showAddClothesButton;
  DisplayMessage(
      {required this.title,
      required this.description,
      this.showAddClothesButton = false});
}

class StatisticsTitleWidget extends StatefulWidget {
  final List<Clothes> clothes;
  final String? displayMessage;

  StatisticsTitleWidget({required this.clothes, this.displayMessage});

  @override
  _StatisticsTitleWidgetState createState() => _StatisticsTitleWidgetState();
}

class _StatisticsTitleWidgetState extends State<StatisticsTitleWidget> {
  // Determine the display message based on the table logic
  DisplayMessage _getDisplayMessage() {
    try {
      final primaryCategoryCount = <FirstCategory, int>{};
      final secondCategoryCount = <SecondCategory, int>{};
      final representativeClothesColorCount = <ColorName, int>{};

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
          .where((element) => element.key.code != "outer" && element.value < 3)
          .fold<MapEntry<FirstCategory, int>?>(
              null,
              (prev, element) =>
                  prev == null || element.value < prev.value ? element : prev);

      if (minimumPrimaryCategory != null) {
        return DisplayMessage(
            title: "${minimumPrimaryCategory.key.name} 미니멀리스트!",
            description:
                "${getPostposition(minimumPrimaryCategory.key.name)} 부족해요. 계절에 맞는 ${getObjectMarker(minimumPrimaryCategory.key.name)} 추가해보세요.",
            showAddClothesButton: true);
      }

      final topColor = representativeClothesColorCount.entries
          .fold<MapEntry<ColorName, int>?>(
              null,
              (prev, element) =>
                  prev == null || element.value > prev.value ? element : prev);

      if (topColor != null &&
          topColor.value >= widget.clothes.length * 4 / 10) {
        return DisplayMessage(
            title: "${topColor.key.koreanName}러버",
            description: "색상이 단조로워요. 새로운 컬러를 추가해보는 건 어떨까요?",
            showAddClothesButton: true);
      }

      if (((representativeClothesColorCount[ColorName.BLACK] ?? 0) +
              (representativeClothesColorCount[ColorName.WHITE] ?? 0) +
              (representativeClothesColorCount[ColorName.GRAY] ?? 0)) >=
          widget.clothes.length * 5 / 10) {
        return DisplayMessage(
            title: "모노톤 러버",
            description: "색상이 단조로워요. 새로운 컬러를 추가해보는 건 어떨까요?",
            showAddClothesButton: true);
      }

      final MapEntry<String, int> topDarknessDistribution =
          _getDarknessDistribution(widget.clothes).entries.reduce(
              (prev, element) => element.value > prev.value ? element : prev);

      if (topDarknessDistribution.value >= widget.clothes.length * 7 / 10) {
        if (topDarknessDistribution.key == "진한톤") {
          return DisplayMessage(
              title: "딥톤 러버",
              description: "진한 컬러가 많아요. 밝은 컬러를 추가해보는 건 어떨까요?",
              showAddClothesButton: true);
        }
        if (topDarknessDistribution.key == "밝은톤") {
          return DisplayMessage(
              title: "파스텔톤 마니아",
              description: "밝은 컬러가 많아요. 진한 컬러를 추가해보는 건 어떨까요?",
              showAddClothesButton: true);
        }
      }

      if (representativeClothesColorCount.entries.length <= 3) {
        return DisplayMessage(
            title: "컬러 미니멀리스트",
            description: "색상이 단조로워요. 새로운 컬러를 추가해보는 건 어떨까요?",
            showAddClothesButton: true);
      }

      if (representativeClothesColorCount.entries.length >= 7) {
        return DisplayMessage(
            title: "패션 카멜레온", description: "다양한 컬러가 골고루 있어요! 완벽한 스타일링 가능!");
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
          return DisplayMessage(
              title: "${topSecondCategories.first.key.name} 부자!",
              description:
                  "${topSecondCategories.first.key.name} 부자시네요! 다른 아이템과 매치해서 입어보세요!");
        }

        if (topSecondCategories.length >= 2) {
          return DisplayMessage(
              title: "${topSecondCategories.sublist(0, 2).map(
                (e) {
                  return e.key.name;
                },
              ).join(",")} 부자!",
              description: "${topSecondCategories.sublist(0, 2).map(
                (e) {
                  return e.key.name;
                },
              ).join(",")} 부자시네요! 다른 아이템과 매치해서 입어보세요!");
        }
      }
    } catch (e) {
      print("error : ${e.toString()}");
    }

    return DisplayMessage(
        title: "아직 스타일을 알 수 없어요",
        description: "옷을 더 등록하고\n스타일 분석 값을 받아보세요",
        showAddClothesButton: true);
  }

  @override
  Widget build(BuildContext context) {
    final message = _getDisplayMessage();

    return Container(
      // padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bear Icon
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SystemColors.white,
                ),
                child: Icon(
                  Icons.pets, // Placeholder for bear icon
                  size: 24,
                ),
              ),
              // Placeholder Image (X shape)
            ],
          ),
          SizedBox(height: 16),
          // Title Text
          Text(
            "옷장 분석 결과 당신은",
            style: BodyTextStyles.Regular16,
            textAlign: TextAlign.center,
          ),
          // Display Message
          Container(
            child: Text(
              _getDisplayMessage().title,
              style: BodyTextStyles.Bold24,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(_getDisplayMessage().description,
                          style: BodyTextStyles.Medium14,
                          textAlign: TextAlign.left),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    message.showAddClothesButton
                        ? GestureDetector(
                            onTap: () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddClothesPage(
                                          isUpdate: false,
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

// Calculate the count of dark and light colors
Map<String, int> _getDarknessDistribution(List<Clothes> clothes) {
  int darkCount = 0;
  int lightCount = 0;

  for (var item in clothes) {
    ClothesColor color = item.color;
    if (color.darkness >= 500) {
      darkCount++;
    } else {
      lightCount++;
    }
  }

  return {
    '진한톤': darkCount,
    '밝은톤': lightCount,
  };
}
