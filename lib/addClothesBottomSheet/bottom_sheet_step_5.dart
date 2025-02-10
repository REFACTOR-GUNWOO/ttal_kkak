import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes.dart';
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
  _ColorSelectionGridState createState() => _ColorSelectionGridState();

  @override
  String getTitle() {
    return "컬러";
  }
}

class _ColorSelectionGridState extends State<BottomSheetBody5> {
  Color _selectedColor = Colors.transparent;
  List<Color> _selectedColorGroup = [];

  @override
  void initState() {
    super.initState();

    Clothes? clothes = widget.updateProvider.currentClothes;
    setState(() {
      Color? color = clothes?.color;
      if (color != null) {
        _selectedColor = color;
        _selectedColorGroup = colorContainers
                .where((element) => element.colors.contains(color))
                .firstOrNull
                ?.colors ??
            colorContainers.first.colors;
      }
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
  final List<Color> selectedColorGroup;
  final Color selectedColor;
  final Function(List<Color>, Color) onColorSelected;

  const ColorPalette({
    Key? key,
    required this.colorContainers,
    required this.selectedColorGroup,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  _ColorPaletteState createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  late Color? _selectedColor;
  late List<Color>? _selectedColorGroup;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
    _selectedColorGroup = widget.selectedColorGroup;
  }

  _onSelected(List<Color> selectedColorGroup, Color selectedColor) {
    setState(() {
      _selectedColorGroup = selectedColorGroup;
      _selectedColor = selectedColor;
    });
    widget.onColorSelected(selectedColorGroup, selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    print("ColorPalette build :${widget.selectedColorGroup}");
    return SingleChildScrollView(
      child: Column(
        children: [
          ColorPaletteItem(
            colorContainers: widget.colorContainers,
            selectedColorGroup:
                _selectedColorGroup ?? widget.selectedColorGroup,
            selectedColor: _selectedColor ?? widget.selectedColor,
            onColorSelected: _onSelected,
          ),
          const SizedBox(height: 20),
          if (widget.selectedColorGroup.isNotEmpty)
            ColorPaletteItem(
                colorContainers:
                    (_selectedColorGroup ?? widget.selectedColorGroup)
                        .map((color) => ColorContainer(
                            _selectedColorGroup ?? widget.selectedColorGroup,
                            color))
                        .toList(),
                selectedColorGroup:
                    _selectedColorGroup ?? widget.selectedColorGroup,
                selectedColor: _selectedColor ?? widget.selectedColor,
                onColorSelected: _onSelected),
        ],
      ),
    );
  }
}

class ColorPaletteItem extends StatelessWidget {
  final List<ColorContainer> colorContainers;
  final List<Color> selectedColorGroup;
  final Color selectedColor;
  final Function(List<Color>, Color) onColorSelected;

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
        bool isSelected = color == selectedColor;
        return GestureDetector(
          onTap: () {
            onColorSelected(colorContainers[index].colors, color);
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
    );
  }
}
