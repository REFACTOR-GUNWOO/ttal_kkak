import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody5 extends StatefulWidget implements BottomSheetStep {
  @override
  _ColorSelectionGridState createState() => _ColorSelectionGridState();

  @override
  String getTitle() {
    return "옷 컬러";
  }
}

class _ColorSelectionGridState extends State<BottomSheetBody5> {
  Color _selectedColor = Colors.transparent;

  final List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.grey,
    Colors.red[300]!,
    Colors.orange[300]!,
    Colors.yellow[300]!,
    Colors.green[300]!,
    Colors.blue[300]!,
    Colors.purple[300]!,
    Colors.pink[300]!,
    Colors.brown[300]!,
    Colors.grey[200]!,
    Colors.grey[300]!,
    Colors.grey[400]!,
    Colors.grey[500]!,
    Colors.grey[600]!,
    Colors.grey[700]!,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // 한 줄에 8개의 색상
          crossAxisSpacing: 10.0, // 색상 간의 수평 간격
          mainAxisSpacing: 10.0, // 색상 간의 수직 간격
          childAspectRatio: 1, // 정사각형 비율
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          Color color = colors[index];
          bool isSelected = color == _selectedColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
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
    );
  }
}