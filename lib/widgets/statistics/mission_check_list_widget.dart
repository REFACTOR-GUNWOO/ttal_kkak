import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/widgets/statistics/mission_widget.dart';

class MissionCheckListWidget extends StatelessWidget {
  final List<Clothes> clothesData;

  const MissionCheckListWidget({
    Key? key,
    required this.clothesData,
  }) : super(key: key);

  Widget _buildCheckItem(String text, bool isCompleted) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? SignatureColors.orange400 : SystemColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isCompleted
                  ? SignatureColors.orange400
                  : SystemColors.gray600,
              width: 1,
            ),
          ),
          child: isCompleted
              ? SvgPicture.asset(
                  fit: BoxFit.none,
                  "assets/icons/check_icon.svg",
                )
              : null,
        ),
        SizedBox(width: 12),
        Text(
          text,
          style: OneLineTextStyles.Medium14.copyWith(
            color: isCompleted ? SystemColors.gray700 : SystemColors.black,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          _buildCheckItem(
              "옷 10개 이상 등록", MissionHelper.hasEnoughClothes(clothesData)),
          SizedBox(height: 16),
          _buildCheckItem("상의 옷 1개 이상 등록",
              MissionHelper.hasCategoryClothes(clothesData, "top")),
          SizedBox(height: 16),
          _buildCheckItem("하의 옷 1개 이상 등록",
              MissionHelper.hasCategoryClothes(clothesData, "bottom")),
          SizedBox(height: 16),
          _buildCheckItem("아우터 옷 1개 이상 등록",
              MissionHelper.hasCategoryClothes(clothesData, "outer")),
          SizedBox(height: 16),
          _buildCheckItem("신발 1개 이상 등록",
              MissionHelper.hasCategoryClothes(clothesData, "shoes")),
        ],
      ),
    );
  }
}
