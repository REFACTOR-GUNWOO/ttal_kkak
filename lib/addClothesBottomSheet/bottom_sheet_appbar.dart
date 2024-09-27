import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetAppBar extends StatelessWidget {
  final VoidCallback nextStepFun;
  final VoidCallback previousStepFun;
  final BottomSheetStep? nextStep;
  final BottomSheetStep? previousStep;
  final BottomSheetStep currentStep;
  final int currentDraftLevel;
  final int currentStepCount;
  const BottomSheetAppBar({
    super.key,
    required this.nextStepFun,
    required this.previousStepFun,
    this.nextStep,
    this.previousStep,
    required this.currentStep,
    required this.currentDraftLevel,
    required this.currentStepCount,
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
                          ),
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
                    ? TextButton(
                        onPressed: () async {
                          ClothesDraft? draft =
                              await ClothesDraftRepository().load();
                          if (draft != null) {
                            draft.drawLines = [];
                            ClothesDraftRepository().save(draft);
                            ClothesRepository().addClothes(draft.toClotehs());
                            ClothesDraftRepository().delete();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "등록",
                              style: OneLineTextStyles.Medium14.copyWith(
                                  color: SystemColors.black),
                            ),
                            SvgPicture.asset('assets/icons/arrow_right.svg',
                                color: SystemColors.black),
                          ],
                        ))
                    : TextButton(
                        onPressed: currentStepCount < currentDraftLevel
                            ? nextStepFun
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              nextStep!.getTitle(),
                              style: OneLineTextStyles.Medium14.copyWith(
                                  color: currentStepCount < currentDraftLevel
                                      ? SystemColors.black
                                      : SystemColors.gray500),
                            ),
                            SvgPicture.asset(
                              'assets/icons/arrow_right.svg',
                              color: currentStepCount < currentDraftLevel
                                  ? SystemColors.black
                                  : SystemColors.gray500,
                            ),
                          ],
                        ))),
          ],
        ));
  }
}
