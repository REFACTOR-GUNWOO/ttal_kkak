import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/utils/length_limited_text_input.dart';

class BottomSheetBody1 extends StatefulWidget implements BottomSheetStep {
  const BottomSheetBody1(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.draftProvider,
      required this.updateProvider});
  final VoidCallback onNextStep;
  final bool isUpdate;
  final ClothesDraftProvider draftProvider;
  final ClothesUpdateProvider updateProvider;

  @override
  _BottomSheetBody1State createState() => _BottomSheetBody1State();

  @override
  String getTitle() {
    return "이름";
  }
}

class _BottomSheetBody1State extends State<BottomSheetBody1> {
  late TextEditingController _controller;
  // late ClothesDraftProvider provider;

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();
    _controller = TextEditingController();
    if (widget.isUpdate) {
      _controller.text = widget.updateProvider.currentClothes?.name ?? "";
    } else {
      _controller.text = widget.draftProvider.currentDraft?.name ?? "";
    }
  }

  void _handleTextChanged(String newText) {}

  void _onSubmit(String text) async {
    if (widget.isUpdate) {
      final clothes = widget.updateProvider.currentClothes!;
      clothes.updateName(text);
      await widget.updateProvider.update(clothes);
    } else {
      print("_onSubmit");
      ClothesDraft? draft = widget.draftProvider.currentDraft;
      if (draft == null) {
        widget.draftProvider.updateDraft(ClothesDraft(name: text));
        return;
      }
      draft.name = text;
      await widget.draftProvider.updateDraft(ClothesDraft(name: text));
    }
    widget.onNextStep();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          // physics: ClampingScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: LengthLimitedTextInput(
                8,
                "옷 이름을 입력해주세요.",
                "옷을 잘 구분할 수 있는 옷 이름으로 등록해주세요.",
                _handleTextChanged,
                _onSubmit,
                controller: _controller,
              )),
        ));
  }
}
