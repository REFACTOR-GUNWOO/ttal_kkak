import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ttal_kkak/add_clothes_page.dart';
import 'package:ttal_kkak/setting_page.dart';
import 'package:ttal_kkak/splash_page.dart';
import 'package:ttal_kkak/setting_page.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Splash Screen',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: {
        '/addClothes': (context) => AddClothesPage(),
      },
    );
  }
}
