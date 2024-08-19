import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody3 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody3({super.key, required this.onNextStep});

  @override
  _BottomSheetBody3State createState() => _BottomSheetBody3State();

  @override
  String getTitle() {
    return "옷 카테고리";
  }
}

class _BottomSheetBody3State extends State<BottomSheetBody3> {
  String _childText = '';

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();
  }

  void _handleTextChanged(String newText) {
    print(_childText);
    setState(() {
      _childText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 1200, child: CategoryScreen());
  }
}

class CategoryScreen extends StatelessWidget {
  final List<String> categories =
      List.generate(8, (index) => '상의'); // 8개의 "상의" 항목 생성

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 한 행에 두 개의 아이템
        crossAxisSpacing: 6.0, // 수평 간격
        mainAxisSpacing: 6.0, // 수직 간격
        childAspectRatio: 4, // 아이템의 가로세로 비율
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: SystemColors.gray500), // 테두리 색상
            borderRadius: BorderRadius.circular(6.0), // 모서리 둥글게
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categories[index],
                  style: OneLineTextStyles.SemiBold16.copyWith(
                      color: SystemColors.black),
                ),
                Icon(
                  Icons.checkroom,
                  color: Colors.black,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
