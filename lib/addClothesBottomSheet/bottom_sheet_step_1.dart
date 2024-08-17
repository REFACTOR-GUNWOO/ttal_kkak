import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';
import 'package:ttal_kkak/utils/length_limited_text_input.dart';

class BottomSheetBody1 extends StatefulWidget implements BottomSheetStep {
  const BottomSheetBody1({super.key});

  @override
  _BottomSheetBody1State createState() => _BottomSheetBody1State();

  @override
  String getTitle() {
    return "옷 이름";
  }
}

class _BottomSheetBody1State extends State<BottomSheetBody1> {
  late TextEditingController _controller;

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();
    _controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ClothesDraft? draft = await ClothesDraftRepository().load();
      String? name = draft?.name;

      print("initState : ${name}");

      if (name != null) {
        _controller.text = name;
      }
    });
  }

  void _handleTextChanged(String newText) {
    // print(_childText);
    // setState(() {
    //   _childText = newText;
    // });
  }

  void _onSubmit(String text) async {
    print("_onSubmit");
    ClothesDraft? draft = await ClothesDraftRepository().load();
    if (draft == null) {
      ClothesDraftRepository().save(ClothesDraft(name: text));
      return;
    }
    draft.name = text;
    ClothesDraftRepository().save(draft);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LengthLimitedTextInput(
            8,
            "메모를 입력해주세요.",
            "옷을 잘 구분할 수 있는 옷 이름으로 등록해주세요.",
            _handleTextChanged,
            _onSubmit,
            controller: _controller,
          )),
    );
  }
}
