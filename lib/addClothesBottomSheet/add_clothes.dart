import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_appbar.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_1.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_2.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_3.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_4.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_5.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_6.dart';
import 'package:ttal_kkak/common/common_bottom_sheet.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';

void ShowAddClothesBottomSheet(
    BuildContext context, bool isUpdate, VoidCallback whenComplete) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(children: [
          StepContainer(
            isUpdate: isUpdate,
          )
        ]);
      }).whenComplete(() {
    whenComplete();
  });
}

class StepContainer extends StatefulWidget {
  const StepContainer({super.key, required this.isUpdate});

  @override
  _StepContainerState createState() => _StepContainerState();
  final bool isUpdate;
}

class _StepContainerState extends State<StepContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // provider = Provider.of<ClothesDraftProvider>(context, listen: false);
    // provider?.loadFromLocal();
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
      BottomSheetBody1(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody2(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody3(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody4(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody5(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody6(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      )
    ];
  }

  // int getCurrentDraftLevel() {
  //   print("getCurrentDraftLevel : ${provider?.currentDraft?.countLevel()}");
  //   return provider?.currentDraft?.countLevel() ?? 0;
  // }

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      child: Column(
        children: [
          BottomSheetAppBar(
              // currentDraftLevel: widget.isUpdate ? 100 : getCurrentDraftLevel(),
              nextStepFun: _nextStep,
              previousStepFun: _previousStep,
              nextStep: _currentStep == _buildSteps().length - 1
                  ? null
                  : _buildSteps()[_currentStep + 1],
              previousStep:
                  _currentStep == 0 ? null : _buildSteps()[_currentStep - 1],
              currentStep: _buildSteps()[_currentStep],
              currentStepCount: _currentStep,
              
              isUpdate: widget.isUpdate),
          Padding(
            child: _buildSteps()[_currentStep] as Widget,
            padding: EdgeInsets.all(20),
          ),
        ],
      ),
    );
  }
}
