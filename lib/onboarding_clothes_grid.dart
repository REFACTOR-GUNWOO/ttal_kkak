import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/main_page.dart';
import 'package:ttal_kkak/utils/custom_floating_action_button_location.dart';

class OnboardingClothesGrid extends StatefulWidget {
  final List<Clothes> clothesList;
  OnboardingClothesGrid({required this.clothesList});

  @override
  _OnboardingClothesGridState createState() => _OnboardingClothesGridState();
}

class _OnboardingClothesGridState extends State<OnboardingClothesGrid> {
  late List<Clothes> clothesList;
  late Map<int, bool> selected;
  @override
  void initState() {
    super.initState();
    clothesList = widget.clothesList;
    // 선택 상태를 초기화
    selected = {for (var clothes in clothesList) clothes.id: false};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: (clothesList.length / 4).ceil(),
        itemBuilder: (context, index) {
          int start = index * 4;
          int end =
              (start + 4) < clothesList.length ? start + 4 : clothesList.length;
          List<Clothes> rowClothes = clothesList.sublist(start, end);

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowClothes
                  .asMap()
                  .entries
                  .map((clothes) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selected[clothes.value.id] =
                              !selected[clothes.value.id]!;
                        });
                      },
                      child: _buildClothesCard(
                          clothes.value, selected[clothes.value.id] ?? false)))
                  .toList(),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.endFloat, // 기본 위치를 기준으로
        offsetX: -20.0, // X축 위치를 오른쪽으로 이동
      ),
    );
  }

  Widget _buildClothesCard(Clothes clothes, bool isSelected) {
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
            if (isSelected)
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

  Widget _buildFloatingActionButton() {
    int selectedCount =
        selected.values.where((isSelected) => isSelected).length;
    return FloatingActionButton.extended(
      onPressed: () async {
        print("_buildFloatingActionButton : $selected");
        var selectedIds = selected.entries
            .where(
              (it) => it.value == true,
            )
            .map(
              (it) => it.key,
            );
        await ClothesRepository().addClothesList(selectedIds
            .map((it) => clothesList.firstWhere(
                  (e) => e.id == it,
                ))
            .toSet());
        // 플로팅 버튼 클릭 시의 동작
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      },
      backgroundColor: Colors.black,
      label: Text(
        '총 $selectedCount개 선택',
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(Icons.arrow_forward, color: Colors.white),
    );
  }
}
