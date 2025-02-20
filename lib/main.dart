import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/main_page.dart';
import 'package:ttal_kkak/provider/onboarding_clothes_select_provider.dart';
import 'package:ttal_kkak/provider/scroll_controller_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAnalytics.instance.logAppOpen();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClothesUpdateProvider()),
        ChangeNotifierProvider(create: (_) => ReloadHomeProvider()),
        ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
        ChangeNotifierProvider(
            create: (_) => OnboardingClothesSelectProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
