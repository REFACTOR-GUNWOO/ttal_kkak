import 'package:flutter/material.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_grid.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class OnboardingAddClothesPage extends StatefulWidget {
  @override
  _OnboardingAddClothesPagetate createState() =>
      _OnboardingAddClothesPagetate();
}

class _OnboardingAddClothesPagetate extends State<OnboardingAddClothesPage> {
  final List<Clothes> clothesList = generateDummyClothes();
  late int tab1Index = 0;

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

  List<FirstCategory> getSortedCategories() {
    List<FirstCategory> categories = getCategorizedClothes().keys.toList();

    categories.sort((a, b) => a.priority.compareTo(b.priority));
    return categories;
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

    ClothesGrid getClothesGrid() {
      return tab1Index == 0
          ? ClothesGrid(
              clothesList: clothesList,
              isOnboarding: true,
              onReload: () {},
            )
          : ClothesGrid(
              clothesList: (getCategorizedClothes()[
                  getSortedCategories()[tab1Index - 1]]!),
              isOnboarding: true,
              onReload: () {},
            );
    }

    return Scaffold(
        backgroundColor: SignatureColors.begie200,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: SignatureColors.begie200,
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(160.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 38),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "기본템 패키지",
                          textAlign: TextAlign.left,
                          style: BodyTextStyles.Bold24.copyWith(
                              color: SystemColors.black),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "가지고 있는 기본템들을 터치 한 번으로\n쉽게 등록할 수 있게 해드릴게요!\n상세한 정보는 나중에 편집할 수 있어요",
                          textAlign: TextAlign.left,
                          style: BodyTextStyles.Regular14.copyWith(
                              color: SystemColors.black),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: getTabs(),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ],
              ),
            ),
            elevation: 0),
        body: getClothesGrid());
  }
}
