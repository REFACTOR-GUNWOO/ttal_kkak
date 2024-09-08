import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttal_kkak/clothes_draft.dart';

class ClothesDraftRepository {
  static const String _clothesKey = 'clothes:draft:v8';

  Future<void> save(ClothesDraft clothes) async {
    print("saveClothes");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("save ${clothes.toJson()}");
    await prefs.setString(_clothesKey, jsonEncode(clothes.toJson()));
  }

  Future<ClothesDraft?> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clothesJson = prefs.getString(_clothesKey);
    print(clothesJson);
    if (clothesJson == null) {
      return null;
    }

    Map<String, dynamic> jsonMap = jsonDecode(clothesJson);
    return ClothesDraft.fromJson(jsonMap);
  }

  Future<void> delete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_clothesKey);
  }
}
