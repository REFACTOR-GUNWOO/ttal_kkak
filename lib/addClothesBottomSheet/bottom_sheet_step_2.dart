import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/draft_clear_warning_dialog.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody2 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody2(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesUpdateProvider updateProvider;

  @override
  _BottomSheetBody2State createState() => _BottomSheetBody2State();

  @override
  String getTitle() {
    return "상위 카테고리";
  }

  @override
  bool Function() get canGoNext => () => true;
}

class _BottomSheetBody2State extends State<BottomSheetBody2> {
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _calculateMaxHeight();
      Clothes? clothes = widget.updateProvider.currentClothes;
      int? primaryCategoryId = clothes?.primaryCategoryId;
      setState(() {
        selectedCategoryId = primaryCategoryId;
      });
      FirstCategory category = firstCategories
          .firstWhere((element) => element.id == primaryCategoryId);
      LogService().log(
          LogType.view_screen,
          "main_category_registration_page",
          null,
          {"type": category.code, "isUpdate": widget.isUpdate.toString()});
    });
  }

  void save(int categoryId) async {
    final clothes = widget.updateProvider.currentClothes;
    if (clothes == null) {
      return;
    }
    print("update : ${clothes.name}");

    if (widget.isUpdate) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DraftClearWarningDialog(
            draftFieldName: "상위 카테고리",
            draft: clothes,
            onNextStep: () {
              clothes.updatePrimaryCategoryId(categoryId);
              widget.onNextStep();
            },
          );
        },
      );
    } else {
      clothes.updatePrimaryCategoryId(categoryId);
      await widget.updateProvider.update(clothes);
      widget.onNextStep();
    }
    if (clothes.isDraft) {
      clothes.updatePrimaryCategoryId(categoryId);
      clothes.isDraft = false;
      await widget.updateProvider.update(clothes);
    }
    return;
  }

  double _maxItemHeight = 0;
  final List<GlobalKey> _itemKeys = [];

  void _calculateMaxHeight() {
    double maxHeight = 0;
    for (var key in _itemKeys) {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        maxHeight = maxHeight > renderBox.size.height
            ? maxHeight
            : renderBox.size.height;
      }
    }

    if (maxHeight > 0 && maxHeight != _maxItemHeight) {
      setState(() {
        _maxItemHeight = maxHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          print("maxWidth: $maxWidth"); // 부모 패딩이 적용된 최대 너비 확인

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(firstCategories.length, (index) {
              if (_itemKeys.length < firstCategories.length) {
                _itemKeys.add(GlobalKey());
              }

              return SizedBox(
                width: (maxWidth - 10) / 2, // 한 줄에 2개 고정
                height: _maxItemHeight > 0 ? _maxItemHeight : null,
                child: IntrinsicHeight(
                  key: _itemKeys[index],
                  child: GestureDetector(
                    onTap: () async => save(firstCategories[index].id),
                    child: Container(
                      decoration: BoxDecoration(
                        border: selectedCategoryId == firstCategories[index].id
                            ? Border.all(color: SystemColors.black, width: 1.5)
                            : Border.all(
                                color: SystemColors.gray500, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              firstCategories[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Flexible(
                              child: Text(
                                firstCategories[index].description,
                                style: TextStyle(
                                    height: 1.5,
                                    fontSize: 12,
                                    color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
