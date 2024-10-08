import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';

import 'package:flutter/material.dart';

class BottomSheetBody5 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody5(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.draftProvider,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesDraftProvider draftProvider;
  final ClothesUpdateProvider updateProvider;

  @override
  _ColorSelectionGridState createState() => _ColorSelectionGridState();

  @override
  String getTitle() {
    return "옷 컬러";
  }
}

class _ColorSelectionGridState extends State<BottomSheetBody5> {
  Color _selectedColor = Colors.transparent;
  List<Color> _selectedColorGroup = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ClothesDraft? draft = widget.draftProvider.currentDraft;
      Clothes? clothes = widget.updateProvider.currentClothes;
      setState(() {
        Color? color = widget.isUpdate ? clothes?.color : draft?.color;
        if (color != null) {
          _selectedColor = color;
          _selectedColorGroup = colorContainers
              .firstWhere((element) => element.colors.contains(color))
              .colors;
        }
      });
    });
  }

  void save() async {
    if (widget.isUpdate) {
      final clothes = widget.updateProvider.currentClothes!;
      clothes.updateColor(_selectedColor);
      await widget.updateProvider.update(clothes);
      return;
    } else {
      ClothesDraft? draft = widget.draftProvider.currentDraft;
      if (draft != null) {
        draft.color = _selectedColor;
        await widget.draftProvider.updateDraft(draft);
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // 한 줄에 8개의 색상
              crossAxisSpacing: 10.0, // 색상 간의 수평 간격
              mainAxisSpacing: 10.0, // 색상 간의 수직 간격
              childAspectRatio: 1, // 정사각형 비율
            ),
            itemCount: colorContainers.length,
            itemBuilder: (context, index) {
              Color color = colorContainers[index].representativeColor;
              bool isSelected = _selectedColorGroup.contains(color);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColorGroup = colorContainers[index].colors;
                    _selectedColor = color;
                    save();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          if (_selectedColorGroup.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8, // 한 줄에 8개의 색상
                crossAxisSpacing: 10.0, // 색상 간의 수평 간격
                mainAxisSpacing: 10.0, // 색상 간의 수직 간격
                childAspectRatio: 1, // 정사각형 비율
              ),
              itemCount: _selectedColorGroup.length,
              itemBuilder: (context, index) {
                Color color = _selectedColorGroup[index];
                bool isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                      save();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}