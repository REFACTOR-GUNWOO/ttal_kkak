import 'package:flutter/material.dart';

abstract class BottomSheetStep extends StatefulWidget {
  final VoidCallback onNextStep;
  

  BottomSheetStep({
    required this.onNextStep,
    Key? key,
  }) : super(key: key);

  String getTitle();
}
