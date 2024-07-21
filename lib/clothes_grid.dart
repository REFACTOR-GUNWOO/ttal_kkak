import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/utils/custom_floating_action_button_location.dart';

class ClothesGrid extends StatefulWidget {
  final List<Clothes> clothesList;
  final bool isOnboarding;

  ClothesGrid({required this.clothesList, required this.isOnboarding});

  @override
  _ClothesGridState createState() => _ClothesGridState();
}

class _ClothesGridState extends State<ClothesGrid> {
  late Map<int, bool> selected;
  static const int columnCount = 4;

  Widget _buildFloatingActionButton() {
    int selectedCount =
        selected.values.where((isSelected) => isSelected).length;
    return FloatingActionButton.extended(
      onPressed: () async {
        var selectedIds = selected.entries
            .where(
              (it) => it.value == true,
            )
            .map(
              (it) => it.key,
            );
        await ClothesRepository().addClothesList(selectedIds
            .map((it) => widget.clothesList.firstWhere(
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

  @override
  void initState() {
    super.initState();
    // 선택 상태를 초기화
    selected = {for (var clothes in widget.clothesList) clothes.id: false};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(8.0),
        itemCount: (widget.clothesList.length / columnCount).ceil(),
        itemBuilder: (context, index) {
          int start = index * columnCount;
          int end = (start + columnCount) < widget.clothesList.length
              ? start + columnCount
              : widget.clothesList.length;
          List<Clothes> rowClothes = widget.clothesList.sublist(start, end);

          return Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildClothesCardRow(context, rowClothes)),
          );
        },
      ),
      floatingActionButton:
          widget.isOnboarding ? _buildFloatingActionButton() : null,
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.endFloat, // 기본 위치를 기준으로
        offsetX: -20.0, // X축 위치를 오른쪽으로 이동
      ),
    );
  }

  List<Widget> _buildClothesCardRow(
      BuildContext context, List<Clothes> rowClothes) {
    List<Widget> list = rowClothes
        .map((clothes) =>
            _buildClothesCard(context, clothes, selected[clothes.id] ?? false))
        .toList();
    int listDiff = columnCount - list.length;

    for (int i = 0; i < listDiff; i++) {
      list.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    }

    list.insert(0, SvgPicture.asset("assets/icons/LeftCloset.svg"));
    list.add(SvgPicture.asset("assets/icons/RightCloset.svg"));
    return list;
  }

  Widget _buildClothesCard(
      BuildContext context, Clothes clothes, bool isSelected) {
    return GestureDetector(
        onTap: () => {
              widget.isOnboarding
                  ? setState(() {
                      selected[clothes.id] = !selected[clothes.id]!;
                    })
                  : showClothesOptionsBottomSheet(context, clothes)
            },
        child: Column(children: [
          Stack(alignment: Alignment.center, children: [
            SvgPicture.asset("assets/icons/MiddleCloset.svg"),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset("assets/icons/hanger.svg"))),
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
          ]),
          SizedBox(
            height: 8,
          ),
          Text(clothes.name,
              style: OneLineTextStyles.SemiBold10.copyWith(
                  color: SystemColors.gray800)),
          SizedBox(
            height: 8,
          ),
        ]));
  }
}

void showClothesOptionsBottomSheet(BuildContext context, Clothes clothes) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text('정보 수정하기'),
              onTap: () {
                // 정보 수정 기능
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('메모 남기기'),
              onTap: () {
                // 메모 남기기 기능
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('좋아하는 옷 OFF'),
              onTap: () {
                // 좋아하는 옷 기능
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('삭제하기', style: TextStyle(color: Colors.red)),
              onTap: () {
                // 삭제 기능
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
