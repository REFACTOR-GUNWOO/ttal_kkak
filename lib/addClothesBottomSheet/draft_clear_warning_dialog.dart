import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class DraftClearWarningDialog extends StatelessWidget {
  final String draftFieldName;
  final String? title;
  final String? description;
  final Clothes? draft;
  final VoidCallback onNextStep;
  DraftClearWarningDialog(
      {required this.draftFieldName,
      this.draft,
      required this.onNextStep,
      this.title,
      this.description});
  void clear(BuildContext context) async {
    onNextStep();
    if (draft != null) {
      ClothesUpdateProvider provider =
          Provider.of<ClothesUpdateProvider>(context, listen: false);

      await ClothesRepository().updateClothes(draft!);
      await provider.update(draft!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Text(
                title ?? '${draftFieldName} 변경',
                style:
                    BodyTextStyles.Bold20.copyWith(color: SystemColors.black),
              ),
              SizedBox(height: 8),
              Text(
                description ?? '하위 정보가 사라져요.\n${draftFieldName}를 변경하시겠어요?',
                textAlign: TextAlign.center,
                style: BodyTextStyles.Regular14.copyWith(
                    color: SystemColors.black),
              ),
              SizedBox(height: 24),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 32),
                  child: SizedBox(
                      width: double.infinity, // 부모 위젯의 최대 크기만큼 늘리기
                      child: ElevatedButton(
                        onPressed: () {
                          // 버튼 클릭 시 동작할 코드를 여기에 작성
                          clear(context);
                          Navigator.of(context).pop(); // 모달 닫기
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // 버튼 색상
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          '변경',
                          style: OneLineTextStyles.SemiBold16.copyWith(
                              color: SystemColors.white),
                        ),
                      ))),
            ],
          ),
          Positioned(
              child: GestureDetector(
                child: SvgPicture.asset(
                  "assets/icons/clear_icon.svg",
                  color: SystemColors.gray700,
                  width: 24,
                  height: 24,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              right: 16,
              top: 16)
        ]));
  }
}
