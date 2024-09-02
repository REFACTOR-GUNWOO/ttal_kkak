import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:uuid/uuid.dart';

class ClothesDraft {
  String? name;
  int? primaryCategoryId;
  int? secondaryCategoryId;
  ClothesDetails? details; // 상세 설정
  Color? color;
  List<DrawnLine>? drawLines;

  ClothesDraft(
      {this.name,
      this.primaryCategoryId,
      this.secondaryCategoryId,
      this.details,
      this.color,
      this.drawLines});

  Clothes toClotehs() {
    return Clothes(
        id: Uuid().v4(),
        name: name!,
        primaryCategoryId: primaryCategoryId!,
        secondaryCategoryId: secondaryCategoryId!,
        details: details!,
        color: color!,
        drawLines: drawLines!,
        price: null,
        regTs: DateTime.now());
  }

  int countLevel() {
    // 각 필드를 검사하여 null인 경우 nullCount 증가
    if (name == null) return 0;
    if (primaryCategoryId == null) return 1;
    if (secondaryCategoryId == null) return 2;
    if (details == null) return 3;
    if (color == null) return 4;
    if (drawLines == null) return 5;

    return 6;
  }

  factory ClothesDraft.fromJson(Map<String, dynamic> json) {
    return ClothesDraft(
        name: json['name'],
        primaryCategoryId: json['primaryCategoryId'],
        secondaryCategoryId: json['secondaryCategoryId'],
        details: json['details'] == null
            ? null
            : ClothesDetails.fromJson(json['details']),
        color: json['color'] == null ? null : Color(json['color']),
        drawLines: (json['drawLines'] as List?)
                ?.map((lineJson) => DrawnLine.fromJson(lineJson))
                .toList() ??
            null);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'primaryCategoryId': primaryCategoryId,
      'secondaryCategoryId': secondaryCategoryId,
      'details': details?.toJson(),
      'color': color?.value,
      'drawLines': drawLines?.map((e) => e.toJson()).toList()
    };
  }
}
