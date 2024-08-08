import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ttal_kkak/utils/length_limited_text_input.dart';
import 'styles/text_styles.dart';
import 'styles/colors_styles.dart';

void ShowAddClothesBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return StepContainer();
      });
}

class StepContainer extends StatefulWidget {
  @override
  _StepContainerState createState() => _StepContainerState();
}

class _StepContainerState extends State<StepContainer> {
  int _currentStep = 0;

  void _nextStep() {
    print("_nextStep:${_currentStep}");

    setState(() {
      _currentStep++;
    });
    print("_nextStep:${_currentStep}");
  }

  void _previousStep() {
    print("_previousStep:${_currentStep}");

    setState(() {
      _currentStep--;
    });
    print("_previousStep:${_currentStep}");
  }

  List<Widget> _buildSteps() {
    return [
      BottomSheetBody1(),
      BottomSheetBody2(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BottomSheetHandle(),
          BottomSheetAppBar(
            nextStep: _nextStep,
            previousStep: _previousStep,
            isLast: _currentStep == _buildSteps().length - 1,
            isStart: _currentStep == 0,
          ),
          _buildSteps()[_currentStep],
        ],
      ),
    );
  }
}

class BottomSheetBody1 extends StatefulWidget {
  @override
  _BottomSheetBody1State createState() => _BottomSheetBody1State();
}

class _BottomSheetBody1State extends State<BottomSheetBody1> {
  String _childText = '';

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();
  }

  void _handleTextChanged(String newText) {
    print(_childText);
    setState(() {
      _childText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: LengthLimitedTextInput(8, "메모를 입력해주세요.",
            "옷을 잘 구분할 수 있는 옷 이름으로 등록해주세요.", _handleTextChanged));
  }
}

class BottomSheetBody2 extends StatefulWidget {
  @override
  _BottomSheetBody2State createState() => _BottomSheetBody2State();
}

class _BottomSheetBody2State extends State<BottomSheetBody2> {
  String _childText = '';

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();
  }

  void _handleTextChanged(String newText) {
    print(_childText);
    setState(() {
      _childText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: LengthLimitedTextInput(8, "메모를 입력해주세요.2",
            "옷을 잘 구분할 수 있는 옷 이름으로 등록해주세요.", _handleTextChanged));
  }
}

class BottomSheetAppBar extends StatelessWidget {
  final VoidCallback nextStep;
  final VoidCallback previousStep;
  final bool isStart;
  final bool isLast;
  const BottomSheetAppBar({
    super.key,
    required this.nextStep,
    required this.previousStep,
    required this.isStart,
    required this.isLast,
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
              child: TextButton(
                child: isStart
                    ? Container()
                    : Text(
                        '이전',
                        style: OneLineTextStyles.Bold16.copyWith(
                            color: SystemColors.black),
                      ),
                onPressed: previousStep,
              ),
              flex: 2,
            ),
            Expanded(
                child: Text(
                  '등록할 옷 이름',
                  textAlign: TextAlign.center,
                  style: OneLineTextStyles.Bold16.copyWith(
                      color: SystemColors.black),
                ),
                flex: 2),
            Expanded(
                child: isLast
                    ? SizedBox()
                    : TextButton(
                        child: Text(
                          '다음',
                          style: OneLineTextStyles.Bold16.copyWith(
                              color: SystemColors.black),
                        ),
                        onPressed: nextStep),
                flex: 2),
          ],
        ));
  }
}

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: SignatureColors.begie600,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
