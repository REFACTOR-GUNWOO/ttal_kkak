import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';

// Start of Selection
class BottomSheetBody5 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody5(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesUpdateProvider updateProvider;
  @override
  bool Function() get canGoNext => () => true;

  @override
  _ColorSelectionGridState createState() => _ColorSelectionGridState();

  @override
  String getTitle() {
    return "컬러";
  }
}

class _ColorSelectionGridState extends State<BottomSheetBody5> {
  ClothesColor _selectedColor = ClothesColor.white;
  List<ClothesColor> _selectedColorGroup = [];

  @override
  void initState() {
    super.initState();

    Clothes? clothes = widget.updateProvider.currentClothes;
    setState(() {
      ClothesColor? color = clothes?.color;
      if (color != null) {
        _selectedColor = color;
        _selectedColorGroup = colorContainers
                .where((element) => element.colors.contains(color))
                .firstOrNull
                ?.colors ??
            colorContainers.first.colors;
      }
    });

    LogService().log(LogType.view_screen, "color_registration_page", null, {
      "main_color": colorContainers
              .where((element) => element.colors.contains(clothes?.color))
              .firstOrNull
              ?.representativeColor
              .name ??
          "색상 없음",
      "sub_color": clothes?.color.name ?? "색상 없음",
      "isUpdate": widget.isUpdate.toString()
    });
  }

  void save() async {
    final clothes = widget.updateProvider.currentClothes!;
    clothes.updateColor(_selectedColor);
    await widget.updateProvider.update(clothes);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: ColorPalette(
      colorContainers: colorContainers,
      selectedColorGroup: _selectedColorGroup,
      selectedColor: _selectedColor,
      isDrawingPage: false,
      onColorSelected: (selectedColorGroup, selectedColor) {
        setState(() {
          _selectedColorGroup = selectedColorGroup;
          _selectedColor = selectedColor;
          save();
        });
      },
    ));
  }
}

class ColorPalette extends StatefulWidget {
  final List<ColorContainer> colorContainers;
  final List<ClothesColor> selectedColorGroup;
  final ClothesColor selectedColor;
  final bool isDrawingPage;
  final Function(List<ClothesColor>, ClothesColor) onColorSelected;

  const ColorPalette({
    Key? key,
    required this.colorContainers,
    required this.selectedColorGroup,
    required this.selectedColor,
    required this.onColorSelected,
    required this.isDrawingPage,
  }) : super(key: key);

  @override
  _ColorPaletteState createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  late ClothesColor? _selectedColor;
  late List<ClothesColor>? _selectedColorGroup;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
    _selectedColorGroup = widget.selectedColorGroup;
  }

  _onSelected(
      List<ClothesColor> selectedColorGroup, ClothesColor selectedColor) {
    setState(() {
      _selectedColorGroup = selectedColorGroup;
      _selectedColor = selectedColor;
    });
    widget.onColorSelected(selectedColorGroup, selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    print("ColorPalette build :${widget.selectedColorGroup}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ColorPaletteItem(
          colorContainers: widget.colorContainers,
          selectedColorGroup: _selectedColorGroup ?? widget.selectedColorGroup,
          selectedColor: _selectedColor ?? widget.selectedColor,
          onColorSelected: _onSelected,
        ),
        const SizedBox(height: 32),
        if (widget.selectedColorGroup.isNotEmpty)
          ColorPaletteItem(
              colorContainers: (_selectedColorGroup ??
                      widget.selectedColorGroup)
                  .map((color) => ColorContainer(
                      _selectedColorGroup ?? widget.selectedColorGroup, color))
                  .toList(),
              selectedColorGroup:
                  _selectedColorGroup ?? widget.selectedColorGroup,
              selectedColor: _selectedColor ?? widget.selectedColor,
              onColorSelected: _onSelected),
      ],
    );
  }
}

class ColorPaletteItem extends StatelessWidget {
  final List<ColorContainer> colorContainers;
  final List<ClothesColor> selectedColorGroup;
  final ClothesColor selectedColor;
  final Function(List<ClothesColor>, ClothesColor) onColorSelected;

  const ColorPaletteItem({
    Key? key,
    required this.colorContainers,
    required this.selectedColorGroup,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8, // 한 줄에 8개의 색상
        crossAxisSpacing: 10.0, // 색상 간의 수평 간격
        mainAxisSpacing: 10.0, // 색상 간의 수직 간격
        childAspectRatio: 1, // 정사각형 비율
      ),
      itemCount: colorContainers.length,
      itemBuilder: (context, index) {
        ClothesColor color = colorContainers[index].representativeColor;
        bool isSelected = color == selectedColor;
        return GestureDetector(
          onTap: () {
            onColorSelected(colorContainers[index].colors, color);
          },
          child: Container(
            decoration: BoxDecoration(
              color: color.color,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        );
      },
    );
  }
}
