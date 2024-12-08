import 'package:flutter/material.dart';

class ReloadHomeProvider extends ChangeNotifier {
  bool _shouldReload = false;

  bool get shouldReload => _shouldReload;

  void triggerReload() {
    _shouldReload = true;
    notifyListeners();
  }

  void resetReload() {
    _shouldReload = false;
    notifyListeners();
  }
}