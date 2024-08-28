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
  int? price;
  List<DrawnLine>? drawLines;

  ClothesDraft(
      {this.name,
      this.primaryCategoryId,
      this.secondaryCategoryId,
      this.details,
      this.color,
      this.price,
      this.drawLines});

  Clothes toClotehs() {
    return Clothes(
        id: Uuid().v4(),
        name: name!,
        primaryCategoryId: primaryCategoryId!,
        secondaryCategoryId: secondaryCategoryId!,
        details: details!,
        color: color!,
        price: price,
        drawLines: drawLines!,
        regTs: DateTime.now());
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
        price: json["price"],
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
      'price': price,
      'drawLines': drawLines?.map((e) => e.toJson()).toList()
    };
  }
}
