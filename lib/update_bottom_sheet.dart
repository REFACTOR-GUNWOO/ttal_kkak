import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/common_bottom_sheet.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class UpdateBottomSheet extends StatelessWidget {
  Clothes clothes;
  ClothesUpdateProvider? updateProvider;
  final VoidCallback onReload;

  UpdateBottomSheet({required this.clothes, required this.updateProvider, required this.onReload});
  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildOptionButton(
              iconPath: "assets/icons/update_icon.svg",
              label: "정보 수정하기",
              onTap: () {
                Navigator.pop(context);

                // 정보 수정 기능
                updateProvider!.set(clothes);
                ShowAddClothesBottomSheet(context, true);
              },
            ),
            _buildOptionButton(
              iconPath: "assets/icons/update_icon.svg",
              label: "복제하기",
              onTap: () async {
                await ClothesRepository().addClothes(clothes);
                onReload();
                Navigator.pop(context);
              },
            ),
            _buildOptionButton(
              iconPath: "assets/icons/delete_icon.svg",
              label: "삭제하기",
              onTap: () async {
                await ClothesRepository().removeClothes(clothes);
                onReload();
                Navigator.pop(context);
              },
            ),
          ]),
    );
  }
}

Widget _buildOptionButton({
  required String iconPath,
  required String label,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 17, bottom: 17),
    child: GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 20,
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: OneLineTextStyles.Bold14.copyWith(
                color: label == "삭제하기"
                    ? SystemColors.caution
                    : SystemColors.black),
          ),
        ],
      ),
    ),
  );
}
