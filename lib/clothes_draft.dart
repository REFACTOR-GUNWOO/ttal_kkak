import 'package:flutter/material.dart';
import 'package:ttal_kkak/clothes.dart';

class ClothesDraft {
  String? name;
  int? primaryCategoryId;
  int? secondaryCategoryId;
  ClothesDetails? details; // 상세 설정
  Color? color;
  int? price;

  ClothesDraft({
    this.name,
    this.primaryCategoryId,
    this.secondaryCategoryId,
    this.details,
    this.color,
    this.price,
  });

  factory ClothesDraft.fromJson(Map<String, dynamic> json) {
    return ClothesDraft(
        name: json['name'],
        primaryCategoryId: json['primaryCategoryId'],
        secondaryCategoryId: json['secondaryCategoryId'],
        details: json['details'] == null
            ? null
            : ClothesDetails.fromJson(json['details']),
        color: json['color'] == null ? null : Color(json['color']),
        price: json["price"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'primaryCategoryId': primaryCategoryId,
      'secondaryCategoryId': secondaryCategoryId,
      'details': details?.toJson(),
      'color': color?.value,
      'price': price,
    };
  }
}
