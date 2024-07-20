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

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late List<Clothes> clothesList = [];
  late String closetName = "내 옷장";
  late int tab1Index = 0;
  late int tab2Index = 0;
  late TabController _outerTabController;
  late TabController _innerTabController;
  List<String> secondTabNames = ["등록일순", "카테고리순", "컬러순", "가격순"];

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

  Map<FirstCategory, List<Clothes>> getCategorizedClothes() {
    Map<FirstCategory, List<Clothes>> categorizedClothes = {};
    clothesList.forEach((clothes) {
      FirstCategory category = firstCategories
          .firstWhere((element) => element.id == clothes.primaryCategoryId);

      if (!categorizedClothes.containsKey(category)) {
        categorizedClothes[category] = [];
      }
      categorizedClothes[category]!.add(clothes);
    });
    return categorizedClothes;
  }

  List<FirstCategory> getSortedCategories() {
    List<FirstCategory> categories = getCategorizedClothes().keys.toList();

    categories.sort((a, b) => a.priority.compareTo(b.priority));
    return categories;
  }

  TextButton getTab(int index, bool isAllTab, FirstCategory? category) {
    int itemCount = isAllTab
        ? clothesList.length
        : getCategorizedClothes()[category]!.length;

    String categoryName = isAllTab
        ? "전체"
        : category?.name != null
            ? category!.name
            : "";

    return tab1Index == index
        ? TextButton(
            onPressed: () {
              setState(() {
                tab1Index = index;
              });
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('$categoryName',
                  style: OneLineTextStyles.Bold14.copyWith(
                      color: SystemColors.black)),
              Text(' $itemCount',
                  style: OneLineTextStyles.Bold14.copyWith(
                      color: SignatureColors.orange400))
            ]))
        : TextButton(
            onPressed: () {
              setState(() {
                tab1Index = index;
              });
            },
            child: Text('$categoryName $itemCount',
                style: OneLineTextStyles.Medium14.copyWith(
                    color: SystemColors.gray700)));
  }

  List<TextButton> getTabs() {
    TextButton allTab = getTab(0, true, null);
    List<TextButton> tabList = getSortedCategories().map((category) {
      return getTab(
          getSortedCategories().indexOf(category) + 1, false, category);
    }).toList();
    tabList.insert(0, allTab);
    return tabList;
  }

  ClothesGrid getClothesGrid() {
    return tab1Index == 0
        ? ClothesGrid(clothesList: sortClothesList(clothesList))
        : ClothesGrid(
            clothesList: sortClothesList(getCategorizedClothes()[
                getSortedCategories()[tab1Index - 1]]!));
  }

  List<Clothes> sortClothesList(List<Clothes> clothesList) {
    List<Clothes> copied = clothesList;

    if (secondTabNames[tab2Index] == "등록일순") {
      copied.sort((a, b) {
        return a.regTs.microsecondsSinceEpoch
            .compareTo(b.regTs.microsecondsSinceEpoch);
      });

      return copied;
    }

    if (secondTabNames[tab2Index] == "카테고리순") {
      copied.sort((a, b) {
        return secondCategories
            .firstWhere((element) => element.id == a.secondaryCategoryId)
            .priority
            .compareTo(secondCategories
                .firstWhere((element) => element.id == b.secondaryCategoryId)
                .priority);
      });

      return copied;
    }

    if (secondTabNames[tab2Index] == "컬러순") {
      copied.sort((a, b) {
        return HSLColor.fromColor(a.color)
            .hue
            .compareTo(HSLColor.fromColor(b.color).hue);
      });

      return copied;
    }

    if (secondTabNames[tab2Index] == "가격순") {
      copied.sort((a, b) {
        return (a.price ?? 0).compareTo(b.price ?? 0);
      });

      return copied;
    }

    return copied;
  }

  TextButton getSecondTab(int index, String tabName) {
    return TextButton(
        onPressed: () {
          setState(() {
            tab2Index = index;
          });
        },
        child: tab2Index == index
            ? Text('$tabName',
                style: OneLineTextStyles.Bold14.copyWith(
                    color: SystemColors.black))
            : Text('$tabName',
                style: OneLineTextStyles.Medium14.copyWith(
                    color: SystemColors.gray700)));
  }

  List<TextButton> getSecondTabs() {
    return secondTabNames
        .map(
            (tabName) => getSecondTab(secondTabNames.indexOf(tabName), tabName))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    print("_outerTabController: ${getCategorizedClothes().length}");
    print(getSecondTabs().length);
    _outerTabController = TabController(length: getTabs().length, vsync: this);
    _innerTabController =
        TabController(length: getSecondTabs().length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Clothes> loadedClothes = await ClothesRepository().loadClothes();
      String? loadedClosetName = await ClosetRepository().loadClosetName();
      setState(() {
        clothesList = loadedClothes;
        if (loadedClosetName != null) closetName = loadedClosetName;
      });
    });
  }

  @override
  void dispose() {
    _outerTabController.dispose();
    _innerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카테고리별로 옷 데이터를 그룹화

    return Scaffold(
        backgroundColor: SignatureColors.begie200,
        appBar: AppBar(
            backgroundColor: SignatureColors.begie200,
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              preferredSize: Size.fromHeight(60.0),
              child: Column(
                children: [
                  Row(
                    children: getTabs(),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  Row(
                    children: getSecondTabs(),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ],
              ),
            ),
            elevation: 0),
        body: getClothesGrid());
  }
}
