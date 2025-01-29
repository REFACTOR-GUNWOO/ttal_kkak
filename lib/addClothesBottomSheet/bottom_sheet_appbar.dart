import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes.dart';
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

  @override
  Widget build(BuildContext context) {
    Clothes? clothes =
        Provider.of<ClothesUpdateProvider>(context).currentClothes;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 48, // 일반적인 앱바 높이
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: Text(
                  currentStep.getTitle(),
                  textAlign: TextAlign.center,
                  style: OneLineTextStyles.SemiBold16.copyWith(
                      color: SystemColors.black),
                )),
            Expanded(
                flex: 2,
                child: nextStep == null
                    ? isUpdate
                        ? Container()
                        : TextButton(
                            onPressed: () async {
                              // Provider.of<ReloadHomeProvider>(context,
                              //         listen: false)
                              //     .triggerReload();
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("등록",
                                    style: OneLineTextStyles.Medium14.copyWith(
                                        color: SystemColors.black)),
                                SizedBox(width: 7),
                                SvgPicture.asset(
                                  'assets/icons/arrow_right.svg',
                                  color: SystemColors.black,
                                  height: 12,
                                ),
                              ],
                            ))
                    : TextButton(
                        onPressed: clothes != null ? nextStepFun : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              nextStep!.getTitle(),
                              style: OneLineTextStyles.Medium14.copyWith(
                                  color: clothes != null
                                      ? SystemColors.black
                                      : SystemColors.gray500),
                            ),
                            SizedBox(width: 7),
                            SvgPicture.asset('assets/icons/arrow_right.svg',
                                height: 12,
                                color: clothes != null
                                    ? SystemColors.black
                                    : SystemColors.gray500),
                          ],
                        ))),
          ],
        ));
  }
}
