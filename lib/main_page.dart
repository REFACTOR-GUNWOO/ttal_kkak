import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ttal_kkak/Category.dart';
import 'package:ttal_kkak/closet_repository.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_grid.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Clothes> clothesList = [];
  late String closetName = "내 옷장";
  late int tab1Index = 0;
  late int tab2Index = 0;

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
                keyboardType: TextInputType.text,
                controller: _controller,
                decoration: const InputDecoration(
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
    Map<FirstCategory, List<Clothes>> categorizedClothes = {};
    clothesList.forEach((clothes) {
      FirstCategory category = firstCategories
          .firstWhere((element) => element.id == clothes.primaryCategoryId);

      if (!categorizedClothes.containsKey(category)) {
        categorizedClothes[category] = [];
      }
      categorizedClothes[category]!.add(clothes);
    });

    List<FirstCategory> getSortedCategories() {
      List<FirstCategory> categories = categorizedClothes.keys.toList();

      categories.sort((a, b) => a.priority.compareTo(b.priority));
      return categories;
    }

    ;

    Tab getTab(bool isSelected, bool isAllTab, FirstCategory? category) {
      int itemCount =
          isAllTab ? clothesList.length : categorizedClothes[category]!.length;

      String categoryName = isAllTab
          ? "전체"
          : category?.name != null
              ? category!.name
              : "";

      return Tab(
          child: isSelected
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('$categoryName',
                      style: OneLineTextStyles.Bold14.copyWith(
                          color: SystemColors.black)),
                  Text(' $itemCount',
                      style: OneLineTextStyles.Bold14.copyWith(
                          color: SignatureColors.orange400))
                ])
              : Text('$categoryName $itemCount',
                  style: OneLineTextStyles.Medium14.copyWith(
                      color: SystemColors.gray700)));
    }

    List<Tab> getTabs() {
      Tab allTab = getTab(tab1Index == 0, true, null);
      List<Tab> tabList = getSortedCategories().map((category) {
        bool isSelected =
            getSortedCategories().indexOf(category) == tab1Index - 1;
        return getTab(isSelected, false, category);
      }).toList();
      tabList.insert(0, allTab);
      return tabList;
    }

    List<ClothesGrid> getTabBarViews() {
      ClothesGrid allTabView = ClothesGrid(clothesList: clothesList);

      List<ClothesGrid> allTabViews = getSortedCategories().map((category) {
        List<Clothes> clothesToShow = categorizedClothes[category]!;
        return ClothesGrid(clothesList: clothesToShow);
      }).toList();

      allTabViews.insert(0, allTabView);
      return allTabViews;
    }

    return DefaultTabController(
      length: getSortedCategories().length + 1,
      child: Scaffold(
          backgroundColor: SignatureColors.begie200,
          appBar: AppBar(
              backgroundColor: SignatureColors.begie200,
              title:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  closetName,
                  textAlign: TextAlign.center,
                  style: OneLineTextStyles.Bold18.copyWith(
                      color: SystemColors.black),
                ),
                IconButton(
                  padding: null,
                  icon: SvgPicture.asset(
                    'assets/icons/closet_title_update_button.svg',
                    width: 16, // 원하는 크기로 설정할 수 있습니다.
                    height: 16, // 원하는 크기로 설정할 수 있습니다.
                  ),
                  onPressed: () {
                    _showSaveClosetNameBottomSheet(context);
                  },
                ),
              ]),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(30.0),
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.purple,
                      indicator: BoxDecoration(),
                      isScrollable: true,
                      unselectedLabelColor: Colors.black,
                      onTap: (value) {
                        setState(() {
                          tab1Index = value;
                        });
                      },
                      tabs: getTabs(),
                    ),
                  ],
                ),
              ),
              elevation: 0),
          body: tab1Index == 0
              ? ClothesGrid(clothesList: clothesList)
              : ClothesGrid(
                  clothesList: categorizedClothes[
                      getSortedCategories()[tab1Index - 1]]!)),
    );
  }
}
