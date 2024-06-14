import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';

class OnboardingClothesGrid extends StatefulWidget {
  final List<Clothes> clothesList;
  OnboardingClothesGrid({required this.clothesList});

  @override
  _OnboardingClothesGridState createState() => _OnboardingClothesGridState();
}

class _OnboardingClothesGridState extends State<OnboardingClothesGrid> {
  List<bool> selected = List.generate(10, (_) => false);
  late List<Clothes> clothesList;

  @override
  void initState() {
    super.initState();
    // 초기 상태를 인자로 받은 값으로 설정합니다.
    clothesList = widget.clothesList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: (clothesList.length / 4).ceil(),
      itemBuilder: (context, index) {
        int start = index * 4;
        int end =
            (start + 4) < clothesList.length ? start + 4 : clothesList.length;
        List<Clothes> rowClothes = clothesList.sublist(start, end);

        return GestureDetector(
            onTap: () {
              setState(() {
                selected[index] = !selected[index];
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rowClothes
                    .map((clothes) => _buildClothesCard(clothes, index))
                    .toList(),
              ),
            ));
      },
    );
  }

  Widget _buildClothesCard(Clothes clothes, int index) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: clothes.color,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            if (selected[index])
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
          ],
        ),
        SizedBox(height: 8.0),
        Text(clothes.name, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
