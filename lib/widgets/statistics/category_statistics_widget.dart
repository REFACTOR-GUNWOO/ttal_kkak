import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/utils/text_formatter.dart';

class CategoryStatisticsContainerWidget extends StatefulWidget {
  final List<Clothes> clothesData;
  final bool isMissionCompleted;
  CategoryStatisticsContainerWidget(
      {required this.clothesData, required this.isMissionCompleted});

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
          widget.isMissionCompleted
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex =
                                (selectedIndex - 1 + categories.length) %
                                    categories.length;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: SystemColors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: SystemColors.gray500, width: 1),
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
                            selectedIndex =
                                (selectedIndex + 1) % categories.length;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: SystemColors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: SystemColors.gray500, width: 1),
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
                )
              : Text(
                  "상위 카테고리",
                  style: OneLineTextStyles.Bold18.copyWith(
                      color: SystemColors.gray700), // 텍스트 스타일 설정
                ),

          SizedBox(height: 10),

          // 카테고리 통계 위젯
          widget.isMissionCompleted
              ? (categoryData.isNotEmpty
                  ? CategoryStatisticsWidget(
                      categoryData: categoryData,
                      categoryName: selectedCategory.name)
                  : Text("데이터 없음", style: TextStyle(color: Colors.white)))
              : Stack(children: [
                  Image.asset('assets/images/category_statistics_blur.png'),
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("더 정확한 통계를 보기 위해\n미션을 달성해 주세요!",
                              textAlign: TextAlign.center,
                              style: BodyTextStyles.Bold16)))
                ]),
        ],
      ),
    );
  }
}

class CategoryStatisticsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categoryData;
  final String categoryName;

  CategoryStatisticsWidget({
    required this.categoryData,
    required this.categoryName,
  });

  @override
  _CategoryStatisticsWidgetState createState() =>
      _CategoryStatisticsWidgetState();
}

class _CategoryStatisticsWidgetState extends State<CategoryStatisticsWidget> {
  @override
  Widget build(BuildContext context) {
    // 상위 카테고리 ID를 추정 (widget.categoryName을 기반으로 firstCategories에서 찾음)
    final selectedFirstCategory = firstCategories.firstWhere(
      (cat) => cat.name == widget.categoryName,
      orElse: () => firstCategories.first,
    );

    // 하위 카테고리를 priority 순으로 정렬
    List<SecondCategory> subCategories = secondCategories
        .where((cat) => cat.firstCategoryId == selectedFirstCategory.id)
        .toList()
      ..sort((a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));

    // 데이터가 있는 경우와 없는 경우를 처리하기 위한 displayData 준비
    List<Map<String, dynamic>> displayData = [];
    int otherCount = 0;

    if (widget.categoryData.isEmpty ||
        widget.categoryData.every((data) => data['count'] == 0)) {
      // 데이터가 없을 때: 상위 5개 하위 카테고리와 "기타"를 0으로 설정
      displayData = subCategories.take(5).map((cat) {
        return <String, dynamic>{'name': cat.name, 'count': 0};
      }).toList();
      displayData.add(<String, dynamic>{'name': '기타', 'count': 0});
    } else {
      // 데이터가 있을 때: 기존 로직 유지
      List<Map<String, dynamic>> sortedData = List.from(widget.categoryData);
      sortedData.sort((a, b) => b['count'].compareTo(a['count']));

      for (int i = 0; i < sortedData.length; i++) {
        if (i < 5) {
          displayData.add(sortedData[i]);
        } else {
          otherCount += sortedData[i]['count'] as int;
        }
      }

      // 5개 미만일 경우 나머지를 priority 순으로 채움
      if (displayData.length < 5) {
        final remainingSubCategories = subCategories
            .where(
                (cat) => !displayData.any((data) => data['name'] == cat.name))
            .take(5 - displayData.length)
            .map((cat) => <String, dynamic>{'name': cat.name, 'count': 0})
            .toList();
        displayData.addAll(remainingSubCategories);
      }

      displayData.add(<String, dynamic>{
        'name': '기타',
        'count': otherCount > 0 ? otherCount : 0,
      });
    }

    // 가장 많은 항목 찾기
    final mostFrequent = displayData.first;
    final totalCount =
        displayData.fold(0, (sum, item) => sum + (item['count'] as int));

    String _getMostFrequentItemsText() {
      if (totalCount == 0) {
        return "${getObjectMarker(widget.categoryName)} 더 등록하고 정확한 통계를 확인하세요";
      }

      final maxCount = displayData.first['count'] as int;
      final percentValue =
          totalCount > 0 ? ((maxCount * 100) / totalCount).round() : 0;

      final mostFrequentItems = displayData
          .where((item) => item['count'] == maxCount && item['name'] != '기타')
          .map((item) => item['name'] as String)
          .toList();

      String itemsText;
      if (mostFrequentItems.length == 1) {
        itemsText = "${getPostposition(mostFrequentItems[0])}";
      } else if (mostFrequentItems.length == 2) {
        itemsText =
            "${getPostposition("${mostFrequentItems[0]}, ${mostFrequentItems[1]}")} 각";
      } else {
        itemsText =
            "${mostFrequentItems[0]}, ${mostFrequentItems[1]} 외 ${mostFrequentItems.length - 2}이 각";
      }

      return "${widget.categoryName} 중 ${itemsText} ${percentValue}%로 가장 많아요";
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20),
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: 1),
          builder: (context, animationValue, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: totalCount > 0
                      ? mostFrequent['count'].toDouble() * 124 / 100
                      : 1.0, // 최소 높이 보장
                  barGroups: displayData.map((data) {
                    final count = data['count'] as int;
                    final effectiveHeight = count > 0 ? count.toDouble() : 0.1;
                    final isMostFrequent =
                        count == mostFrequent['count'] && count != 0;
                    return BarChartGroupData(
                      showingTooltipIndicators: [0],
                      x: displayData.indexOf(data),
                      barRods: [
                        BarChartRodData(
                          toY: effectiveHeight * animationValue,
                          color: isMostFrequent
                              ? SignatureColors.orange200
                              : data['name'].startsWith('기타')
                                  ? SystemColors.gray600
                                  : SignatureColors.begie500,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      displayData[value.toInt()]['name'],
                                      style: OneLineTextStyles.Medium12,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
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
        Container(
          width: double.infinity - 40,
          padding: EdgeInsets.symmetric(vertical: 12),
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
}
