import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetAppBar extends StatelessWidget {
  final VoidCallback nextStepFun;
  final VoidCallback previousStepFun;
  final BottomSheetStep? nextStep;
  final BottomSheetStep? previousStep;
  final BottomSheetStep currentStep;
  const BottomSheetAppBar({
    super.key,
    required this.nextStepFun,
    required this.previousStepFun,
    this.nextStep,
    this.previousStep,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 48, // 일반적인 앱바 높이
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: previousStep == null
                  ? Container()
                  : TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/icons/arrow_left.svg'),
                          Text(
                            previousStep!.getTitle(),
                            style: OneLineTextStyles.Medium14.copyWith(
                                color: SystemColors.gray700),
                          ),
                        ],
                      ),
                      onPressed: previousStepFun,
                    ),
              flex: 2,
            ),
            Expanded(
                child: Text(
                  currentStep.getTitle(),
                  textAlign: TextAlign.center,
                  style: OneLineTextStyles.SemiBold16.copyWith(
                      color: SystemColors.black),
                ),
                flex: 2),
            Expanded(
                child: nextStep == null
                    ? Container()
                    : TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              nextStep!.getTitle(),
                              style: OneLineTextStyles.Medium14.copyWith(
                                  color: SystemColors.gray700),
                            ),
                            SvgPicture.asset('assets/icons/arrow_right.svg'),
                          ],
                        ),
                        onPressed: nextStepFun),
                flex: 2),
          ],
        ));
  }
}
