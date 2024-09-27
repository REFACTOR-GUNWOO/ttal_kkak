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

  List<ColorContainer> colorContainers = [
    // 검정색
    ColorContainer([Color(0xFF282828), Color(0xFF161616)], Color(0xFF161616)),
    // 흰색
    ColorContainer([Color(0xFFFFFFFF), Color(0xFFE7E7E7)], Color(0xFFE7E7E7)),
    // 회색
    ColorContainer([Color(0xFFC4C4C4), Color(0xFF8D8D8D), Color(0xFF606060)],
        Color(0xFF8D8D8D)),
    // 빨간색
    ColorContainer([Color(0xFFDE9494), Color(0xFFC46060), Color(0xFFA84A4A)],
        Color(0xFFC46060)),
    // 주황색
    ColorContainer([Color(0xFFE4B198), Color(0xFFD48E6A), Color(0xFFA76443)],
        Color(0xFFD48E6A)),
    // 주황색#2
    ColorContainer([Color(0xFFF0E3A3), Color(0xFFE4D58B), Color(0xFFC4A151)],
        Color(0xFFE4D58B)),
    // 초록색
    ColorContainer([Color(0xFFB6D9A1), Color(0xFF68A168), Color(0xFF467346)],
        Color(0xFF68A168)),
    // 초록색#2
    ColorContainer([Color(0xFF9FB294), Color(0xFF627762), Color(0xFF3D513D)],
        Color(0xFF627762)),
    // 파란색
    ColorContainer([Color(0xFFADCAD8), Color(0xFF5C8DBD), Color(0xFF304F85)],
        Color(0xFF5C8DBD)),
    // 파란색#2
    ColorContainer([Color(0xFF8095A9), Color(0xFF43617F), Color(0xFF32485D)],
        Color(0xFF43617F)),
    // 보라색
    ColorContainer([Color(0xFFB9A8DB), Color(0xFF957CC8), Color(0xFF5C4588)],
        Color(0xFF957CC8)),
    // 쿨핑크
    ColorContainer([Color(0xFFD8B9D8), Color(0xFFAC6BAC), Color(0xFFA04D89)],
        Color(0xFFAC6BAC)),
    // 웜핑크
    ColorContainer([Color(0xFFE1B5C2), Color(0xFFBE7187), Color(0xFFA04D65)],
        Color(0xFFBE7187)),
  ];

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

class ColorContainer {
  final List<Color> colors;
  final Color representativeColor;

  ColorContainer(this.colors, this.representativeColor);
}
