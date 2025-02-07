import 'package:flutter/material.dart';

class ScrollControllerProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool isScrolling = false;
  double? beforeScrollOffset = 0.0;
  void scrollToTop(double scrollOffset) {
    if (scrollController.hasClients && !isScrolling) {
      print("offset : ${scrollController.offset}");
      beforeScrollOffset = scrollController.offset;
      isScrolling = true;
      scrollController
          .animateTo(
        scrollOffset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      )
          .whenComplete(() {
        isScrolling = false;
      });
    }
  }

  void scrollToBeforeOffset() {
    if (scrollController.hasClients &&
        !isScrolling &&
        beforeScrollOffset != null) {
      print("scrollToBeforeOffset : ${scrollController.offset}");
      isScrolling = true;
      scrollController
          .animateTo(
        beforeScrollOffset!,
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
