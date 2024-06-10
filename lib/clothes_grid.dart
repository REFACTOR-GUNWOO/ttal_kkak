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
