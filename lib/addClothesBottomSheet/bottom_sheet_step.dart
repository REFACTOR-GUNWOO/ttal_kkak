import 'package:flutter/material.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';

abstract class BottomSheetStep extends StatefulWidget {
  final VoidCallback onNextStep;
  final bool isUpdate;
  final ClothesDraftProvider draftProvider;
  final ClothesUpdateProvider updateProvider;
  
  BottomSheetStep({
    required this.onNextStep,
    Key? key,
    required this.isUpdate,
    required this.draftProvider, required this.updateProvider,
  }) : super(key: key);

  String getTitle();
}
