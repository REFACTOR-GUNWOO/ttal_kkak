import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/common_bottom_sheet.dart';
import 'package:ttal_kkak/common/show_toast.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/provider/scroll_controller_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class UpdateBottomSheet extends StatelessWidget {
  Clothes clothes;
  ClothesUpdateProvider? updateProvider;
  final VoidCallback onReload;

  UpdateBottomSheet(
      {required this.clothes,
      required this.updateProvider,
      required this.onReload});
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
                final scrollProvider = Provider.of<ScrollControllerProvider>(
                    context,
                    listen: false);
                Navigator.pop(context);
                scrollProvider.scrollToTop(
                  MediaQuery.of(context).viewPadding.top,
                ); // 드래프트 초기화

                // 정보 수정 기능
                updateProvider!.set(clothes);
                Provider.of<ReloadHomeProvider>(context, listen: false)
                    .triggerReload();

                ShowAddClothesBottomSheet(context, true, () async {
                  updateProvider?.clear();
                  onReload();
                  scrollProvider.scrollToBeforeOffset();
                });
              },
            ),
            _buildOptionButton(
              iconPath: "assets/icons/clone_clothes.svg",
              label: "복제하기",
              onTap: () async {
                showToast("옷이 복제 되었습니다.");
                await ClothesRepository().addClothes(clothes);
                onReload();
                Navigator.pop(context);
              },
            ),
            _buildOptionButton(
              iconPath: "assets/icons/delete_icon.svg",
              label: "삭제하기",
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  barrierColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  builder: (BuildContext context) {
                    return DeleteConfirmationDialog(
                      itemName: clothes.name,
                      onConfirm: () async {
                        // 삭제 로직 추가
                        showToast("옷이 삭제 되었습니다.");
                        await ClothesRepository().removeClothes(clothes);
                        onReload();
                        Navigator.pop(context);
                      },
                    );
                  },
                );
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
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque, // 빈 영역에서도 터치 인식
    child: Padding(
      padding: const EdgeInsets.only(top: 17, bottom: 17),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
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

class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    Key? key,
    required this.itemName,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Text(
            '$itemName 삭제',
            style: BodyTextStyles.Bold24,
          ),
          const SizedBox(height: 10),
          const Text(
            '옷 삭제 시 복구가 어려워요.\n삭제하시겠어요?',
            textAlign: TextAlign.center,
            style: BodyTextStyles.Regular14,
          ),
          const SizedBox(height: 20),
          Padding(
            child: TextButton(
              onPressed: onConfirm,
              style: TextButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/delete_icon.svg",
                        height: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "삭제하기",
                        style: OneLineTextStyles.SemiBold16.copyWith(
                            color: SystemColors.caution),
                      ),
                    ],
                  )),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
