import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

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
        clothesData = loadedClothes;
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
        SizedBox(height: 20),
        Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SvgPicture.asset(
                "assets/icons/statistics_page_icon.svg",
              ),
              Text('옷장 분석 결과 당신은...',
                  style: BodyTextStyles.Regular16.copyWith(
                      color: SystemColors.black)),
              SizedBox(
                  child: Text('파랑 중독자 이군요!',
                      textAlign: TextAlign.center,
                      style: BodyTextStyles.Bold24.copyWith(
                          color: SystemColors.black)))
            ])),
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
        SizedBox(height: 20),

        CategoryStatisticsContainerWidget(clothesData: clothesData
            // clothesData: clothesData,
            ),
        SizedBox(height: 10),

        ColorDistributionWidget(
          clothesData: clothesData,
        )
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
      width: 320,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 카테고리 선택 (좌우 화살표 포함)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedIndex = (selectedIndex - 1 + categories.length) %
                        categories.length;
                  });
                },
              ),
              Text(
                selectedCategory.name,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedIndex = (selectedIndex + 1) % categories.length;
                  });
                },
              ),
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
    // 가장 많은 개수를 가진 항목 찾기
    List<Map<String, dynamic>> sortedData = List.from(widget.categoryData);
    sortedData.sort((a, b) => b['count'].compareTo(a['count']));
    final mostFrequent = sortedData.first;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 막대 차트 애니메이션 적용
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: 1), // 0부터 1까지 변화
          builder: (context, animationValue, child) {
            return Container(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: mostFrequent['count'] + 2.0, // 최대값보다 약간 여유 추가
                  barGroups: sortedData.map((data) {
                    return BarChartGroupData(
                      x: sortedData.indexOf(data),
                      barRods: [
                        BarChartRodData(
                          toY: data['count'].toDouble() *
                              animationValue, // 애니메이션 값 적용
                          color: Colors.grey[400],
                          width: 15,
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
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            sortedData[value.toInt()]['name'],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 10),

        // 하단 설명 텍스트
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${widget.categoryName} 중 ${mostFrequent['name']}가 ${mostFrequent['count']}개로 가장 많아요",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class ColorDistributionWidget extends StatefulWidget {
  final List<Clothes> clothesData;

  ColorDistributionWidget({required this.clothesData});

  @override
  _ColorDistributionWidgetState createState() =>
      _ColorDistributionWidgetState();
}

class _ColorDistributionWidgetState extends State<ColorDistributionWidget> {
  double startDegreeOffset = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          startDegreeOffset = 90;
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
    final mostFrequentCategoryData =
        _getMostFrequentCategory(mostFrequent['name']);
    final mostFrequentCategory = mostFrequentCategoryData["category"];
    final mostFrequentCategoryCount = mostFrequentCategoryData["count"];

    return Container(
      width: 320,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("컬러 분포",
              style: OneLineTextStyles.Bold18.copyWith(color: Colors.white)),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 160,
                height: 150,
                child: PieChart(
                  curve: Curves.easeOut,
                  duration: Duration(milliseconds: 2000),
                  PieChartData(
                    sections: _generatePieChartSections(topColors, totalItems),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    startDegreeOffset: startDegreeOffset,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: topColors.map(_buildColorRow).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  "${mostFrequent['name']} 옷이 ${mostFrequentPercentage.toStringAsFixed(1)}%로 가장 많아요",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "${mostFrequent['name']} 옷 중 ${mostFrequentCategory}가 ${mostFrequentCategoryCount}개로 가장 많아요",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _getColorData() {
    Map<String, int> colorData = {};
    for (var item in widget.clothesData) {
      String color = colorContainers
          .firstWhere((element) => element.colors.contains(item.color))
          .representativeColorName;
      colorData[color] = (colorData[color] ?? 0) + 1;
    }
    return colorData;
  }

  List<Map<String, dynamic>> _getTopColors(Map<String, int> colorData) {
    List<MapEntry<String, int>> sortedColors = colorData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<Map<String, dynamic>> topColors = [];
    int otherCount = 0;
    for (int i = 0; i < sortedColors.length; i++) {
      if (i < 3) {
        topColors
            .add({'name': sortedColors[i].key, 'count': sortedColors[i].value});
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
    List<String> categories = widget.clothesData
        .where((item) =>
            colorContainers
                .firstWhere((element) => element.colors.contains(item.color))
                .representativeColorName ==
            color)
        .map((item) => firstCategories
            .firstWhere((element) => element.id == (item.primaryCategoryId))
            .name)
        .toList();

    Map<String, int> categoryCount = {};
    for (var category in categories) {
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }
    final mostFrequentEntry =
        categoryCount.entries.reduce((a, b) => a.value > b.value ? a : b);
    return {
      "category": mostFrequentEntry.key,
      "count": mostFrequentEntry.value
    };
  }

  List<PieChartSectionData> _generatePieChartSections(
      List<Map<String, dynamic>> colorData, int totalItems) {
    return colorData.map((entry) {
      double percentage = (entry['count'] / totalItems) * 100;
      return PieChartSectionData(
        value: percentage,
        color: (entry['name'] == "기타")
            ? Colors.white
            : ClothesColor.fromName(colorContainers
                    .firstWhere((element) =>
                        element.representativeColorName == entry['name'])
                    .representativeColor
                    .name)
                .color,
        radius: 40,
        title: "",
      );
    }).toList();
  }

  Widget _buildColorRow(Map<String, dynamic> entry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: (entry['name'] == "기타")
                ? Colors.white
                : ClothesColor.fromName(colorContainers
                        .firstWhere((element) =>
                            element.representativeColorName == entry['name'])
                        .representativeColor
                        .name)
                    .color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Text("${entry['name']} ${entry['count']}",
            style: OneLineTextStyles.Medium14.copyWith(color: Colors.white)),
      ],
    );
  }
}
