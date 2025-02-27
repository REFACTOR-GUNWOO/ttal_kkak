import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';

class ClothesUpdateProvider with ChangeNotifier {
  Clothes? _currentClothes;
  bool _primaryCategoryUpdated = false;
  Clothes? get currentClothes => _currentClothes;
  bool get primaryCategoryUpdated => _primaryCategoryUpdated;
  void set(Clothes clothes) {
    _currentClothes = clothes;
    notifyListeners(); // 상태 변경 알림
  }

  update(
    Clothes clothes,
  ) async {
    _currentClothes = clothes;
    _primaryCategoryUpdated = primaryCategoryUpdated;
    print("_currentClothes: ${_currentClothes}");
    notifyListeners(); // 상태 변경 알림
    await ClothesRepository().updateClothes(clothes);
  }

  setPrimaryCategoryUpdated(bool primaryCategoryUpdated) {
    _primaryCategoryUpdated = primaryCategoryUpdated;
    notifyListeners(); // 상태 변경 알림
  }

  void clear() {
    _currentClothes = null;
    notifyListeners(); // 상태 변경 알림
  }

  // Future<void> loadftFromLocal() async {
  //   print("loadDraftFromLocal");
  //   _currentDraft = await ClothesDraftRepository().load();
  //   notifyListeners(); // 상태 변경 알림
  // }
}
