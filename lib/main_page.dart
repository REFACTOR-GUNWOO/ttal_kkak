import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/Category.dart';
import 'package:ttal_kkak/closet_repository.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';
import 'package:ttal_kkak/clothes_grid.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late List<Clothes> clothesList = [];
  late ClothesGrid clothesGrid;
  late String closetName = "내 옷장";
  late int tab1Index = 0;
  late int tab2Index = 0;
  // ClothesDraftProvider? provider;
  List<String> secondTabNames = ["등록일순", "카테고리순", "컬러순"];

  void reload() async {
    // 먼저 비동기 작업을 완료한 후에
    List<Clothes> updatedClothesList = await ClothesRepository().loadClothes();

    // 그 다음에 setState를 호출하여 상태를 갱신합니다
    setState(() {
      print("reload");
      clothesList = updatedClothesList;
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
        : getCategorizedClothes()[category]?.length ?? 0;

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
    List<TextButton> tabList = firstCategories.map((category) {
      return getTab(firstCategories.indexOf(category) + 1, false, category);
    }).toList();
    tabList.insert(0, allTab);
    return tabList;
  }

  ClothesGrid getClothesGrid() {
    if (tab1Index == 0)
      return ClothesGrid(
        clothesList: sortClothesList(clothesList),
        isOnboarding: false,
        onReload: reload,
      );

    List<Clothes>? clothes =
        getCategorizedClothes()[firstCategories[tab1Index - 1]];
    return clothes != null
        ? ClothesGrid(
            clothesList: sortClothesList(clothes),
            isOnboarding: false,
            onReload: reload,
          )
        : ClothesGrid(
            clothesList: [],
            isOnboarding: false,
            onReload: reload,
          );
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
        FirstCategory firstCategoryA = firstCategories
            .firstWhere((category) => category.id == a.primaryCategoryId);
        FirstCategory firstCategoryB = firstCategories
            .firstWhere((category) => category.id == b.primaryCategoryId);

        int primaryComparison =
            firstCategoryA.priority.compareTo(firstCategoryB.priority);
        if (primaryComparison != 0) {
          return primaryComparison;
        }

        // 2. secondaryCategory 정렬 (priority 기준)
        SecondCategory secondCategoryA = secondCategories
            .firstWhere((category) => category.id == a.secondaryCategoryId);
        SecondCategory secondCategoryB = secondCategories
            .firstWhere((category) => category.id == b.secondaryCategoryId);

        int secondaryComparison =
            secondCategoryA.priority.compareTo(secondCategoryB.priority);
        if (secondaryComparison != 0) {
          return secondaryComparison;
        }

        // 3. categoryDetail 정렬
        List<ClothesDetail> detailsA = a.details.details;
        List<ClothesDetail> detailsB = b.details.details;

        // 각 디테일을 priority 순으로 비교
        for (int i = 0; i < secondCategoryA.details.length; i++) {
          CategoryDetail detailToCompare = secondCategoryA.details[i];
          ClothesDetail detailA = detailsA
              .firstWhere((detail) => detailToCompare.details.contains(detail));
          ClothesDetail detailB = detailsB
              .firstWhere((detail) => detailToCompare.details.contains(detail));

          int detailComparison = detailA.priority.compareTo(detailB.priority);
          if (detailComparison != 0) {
            return detailComparison;
          }
        }
        return 0;
      });

      return copied;
    }

    if (secondTabNames[tab2Index] == "컬러순") {
      List<Color> sortedColors = colorContainers
          .map((e) => e.colors)
          .toList()
          .expand((element) => element)
          .toList();
      copied.sort((a, b) {
        return sortedColors
            .indexOf(a.color)
            .compareTo(sortedColors.indexOf(b.color));
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

    Provider.of<ClothesDraftProvider>(context, listen: false).loadFromLocal();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Clothes> loadedClothes = await ClothesRepository().loadClothes();
      String? loadedClosetName = await ClosetRepository().loadClosetName();
      ClothesDraft? clothesDraft = await ClothesDraftRepository().load();
      setState(() {
        clothesList = loadedClothes;
        clothesDraft = clothesDraft;
        if (loadedClosetName != null) closetName = loadedClosetName;
      });
    });
  }

  @override
  void dispose() {
    // _outerTabController.dispose();
    // _innerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카테고리별로 옷 데이터를 그룹화

    return Consumer<ReloadHomeProvider>(
        builder: (context, reloadNotifier, child) {
      if (reloadNotifier.shouldReload) {  // ReloadHomeProvider에 boolean 필드 추가 필요
        WidgetsBinding.instance.addPostFrameCallback((_) {
          reload();
          // 리로드 후 상태 리셋
          reloadNotifier.resetReload();
        });
      }
      return Scaffold(
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
                preferredSize: Size.fromHeight(90.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // 이 줄을 추가합니다
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getTabs(),
                        )),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // 이 줄을 추가합니다
                          children: getSecondTabs(),
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        )),
                  ],
                ),
              ),
              elevation: 0),
          body: getClothesGrid());
    });
  }
}
