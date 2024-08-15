import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody2 extends StatefulWidget implements BottomSheetStep {
  @override
  _BottomSheetBody2State createState() => _BottomSheetBody2State();

  @override
  String getTitle() {
    return "옷 카테고리";
  }
}

class _BottomSheetBody2State extends State<BottomSheetBody2> {
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
  final List<Map<String, String>> categories = [
    {'title': '상의', 'description': '티셔츠 블라우스, 니트, 조끼 등의 옷이 있어요.'},
    {'title': '하의', 'description': '청바지, 슬랙스, 반바지, 레깅스 등의 옷이 있어요.'},
    {'title': '아우터', 'description': '야상, 가디건, 자켓 코트, 패딩 등의 옷이 있어요.'},
    {'title': '원피스', 'description': '원피스, 점프슈트 등의 옷이 있어요.'},
    {'title': '신발', 'description': '슬리퍼, 운동화, 구두 등의 옷이 있어요.'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 3 / 2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return TextButton(
            onPressed: () => {},
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category['title']!,
                      style: OneLineTextStyles.SemiBold16.copyWith(
                          color: SystemColors.black),
                    ),
                    SizedBox(height: 8.0),
                    Text(category['description']!,
                        style: BodyTextStyles.Medium12.copyWith(
                            color: SystemColors.gray700)),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
