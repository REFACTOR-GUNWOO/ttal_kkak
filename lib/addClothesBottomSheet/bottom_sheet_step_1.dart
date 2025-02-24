import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/utils/length_limited_text_input.dart';

class BottomSheetBody1 extends StatefulWidget implements BottomSheetStep {
  BottomSheetBody1({
    super.key,
    required this.onNextStep,
    required this.updateProvider,
    required this.isUpdate,
  });
  final VoidCallback onNextStep;
  final ClothesUpdateProvider updateProvider;
  final bool isUpdate;
  final GlobalKey<_BottomSheetBody1State> myKey = GlobalKey();

  @override
  bool Function() get canGoNext => () {
        return myKey.currentState != null &&
            myKey.currentState!._controller.text.isNotEmpty;
      };

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
    super.initState();
    LogService().log(LogType.view_screen, "name_registration_page", null,
        {"isUpdate": widget.isUpdate.toString()});

    _controller = TextEditingController();
    _controller.text = widget.updateProvider.currentClothes?.name ?? "";
  }

  void _handleTextChanged(String text) async {
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
        color: ClothesColor.white,
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
  }

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
        color: ClothesColor.white,
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
    return SliverToBoxAdapter(
        child: GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
