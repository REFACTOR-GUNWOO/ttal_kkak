import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/common/show_toast.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetAppBar extends StatelessWidget {
  final VoidCallback nextStepFun;
  final VoidCallback previousStepFun;
  final BottomSheetStep? nextStep;
  final BottomSheetStep? previousStep;
  final BottomSheetStep currentStep;
  final int currentStepCount;
  final bool isUpdate;
  const BottomSheetAppBar({
    super.key,
    required this.nextStepFun,
    required this.previousStepFun,
    this.nextStep,
    this.previousStep,
    required this.isUpdate,
    required this.currentStep,
    required this.currentStepCount,
  });

  bool isInactiveStep(Clothes? clothes) {
    print("currentStepCount : $currentStepCount");
    print("clothesName : ${clothes?.name.isEmpty}}");

    return (clothes?.isDraft ?? true) == true &&
        ((currentStepCount == 0 && (clothes?.name.isEmpty ?? true) == true) ||
            currentStepCount == 1);
  }

  @override
  Widget build(BuildContext context) {
    Clothes? clothes =
        Provider.of<ClothesUpdateProvider>(context).currentClothes;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          color: SignatureColors.begie300,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 48, // 일반적인 앱바 높이
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: previousStep == null
                    ? Container()
                    : TextButton(
                        onPressed: previousStepFun,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/arrow_left.svg',
                              color: SystemColors.black,
                              height: 12,
                            ),
                            SizedBox(width: 7),
                            Text(
                              previousStep!.getTitle(),
                              style: OneLineTextStyles.Medium14.copyWith(
                                  color: SystemColors.black),
                            ),
                          ],
                        ),
                      ),
              ),
              Expanded(
                  flex: 2,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${currentStepCount + 1}',
                          style: OneLineTextStyles.SemiBold16.copyWith(
                              color: SignatureColors.orange400),
                        ),
                        TextSpan(
                            text: '/6',
                            style: OneLineTextStyles.SemiBold16.copyWith(
                                color: SystemColors.black)),
                      ],
                    ),
                  )

                  //  Text(
                  //   "${currentStepCount+1}/${}",
                  //   textAlign: TextAlign.center,
                  //   style: OneLineTextStyles.SemiBold16.copyWith(
                  //       color: SystemColors.black),
                  // )

                  ),
              Expanded(
                  flex: 2,
                  child: nextStep == null
                      ? TextButton(
                          onPressed: () async {
                            Provider.of<ClothesUpdateProvider>(context,
                                    listen: false)
                                .clear();
                            LogService().log(LogType.click_button,
                                "clothes_registration_page", "save_button", {
                              "isUpdate": isUpdate.toString(),
                              "button_position": "bottom"
                            });
                            showToast(isUpdate ? "수정되었습니다" : "등록되었습니다");

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MainLayout()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("완료",
                                  style: OneLineTextStyles.Medium14.copyWith(
                                      color: SignatureColors.orange400)),
                              SizedBox(width: 7),
                              SvgPicture.asset(
                                'assets/icons/arrow_right.svg',
                                color: SignatureColors.orange400,
                                height: 12,
                              ),
                            ],
                          ))
                      : TextButton(
                          onPressed:
                              !isInactiveStep(clothes) ? nextStepFun : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                nextStep!.getTitle(),
                                style: OneLineTextStyles.Medium14.copyWith(
                                    color: !isInactiveStep(clothes)
                                        ? SystemColors.black
                                        : SystemColors.gray500),
                              ),
                              SizedBox(width: 7),
                              SvgPicture.asset('assets/icons/arrow_right.svg',
                                  height: 12,
                                  color: !isInactiveStep(clothes)
                                      ? SystemColors.black
                                      : SystemColors.gray500),
                            ],
                          ))),
            ],
          )),
      Container(
        height: MediaQuery.of(context).padding.bottom,
        color: SignatureColors.begie300,
      )
    ]);
  }
}
