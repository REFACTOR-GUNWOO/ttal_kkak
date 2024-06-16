import 'package:flutter/material.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation baseLocation;
  final double offsetX;
  final double offsetY;

  CustomFloatingActionButtonLocation(this.baseLocation,
      {this.offsetX = 0, this.offsetY = 0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // 기본 위치의 오프셋을 가져옵니다.
    Offset baseOffset = baseLocation.getOffset(scaffoldGeometry);

    // 오프셋을 추가하여 새로운 위치를 반환합니다.
    return Offset(baseOffset.dx + offsetX, baseOffset.dy + offsetY);
  }
}
