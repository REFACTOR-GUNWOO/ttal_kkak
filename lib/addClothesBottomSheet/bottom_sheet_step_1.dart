import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/utils/length_limited_text_input.dart';

class BottomSheetBody1 extends StatefulWidget implements BottomSheetStep {
  const BottomSheetBody1(
      {super.key,
      required this.onNextStep,
      required this.updateProvider,
      required this.isUpdate});
  final VoidCallback onNextStep;
  final ClothesUpdateProvider updateProvider;
  final isUpdate;
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
    _controller.text = widget.updateProvider.currentClothes?.name ?? "";
  }

  void _handleTextChanged(String newText) {}

  void _onSubmit(String text) async {
    Clothes? clothes = widget.updateProvider.currentClothes;
    if (clothes == null) {
      SecondCategory secondCategory =
          secondCategories.firstWhere((e) => e.firstCategoryId == 1);
      ClothesDetails clothesDetails = ClothesDetails(
          details: secondCategory.details.map((e) => e.defaultDetail).toList());
      clothes = Clothes(
        name: text,
        primaryCategoryId: 1,
        secondaryCategoryId: secondCategory.id,
        color: ClothesColor.Black,
        details: clothesDetails,
        price: 0,
        drawLines: [],
        regTs: DateTime.now(),
        isDraft: true,
      );
      Clothes saved = await (ClothesRepository().addClothes(clothes));
      widget.updateProvider.set(saved);
      Provider.of<ReloadHomeProvider>(context, listen: false).triggerReload();
    } else {
      clothes.updateName(text);
    }
    await widget.updateProvider.update(clothes);
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
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
