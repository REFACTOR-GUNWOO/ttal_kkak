import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttal_kkak/clothes.dart';

class IsNewbieRepository {
  static const String _key = 'is-new-bie:v7';

  Future<bool?> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key);
  }

  Future<void> save(bool isNewbie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isNewbie);
  }
}
