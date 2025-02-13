import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/draft_clear_warning_dialog.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
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
    _itemKeys
        .addAll(List.generate(firstCategories.length, (index) => GlobalKey()));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _calculateMaxHeight();
      Clothes? clothes = widget.updateProvider.currentClothes;
      int? primaryCategoryId = clothes?.primaryCategoryId;
      setState(() {
        selectedCategoryId = primaryCategoryId;
      });
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
      print("update2 : ${clothes.id}");
      print("update2 : ${clothes.name}");
      print("update2 : ${clothes.primaryCategoryId}");
      print("update2 : ${clothes.secondaryCategoryId}");
      print("update2 : ${clothes.details}");
      await widget.updateProvider.update(clothes);
      widget.onNextStep();
    }
    if (clothes.isDraft) {
      clothes.updatePrimaryCategoryId(categoryId);
      print("draft");
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
      print("renderBox width: ${renderBox?.size.width}");
      print("renderBox height: ${renderBox?.size.height}");
      if (renderBox != null) {
        maxHeight = maxHeight > renderBox.size.height
            ? maxHeight
            : renderBox.size.height;
      }
    }

    print("maxHeight: ${maxHeight}");
    if (maxHeight > 0 && maxHeight != _maxItemHeight) {
      setState(() {
        _maxItemHeight = maxHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(builder: (context, constraints) {
      double availableWidth = constraints.crossAxisExtent;
      int crossAxisCount = 2; // 무조건 2개 유지
      double maxItemWidth = availableWidth / crossAxisCount;

      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio:
              maxItemWidth / (_maxItemHeight > 0 ? _maxItemHeight : 100),
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = firstCategories[index];

            return IntrinsicHeight(
              key: _itemKeys[index], // 각 아이템별 높이 추적
              child: GestureDetector(
                  onTap: () async => save(category.id),
                  child: Container(
                    decoration: BoxDecoration(
                      border: selectedCategoryId == category.id
                          ? Border.all(color: Colors.black, width: 1.5)
                          : Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          SizedBox(height: 6.0),
                          Flexible(
                              child: Text(
                            category.description,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          )),
                        ],
                      ),
                    ),
                  )),
            );
          },
          childCount: firstCategories.length,
        ),
      );
    });
  }
}
