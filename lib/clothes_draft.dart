import 'package:flutter/material.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:uuid/uuid.dart';

class ClothesDraft implements ClothesFamily {
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

  // 필드의 순서를 관리하는 리스트
  final List<String> fieldOrder = [
    'name',
    'primaryCategoryId',
    'secondaryCategoryId',
    'details',
    'color',
    'drawLines'
  ];

  // 필드와 값을 맵으로 관리
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'primaryCategoryId': primaryCategoryId,
      'secondaryCategoryId': secondaryCategoryId,
      'details': details,
      'color': color,
      'drawLines': drawLines,
    };
  }

  // 현재 어떤 필드까지 채워져 있는지 확인하는 함수
  int getLastFilledFieldIndex() {
    final map = toMap();
    for (int i = fieldOrder.length - 1; i >= 0; i--) {
      if (map[fieldOrder[i]] != null) {
        return i;
      }
    }
    return -1; // 아무 필드도 채워져 있지 않음
  }

  // 특정 필드의 순서를 알려주는 함수
  int getFieldIndex(String fieldName) {
    return fieldOrder.indexOf(fieldName);
  }

  // 특정 인덱스 이후의 모든 필드를 null로 설정하는 함수
  void resetFieldsAfterIndex(int index) {
    final map = toMap();
    for (int i = index + 1; i < fieldOrder.length; i++) {
      switch (fieldOrder[i]) {
        case 'name':
          name = null;
          break;
        case 'primaryCategoryId':
          primaryCategoryId = null;
          break;
        case 'secondaryCategoryId':
          secondaryCategoryId = null;
          break;
        case 'details':
          details = null;
          break;
        case 'color':
          color = null;
          break;
        case 'drawLines':
          drawLines = null;
          break;
      }
    }
  }

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
