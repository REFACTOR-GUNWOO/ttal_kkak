import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';

class MainPage extends StatelessWidget {
  final List<Clothes> clothesList = generateDummyClothes();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // 탭의 개수를 설정
      child: Scaffold(
        appBar: AppBar(
          title: Text('아경 옷장', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                // Edit action
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.purple,
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: '전체 20'),
              Tab(text: '상의 4'),
              Tab(text: '하의 4'),
              Tab(text: '아우터 2'),
              Tab(text: '원피스 1'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ClothesGrid(clothesList: clothesList),
            ClothesGrid(
                clothesList: clothesList
                    .where((clothes) => clothes.primaryCategory == '상의')
                    .toList()),
            ClothesGrid(
                clothesList: clothesList
                    .where((clothes) => clothes.primaryCategory == '하의')
                    .toList()),
            ClothesGrid(
                clothesList: clothesList
                    .where((clothes) => clothes.primaryCategory == '아우터')
                    .toList()),
            ClothesGrid(
                clothesList: clothesList
                    .where((clothes) => clothes.primaryCategory == '원피스')
                    .toList()),
          ],
        ),
      ),
    );
  }
}

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
