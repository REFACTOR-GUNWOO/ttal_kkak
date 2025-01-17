import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/main_page.dart';
import 'package:ttal_kkak/provider/scroll_controller_provider.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/splash_page.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClothesDraftProvider()),
        ChangeNotifierProvider(create: (_) => ClothesUpdateProvider()),
        ChangeNotifierProvider(create: (_) => ReloadHomeProvider()),
        ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: true,
      title: 'Flutter Splash Screen',
      theme: ThemeData(
          fontFamily: 'Pretendard',
          useMaterial3: false,

          // primarySwatch: SignatureColors.begie200,
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ))),
      home: SplashPage(),
      routes: {
        '/addClothes': (context) => MainPage(),
      },
    );
  }
}
