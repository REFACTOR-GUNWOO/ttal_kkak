import 'dart:io';

import 'package:flutter/material.dart';

double getBottomPadding(BuildContext context) {
  return Platform.isAndroid ? MediaQuery.of(context).padding.bottom : 0;
}
