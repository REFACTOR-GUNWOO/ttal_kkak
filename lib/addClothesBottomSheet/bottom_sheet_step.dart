import 'package:flutter/material.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';

abstract class BottomSheetStep extends StatefulWidget {
  final VoidCallback onNextStep;
  final ClothesUpdateProvider updateProvider;
  final bool isUpdate;
  final bool Function() canGoNext;
  BottomSheetStep({
    required this.onNextStep,
    Key? key,
    required this.updateProvider,
    required this.isUpdate,
    required this.canGoNext,
  }) : super(key: key);

  String getTitle();
}
