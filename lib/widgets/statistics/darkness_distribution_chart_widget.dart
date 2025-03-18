import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

Map<String, int> getDarknessDistribution(List<Clothes> clothes) {
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

class DarknessDistributionWidget extends StatefulWidget {
  final List<Clothes> clothesData;
  final bool isMissionCompleted;

  DarknessDistributionWidget({
    required this.clothesData,
    required this.isMissionCompleted,
  });

  @override
  _DarknessDistributionWidgetState createState() =>
      _DarknessDistributionWidgetState();
}

class _DarknessDistributionWidgetState
    extends State<DarknessDistributionWidget> {
  @override
  Widget build(BuildContext context) {
    final darknessDistribution = getDarknessDistribution(widget.clothesData);

    // 전체 옷 개수 계산
    final totalCount =
        darknessDistribution.values.fold(0, (sum, count) => sum + count);

    // 최대값 계산 (그래프 높이 설정용)
    final maxCount = totalCount > 0
        ? darknessDistribution.values.reduce((a, b) => a > b ? a : b)
        : 1; // 데이터가 없어도 그래프를 그리기 위해 최소값 1 설정

    // 가장 많은 톤 찾기
    final mostFrequentTone = totalCount > 0
        ? darknessDistribution.entries
            .reduce((a, b) => a.value > b.value ? a : b)
        : darknessDistribution.entries.first;

    // 백분율 계산 (반올림)
    final percentValue = totalCount > 0
        ? ((mostFrequentTone.value / totalCount) * 100).round()
        : 0;

    // 표시할 메시지 생성
    String message;
    if (totalCount == 0) {
      message = "옷을 더 등록하고 정확한 통계를 확인하세요";
    } else if (darknessDistribution['진한톤']! > darknessDistribution['밝은톤']!) {
      message = "진한톤의 옷이 ${percentValue}%로 가장 많아요";
    } else if (darknessDistribution['밝은톤']! > darknessDistribution['진한톤']!) {
      message = "밝은톤의 옷이 ${percentValue}%로 가장 많아요";
    } else {
      message = "진한톤과 밝은톤의 옷이 각 50%로 균형있게 있어요";
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: SystemColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SignatureColors.begie500, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "컬러 진하기",
            style: OneLineTextStyles.Bold18.copyWith(
                color: widget.isMissionCompleted
                    ? SystemColors.black
                    : SystemColors.gray700),
          ),
          SizedBox(height: 32),
          widget.isMissionCompleted
              ? DarknessDistributionChartWidget(
                  darknessDistribution: darknessDistribution,
                  maxCount: maxCount,
                  message: message,
                )
              : Stack(
                  children: [
                    Image.asset(
                        'assets/images/color_darkness_statistics_blur.png'),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "더 정확한 통계를 보기 위해\n미션을 달성해 주세요!",
                          textAlign: TextAlign.center,
                          style: BodyTextStyles.Bold16,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class DarknessDistributionChartWidget extends StatelessWidget {
  final Map<String, int> darknessDistribution;
  final int maxCount;
  final String message;

  const DarknessDistributionChartWidget({
    Key? key,
    required this.darknessDistribution,
    required this.maxCount,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: 1),
          builder: (context, animationValue, child) {
            return SizedBox(
              height: 140,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxCount.toDouble() / 94 * 116,
                  barGroups: darknessDistribution.entries.map((entry) {
                    return BarChartGroupData(
                      x: darknessDistribution.keys.toList().indexOf(entry.key),
                      showingTooltipIndicators: [0],
                      barRods: [
                        BarChartRodData(
                          fromY: -maxCount / 10,
                          toY: entry.value.toDouble() * animationValue,
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
                            meta: meta,
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: EdgeInsets.zero,
                      tooltipMargin: 4,
                      getTooltipColor: (group) => Colors.transparent,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.round().toString(),
                          OneLineTextStyles.Medium14,
                        );
                      },
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
    );
  }
}
