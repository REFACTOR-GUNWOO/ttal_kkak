import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';

class ClothesDraftProvider with ChangeNotifier {
  ClothesDraft? _currentDraft;

  ClothesDraft? get currentDraft => _currentDraft;

  void updateDraft(ClothesDraft draft) {
    print("updateDraft");

    _currentDraft = draft;
    notifyListeners(); // 상태 변경 알림
  }

  void clearDraft() {
    _currentDraft = null;
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> loadDraftFromLocal() async {
    print("loadDraftFromLocal");
    _currentDraft = await ClothesDraftRepository().load();
    notifyListeners(); // 상태 변경 알림
  }
}
