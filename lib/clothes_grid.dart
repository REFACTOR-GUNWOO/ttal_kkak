import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class ClothesGrid extends StatelessWidget {
  final List<Clothes> clothesList;

  ClothesGrid({required this.clothesList});
  static const int columnCount = 4;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: (clothesList.length / columnCount).ceil(),
      itemBuilder: (context, index) {
        int start = index * columnCount;
        int end = (start + columnCount) < clothesList.length
            ? start + columnCount
            : clothesList.length;
        List<Clothes> rowClothes = clothesList.sublist(start, end);

        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildClothesCardRow(context, rowClothes)),
        );
      },
    );
  }

  List<Widget> _buildClothesCardRow(
      BuildContext context, List<Clothes> rowClothes) {
    List<Widget> list = rowClothes
        .map((clothes) => _buildClothesCard(context, clothes))
        .toList();
    int listDiff = columnCount - list.length;

    for (int i = 0; i < listDiff; i++) {
      list.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    }

    list.insert(0, SvgPicture.asset("assets/icons/LeftCloset.svg"));
    list.add(SvgPicture.asset("assets/icons/RightCloset.svg"));
    return list;
  }

  Widget _buildClothesCard(BuildContext context, Clothes clothes) {
    return GestureDetector(
        onTap: () => {showClothesOptionsBottomSheet(context, clothes)},
        child: Column(children: [
          Stack(children: [
            SvgPicture.asset("assets/icons/MiddleCloset.svg"),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: clothes.color,
                borderRadius: BorderRadius.circular(8.0),
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
