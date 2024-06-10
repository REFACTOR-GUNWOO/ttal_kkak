import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_grid.dart';

class MainPage extends StatelessWidget {
  final List<Clothes> clothesList = generateDummyClothes();

  @override
  Widget build(BuildContext context) {
    // 카테고리별로 옷 데이터를 그룹화
    Map<String, List<Clothes>> categorizedClothes = {};
    clothesList.forEach((clothes) {
      if (!categorizedClothes.containsKey(clothes.primaryCategory)) {
        categorizedClothes[clothes.primaryCategory] = [];
      }
      categorizedClothes[clothes.primaryCategory]!.add(clothes);
    });

    List<String> categories = categorizedClothes.keys.toList();
    categories.insert(0, '전체'); // '전체' 탭 추가

    return DefaultTabController(
      length: categories.length,
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Colors.purple,
                isScrollable: true,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.black,
                tabs: categories.map((category) {
                  int itemCount = category == '전체'
                      ? clothesList.length
                      : categorizedClothes[category]!.length;
                  return Tab(text: '$category $itemCount');
                }).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: categories.map((category) {
            List<Clothes> clothesToShow =
                category == '전체' ? clothesList : categorizedClothes[category]!;
            return ClothesGrid(clothesList: clothesToShow);
          }).toList(),
        ),
      ),
    );
  }
}
