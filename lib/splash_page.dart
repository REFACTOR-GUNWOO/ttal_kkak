import 'package:flutter/material.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttal_kkak/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // 스플래시 화면을 3초 동안 표시한 후 홈 화면으로 이동합니다.
    await Future.delayed(Duration(seconds: 3), () {});
    _checkButtonClickStatus();
  }

  Future<void> _checkButtonClickStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isButtonClicked = prefs.getBool('ctaButtonClicked');

    if (isButtonClicked == true) {
      _navigateToMainPage();
    } else {
      _navigateToOnboardingPage();
    }
  }

  void _navigateToMainPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainLayout()),
    );
  }

  void _navigateToOnboardingPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OnboardingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "내 첫 모바일 옷장",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "딸깍",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
