import 'package:flutter/material.dart';

class ScrollControllerProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  void scrollToTop() {
    scrollController.animateTo(
      0.0, // 맨 위로 이동
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

