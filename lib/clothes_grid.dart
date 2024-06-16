import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';

class ClothesGrid extends StatelessWidget {
  final List<Clothes> clothesList;

  ClothesGrid({required this.clothesList});

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
                .map((clothes) => _buildClothesCard(clothes))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildClothesCard(Clothes clothes) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: clothes.color,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        SizedBox(height: 8.0),
        Text(clothes.name, style: TextStyle(fontSize: 12)),
      ],
    );
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
