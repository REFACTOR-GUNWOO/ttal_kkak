import 'package:flutter/material.dart';

class ScrollControllerProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool isScrolling = false;

  void scrollToTop(BuildContext context) {
    if (scrollController.hasClients && !isScrolling) {
      isScrolling = true;
      scrollController
          .animateTo(
        MediaQuery.of(context).padding.top,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      )
          .whenComplete(() {
        isScrolling = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
