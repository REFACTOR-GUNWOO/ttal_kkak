import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  await FirebaseAnalytics.instance.logAppOpen();
  String installationId = await FirebaseInstallations.instance.getId();
  await FirebaseAnalytics.instance.setUserId(id: installationId);

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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Splash Screen',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: false,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      ),
      initialRoute: '/', // 앱 시작 시 첫 화면 설정
      routes: {
        '/': (context) => SplashPage(), // 스플래시 페이지를 첫 화면으로 설정
        '/main': (context) => MainPage(isOnboarding: false), // 메인 페이지
        '/addClothes': (context) => MainPage(isOnboarding: true), // 옷 등록 화면
      },
    );
  }
}
