import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_appbar.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_handle.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_1.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_2.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_3.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_4.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_5.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_6.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/utils/length_limited_text_input.dart';
import '../styles/text_styles.dart';
import '../styles/colors_styles.dart';

void ShowAddClothesBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(children: [StepContainer()]);
      });
}

class StepContainer extends StatefulWidget {
  @override
  _StepContainerState createState() => _StepContainerState();
}

class _StepContainerState extends State<StepContainer> {
  ClothesDraftProvider? provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 여기서 Provider에 접근
    setState(() {
      provider = Provider.of<ClothesDraftProvider>(context);
    });
  }

  int _currentStep = 0;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  List<BottomSheetStep> _buildSteps() {
    return [
      BottomSheetBody1(onNextStep: _nextStep),
      BottomSheetBody2(onNextStep: _nextStep),
      BottomSheetBody3(onNextStep: _nextStep),
      BottomSheetBody4(onNextStep: _nextStep),
      BottomSheetBody5(onNextStep: _nextStep),
      BottomSheetBody6(onNextStep: _nextStep)
    ];
  }

  int getCurrentDraftLevel() {
    print("getCurrentDraftLevel : ${provider?.currentDraft?.countLevel()}");
    return provider?.currentDraft?.countLevel() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BottomSheetHandle(),
          BottomSheetAppBar(
              currentDraftLevel: getCurrentDraftLevel(),
              nextStepFun: _nextStep,
              previousStepFun: _previousStep,
              nextStep: _currentStep == _buildSteps().length - 1
                  ? null
                  : _buildSteps()[_currentStep + 1],
              previousStep:
                  _currentStep == 0 ? null : _buildSteps()[_currentStep - 1],
              currentStep: _buildSteps()[_currentStep],
              currentStepCount: _currentStep),
          _buildSteps()[_currentStep] as Widget,
        ],
      ),
    );
  }
}
