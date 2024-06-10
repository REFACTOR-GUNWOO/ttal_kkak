import 'package:flutter/material.dart';
import 'package:ttal_kkak/add_clothes_page.dart';
import 'package:ttal_kkak/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: {
        '/addClothes': (context) => AddClothesPage(),
      },
    );
  }
}
