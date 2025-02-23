import 'package:flutter/material.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';

class OnboardingClothesSelectProvider extends ChangeNotifier {
  Map<int, bool> selected = {};

  void toggle(Clothes clothes) {
    selected[clothes.id!] = !(selected[clothes.id] ?? false);
    notifyListeners();
  }

  bool isSelected(Clothes clothes) {
    return selected[clothes.id] == true;
  }

  Set<String> getSelectedClothesCategories() {
    final clothesList = generateDummyClothes();

    return selected.entries.where((entry) => entry.value).map((entry) {
      final clothes = clothesList.firstWhere(
        (element) => element.id == entry.key,
      );
      final category = firstCategories.firstWhere(
        (element) => element.id == clothes.primaryCategoryId,
      );
      return category.code; // null 체크 추가
    }).toSet();
  }

  int selectedCount() {
    return selected.values.where((element) => element).length;
  }

  Future<void> migrate() async {
    var selectedIds =
        selected.entries.where((it) => it.value == true).map((it) => it.key);

    var clothesList = generateDummyClothes();
    await ClothesRepository().addClothesList(selectedIds
        .map((it) => clothesList.firstWhere((e) => e.id == it))
        .toSet());
  }
}
