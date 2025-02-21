import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/Category.dart';
import 'package:ttal_kkak/closet_repository.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_grid.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/models/sort_type.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/provider/scroll_controller_provider.dart';
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
  List<SortType> secondTabs = [
    SortType.regTs,
    SortType.category,
    SortType.color,
  ];

  void reload() async {
    try {
      // 먼저 비동기 작업을 완료한 후에
      print("reload1");
      List<Clothes> updatedClothesList =
          await ClothesRepository().loadClothes();

      // 그 다음에 setState를 호출하여 상태를 갱신합니다
      setState(() {
        print("reload2");
        clothesList = updatedClothesList;
      });
    } catch (e) {
      print(e);
    }
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

  Widget getTab(int index, bool isAllTab, FirstCategory? category) {
    int itemCount = isAllTab
        ? clothesList.length
        : getCategorizedClothes()[category]?.length ?? 0;

    String categoryName = isAllTab
        ? "전체"
        : category?.name != null
            ? category!.name
            : "";

    String categoryEnglishName = isAllTab
        ? "all"
        : category?.code != null
            ? category!.code
            : "";
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: tab1Index == index
            ? TextButton(
                onPressed: () {
                  onPressTabButton(index, categoryEnglishName);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.all(10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
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
                  onPressTabButton(index, categoryEnglishName);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.all(10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('$categoryName $itemCount',
                    style: OneLineTextStyles.Medium14.copyWith(
                        color: SystemColors.gray700))));
  }

  void onPressTabButton(int index, String categoryName) {
    setState(() {
      tab1Index = index;
      LogService().log(LogType.click_button, "main_page",
          "category_filter_button", {"item_category": categoryName});
    });
  }

  List<Widget> getTabs() {
    Widget allTab = getTab(0, true, null);
    List<Widget> tabList = firstCategories.map((category) {
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

  int compareClothesListByCategory(Clothes a, Clothes b) {
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
      print(detailToCompare);
      print(detailsA);
      print(detailsB);
      ClothesDetail detailA = detailsA
          .firstWhere((detail) => detailToCompare.details.contains(detail));
      ClothesDetail detailB = detailsB
          .firstWhere((detail) => detailToCompare.details.contains(detail));
      int detailAIndex = detailToCompare.details.indexOf(detailA);
      int detailBIndex = detailToCompare.details.indexOf(detailB);

      int detailComparison = detailAIndex.compareTo(detailBIndex);
      if (detailComparison != 0) {
        return detailComparison;
      }
    }
    return 0;
  }

  List<Clothes> sortClothesList(List<Clothes> clothesList) {
    List<Clothes> copied = clothesList;

    if (secondTabs[tab2Index] == SortType.regTs) {
      copied.sort((a, b) {
        return b.regTs.microsecondsSinceEpoch
            .compareTo(a.regTs.microsecondsSinceEpoch);
      });
    }

    if (secondTabs[tab2Index] == SortType.category) {
      copied.sort((a, b) {
        return compareClothesListByCategory(a, b);
      });
    }

    if (secondTabs[tab2Index] == SortType.color) {
      List<Color> sortedColors = colorContainers
          .map((e) => e.colors)
          .toList()
          .expand((element) => element)
          .toList();
      copied.sort((a, b) {
        int compareResult = sortedColors
            .indexOf(a.color)
            .compareTo(sortedColors.indexOf(b.color));
        if (compareResult == 0)
          return compareClothesListByCategory(a, b);
        else
          return compareResult;
      });
    }

    print("sorted clothes first  : ${copied.firstOrNull?.name}");
    return copied;
  }

  TextButton getSecondTab(int index, SortType tab) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.all(10),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          onPressSecondTabButton(index, tab);
        },
        child: tab2Index == index
            ? Text(tab.label,
                style: OneLineTextStyles.Bold14.copyWith(
                    color: SystemColors.black))
            : Text(tab.label,
                style: OneLineTextStyles.Medium14.copyWith(
                    color: SystemColors.gray700)));
  }

  void onPressSecondTabButton(int index, SortType sortType) {
    setState(() {
      tab2Index = index;
      LogService().log(LogType.click_button, "main_page", "sort_button",
          {"sort_type": sortType.code});
    });
  }

  List<TextButton> getSecondTabs() {
    return secondTabs
        .map((tab) => getSecondTab(secondTabs.indexOf(tab), tab))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    LogService().log(LogType.view_screen, "main_page", null, {});

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Clothes> loadedClothes = await ClothesRepository().loadClothes();
      String? loadedClosetName = await ClosetRepository().loadClosetName();
      setState(() {
        print("reload3");
        clothesList = loadedClothes;
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
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Consumer<ReloadHomeProvider>(
        builder: (context, reloadNotifier, child) {
      if (reloadNotifier.shouldReload) {
        // ReloadHomeProvider에 boolean 필드 추가 필요
        WidgetsBinding.instance.addPostFrameCallback((_) {
          reload();
          // 리로드 후 상태 리셋
          reloadNotifier.resetReload();
        });
      }
      return Scaffold(
          backgroundColor: SignatureColors.begie200,
          body: CustomScrollView(
            controller:
                Provider.of<ScrollControllerProvider>(context, listen: false)
                    .scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true, // 스크롤 되어도 고정됨
                delegate: _FixedHeaderDelegate(
                    maxHeight: statusBarHeight,
                    minHeight: statusBarHeight,
                    child: Container(
                      color: SignatureColors.begie200,
                    )),
              ),
              SliverPersistentHeader(
                pinned: false,
                delegate: _FixedHeaderDelegate(
                    maxHeight: 48,
                    minHeight: 48,
                    child: Center(
                        child: Text(
                      closetName,
                      textAlign: TextAlign.center,
                      style: OneLineTextStyles.Bold18.copyWith(
                          color: SystemColors.black),
                    ))),
              ),
              SliverPersistentHeader(
                pinned: true, // 스크롤 되어도 고정됨
                delegate: _FixedHeaderDelegate(
                    maxHeight: 90,
                    minHeight: 90,
                    child: Container(
                        color: SignatureColors.begie200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0, top: 7.0),
                                    child: Row(
                                      mainAxisSize:
                                          MainAxisSize.max, // 이 줄을 추가합니다
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: getTabs(),
                                    ))),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0, bottom: 7.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start, // 이 줄을 추가합니다
                                      children: getSecondTabs().map((tab) {
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: tab);
                                      }).toList(),
                                    ))),
                          ],
                        ))),
              ),
              getClothesGrid(),
            ],
          ));
    });
  }
}

class _FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _FixedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _FixedHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
