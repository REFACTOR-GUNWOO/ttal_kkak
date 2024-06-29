import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttal_kkak/clothes.dart';

class ClosetRepository {
  static const String _closetKey = 'closet:v3';
  static const String _closetNameKey = '${_closetKey}:name';

  Future<String?> loadClosetName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? closetName = prefs.getString(_closetNameKey);
    return closetName;
  }

  Future<void> saveClosetName(String closetName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_closetNameKey, closetName);
  }
}
