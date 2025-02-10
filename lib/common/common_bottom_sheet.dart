import 'package:flutter/material.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';

class CommonBottomSheet extends StatelessWidget {
  Widget child;
  CommonBottomSheet({required this.child});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BottomSheetHandle(),
          child,
          SizedBox(height: MediaQuery.of(context).padding.bottom)
        ],
      ),
    );
  }
}

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: SignatureColors.begie600,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
