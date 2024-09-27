import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';

class ClothesUpdateProvider with ChangeNotifier {
  Clothes? _currentClothes;

  Clothes? get currentClothes => _currentClothes;

  void set(Clothes clothes) {
    _currentClothes = clothes;
    notifyListeners(); // 상태 변경 알림
  }

  update(Clothes clothes) async {
    _currentClothes = clothes;
    print("_currentClothes: ${_currentClothes}");
    notifyListeners(); // 상태 변경 알림
    await ClothesRepository().updateClothes(clothes);
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
