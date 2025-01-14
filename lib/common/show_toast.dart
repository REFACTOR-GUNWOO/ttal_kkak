import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

void showToast(String message, BuildContext context) {
  var fToast = FToast();
  // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
  fToast.init(context);

  Widget toast = Container(
    width: 224,
    height: 48,
    decoration: BoxDecoration(
      color: SystemColors.black.withOpacity(0.7), // 투명도 조절하여 블러 처리
      borderRadius: BorderRadius.circular(8), // 둥근 모서리
    ),
    alignment: Alignment.center,
    child: Text(
      message,
      style: OneLineTextStyles.Medium14.copyWith(color: SystemColors.white),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.CENTER,
    toastDuration: Duration(seconds: 2),
  );
}
