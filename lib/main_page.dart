import 'package:flutter/material.dart';
import 'package:ttal_kkak/closet_repository.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_grid.dart';
import 'package:ttal_kkak/clothes_repository.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Clothes> clothesList = [];
  late String closetName = "내 옷장";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Clothes> loadedClothes = await ClothesRepository().loadClothes();
      String? loadedClosetName = await ClosetRepository().loadClosetName();
      setState(() {
        clothesList = loadedClothes;
        if (loadedClosetName != null) closetName = loadedClosetName;
      });
    });
  }

  void _showSaveClosetNameBottomSheet(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: closetName);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter some text',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  setState(() {
                    closetName = value; // 입력된 텍스트를 저장합니다.
                    ClosetRepository().saveClosetName(value);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
          title: Text(
            closetName,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                _showSaveClosetNameBottomSheet(context);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    TabBar(
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
                    TabBar(
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
                    )
                  ],
                )),
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
