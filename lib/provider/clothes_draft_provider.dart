import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';

class ClothesDraftProvider with ChangeNotifier {
  ClothesDraft? _currentDraft;
  bool isStarted = false;
  ClothesDraft? get currentDraft => _currentDraft;

  Future<void> loadFromLocal() async {
    print("loadDraftFromLocal");
    _currentDraft = await ClothesDraftRepository().load();
    notifyListeners(); // 상태 변경 알림
  }

  updateDraft(ClothesDraft draft) async {
    print("updateDraft");
    _currentDraft = draft;
    await ClothesDraftRepository().save(draft);
    notifyListeners(); // 상태 변경 알림
  }

  void clearDraft() {
    _currentDraft = null;
    ClothesDraftRepository().delete();
    notifyListeners(); // 상태 변경 알림
  }

  void startDraft() {
    isStarted = true;
    notifyListeners();
  }
}
