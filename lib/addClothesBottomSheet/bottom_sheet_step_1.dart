import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/utils/length_limited_text_input.dart';

class BottomSheetBody1 extends StatefulWidget implements BottomSheetStep {
  @override
  _BottomSheetBody1State createState() => _BottomSheetBody1State();

  @override
  String getTitle() {
    return "옷 이름";
  }
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

