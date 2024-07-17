import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_grid.dart';
import 'package:ttal_kkak/onboarding_clothes_grid.dart';

class OnboardingAddClothesPage extends StatelessWidget {
  final List<Clothes> clothesList = generateDummyClothes();

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
    };

    List<Tab> getTabs() {
      Tab allTab = Tab(text: '전체 ${clothesList.length}');
      List<Tab> tabList = getSortedCategories().map((category) {
        int itemCount = categorizedClothes[category]!.length;
        return Tab(text: '${category.name} $itemCount');
      }).toList();
      tabList.insert(0, allTab);
      return tabList;
    }

    List<OnboardingClothesGrid> getTabBarViews() {
      OnboardingClothesGrid allTabView =
          OnboardingClothesGrid(clothesList: clothesList);

      List<OnboardingClothesGrid> allTabViews =
          getSortedCategories().map((category) {
        List<Clothes> clothesToShow = categorizedClothes[category]!;
        return OnboardingClothesGrid(clothesList: clothesToShow);
      }).toList();

      allTabViews.insert(0, allTabView);
      return allTabViews;
    }

    return DefaultTabController(
      length: getSortedCategories().length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('기본템 패키지', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Colors.purple,
                isScrollable: true,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.black,
                tabs: getTabs(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: getTabBarViews(),
        ),
      ),
    );
  }
}
