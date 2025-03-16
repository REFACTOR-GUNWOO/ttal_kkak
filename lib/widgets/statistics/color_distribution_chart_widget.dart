import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/utils/text_formatter.dart';

class ColorDistributionWidget extends StatefulWidget {
  final List<Clothes> clothesData;
  final bool isMissionCompleted;
  ColorDistributionWidget(
      {required this.clothesData, required this.isMissionCompleted});

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
        if (mounted) {
          // mounted 체크 추가
          setState(() {
            startDegreeOffset = 270;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              style: OneLineTextStyles.Bold18.copyWith(
                  color: widget.isMissionCompleted
                      ? SystemColors.black
                      : SystemColors.gray700)),
          SizedBox(height: 20),
          widget.isMissionCompleted
              ? ColorDistributionChartWidget(
                  clothesData: widget.clothesData,
                  startDegreeOffset: startDegreeOffset,
                )
              : Stack(children: [
                  Image.asset(
                      'assets/images/color_distribution_statistics_blur.png'),
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

class ColorDistributionChartWidget extends StatelessWidget {
  final double startDegreeOffset;
  final List<Clothes> clothesData;
  const ColorDistributionChartWidget({
    Key? key,
    required this.startDegreeOffset,
    required this.clothesData,
  }) : super(key: key);

  Map<ColorName, int> _getColorData() {
    Map<ColorName, int> colorData = {};
    if (clothesData.isEmpty) return colorData; // 빈 데이터 처리
    for (var item in clothesData) {
      ColorName color = colorContainers
          .firstWhere((element) => element.colors.contains(item.color))
          .representativeColorName;
      colorData[color] = (colorData[color] ?? 0) + 1;
    }
    return colorData;
  }

  List<Map<String, dynamic>> _getTopColors(Map<ColorName, int> colorData) {
    if (colorData.isEmpty) {
      return [
        {'name': '기타', 'count': 0}
      ]; // 빈 데이터일 경우 빈 리스트 반환
    }

    List<MapEntry<ColorName, int>> sortedColors = colorData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<Map<String, dynamic>> topColors = [];
    int otherCount = 0;
    for (int i = 0; i < sortedColors.length; i++) {
      if (i < 3) {
        topColors.add({
          'name': sortedColors[i].key.fullKoreanName,
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
    List<Clothes> colorClothes = clothesData
        .where((item) =>
            colorContainers
                .firstWhere((element) => element.colors.contains(item.color))
                .representativeColorName
                .fullKoreanName ==
            color)
        .toList();

    if (colorClothes.isEmpty) {
      return {"category": "없음", "count": 0, "percent": 0}; // 빈 데이터 처리
    }

    Map<String, int> categoryCount = {};
    for (var item in colorClothes) {
      String categoryName = firstCategories
          .firstWhere((element) => element.id == (item.primaryCategoryId))
          .name;
      categoryCount[categoryName] = (categoryCount[categoryName] ?? 0) + 1;
    }

    final mostFrequentEntry =
        categoryCount.entries.reduce((a, b) => a.value > b.value ? a : b);

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

  @override
  Widget build(BuildContext context) {
    final colorData = _getColorData();

    // if (colorData.isEmpty) {
    //   return Center(
    //     child: Text(
    //       "옷을 더 등록하고 정확한 통계를 확인하세요",
    //       style: BodyTextStyles.Medium16.copyWith(color: SystemColors.gray700),
    //     ),
    //   );
    // }

    final totalItems = colorData.values.fold(0, (sum, item) => sum + item);
    final topColors = _getTopColors(colorData);
    final mostFrequent = topColors.isNotEmpty
        ? topColors.first
        : {"name": "기타", "count": 0}; // 기본값 설정
    final mostFrequentPercentage =
        totalItems > 0 ? (mostFrequent['count'] / totalItems) * 100 : 0.0;

    final mostFrequentCategoryData =
        _getMostFrequentCategory(mostFrequent['name']);
    final mostFrequentCategory = mostFrequentCategoryData["category"];
    final mostFrequentCategoryPercent = mostFrequentCategoryData["percent"];

    return Column(
      children: [
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
                    sections: _generatePieChartSections(topColors, totalItems),
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
          ),
        ),
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: SignatureColors.begie200,
            borderRadius: BorderRadius.circular(6),
          ),
          child: clothesData.isEmpty
              ? Text(
                  "옷을 더 등록하고 정확한 통계를 확인하세요",
                  style: BodyTextStyles.Medium12,
                  textAlign: TextAlign.center,
                )
              : Column(
                  children: [
                    Text(
                      "${mostFrequent['name']} 옷이 ${mostFrequentPercentage.toStringAsFixed(0)}%로 가장 많아요",
                      style: BodyTextStyles.Medium12,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${mostFrequent['name']} 옷 중 ${getPostposition(mostFrequentCategory)} ${mostFrequentCategoryPercent}%로 가장 많아요",
                      style: BodyTextStyles.Medium12,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generatePieChartSections(
      List<Map<String, dynamic>> topColors, int totalItems) {
    try {
      return topColors.map((entry) {
        double percentage =
            totalItems == 0 ? 100 : (entry['count'] / totalItems) * 100;
        return PieChartSectionData(
          value: percentage,
          color: (entry['name'] == "기타")
              ? SystemColors.gray600
              : ClothesColor.fromName(colorContainers
                      .firstWhere((element) =>
                          element.representativeColorName.fullKoreanName ==
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
      return [
        PieChartSectionData(
          value: 100,
          color: SystemColors.gray600,
          radius: 30,
          title: "",
        )
      ];
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
                  ? SystemColors.gray600
                  : ClothesColor.fromName(colorContainers
                          .firstWhere((element) =>
                              element.representativeColorName.fullKoreanName ==
                              entry['name'])
                          .representativeColor
                          .name)
                      .color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 8),
          Text(
            "${entry['name']} ${entry['count']}",
            style: OneLineTextStyles.Bold14.copyWith(color: SystemColors.black),
          ),
        ],
      ),
    );
  }
}
