import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttal_kkak/clothes.dart';

class ClothesRepository {
  static const String _clothesKey = 'clothes:v15';

  Future<void> saveClothes(List<Clothes> clothesList) async {
    print("saveClothes");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> clothesJsonList =
        clothesList.map((clothes) => jsonEncode(clothes.toJson())).toList();
    await prefs.setStringList(_clothesKey, clothesJsonList);
  }

  Future<void> save(Clothes clothes) async {
    print("saveClothes");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clothesKey, jsonEncode(clothes.toJson()));
  }

  Future<List<Clothes>> loadClothes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? clothesJsonList = prefs.getStringList(_clothesKey);
    print(clothesJsonList);
    if (clothesJsonList == null) {
      return [];
    }

    return clothesJsonList.map((jsonString) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return Clothes.fromJson(jsonMap);
    }).toList();
  }

  Future<void> addClothes(Clothes clothes) async {
    List<Clothes> clothesList = await loadClothes();
    clothesList.add(clothes);
    print(clothesList);
    await saveClothes(clothesList);
  }

  Future<void> addClothesList(Set<Clothes> clothesList) async {
    List<Clothes> oldClothesList = await loadClothes();
    oldClothesList.addAll(clothesList);
    await saveClothes(oldClothesList);
  }

  Future<void> removeClothes(Clothes clothes) async {
    List<Clothes> clothesList = await loadClothes();
    clothesList.removeWhere((c) => c.name == clothes.name); // Name으로 비교하여 삭제
    await saveClothes(clothesList);
  }

  Future<void> clearClothes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_clothesKey);
  }
}
