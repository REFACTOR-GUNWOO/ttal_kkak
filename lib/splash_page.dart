import 'package:flutter/material.dart';
import 'package:ttal_kkak/main_layout.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainLayout()),
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
            // 로고 이미지 추가
            SizedBox(height: 20),
            // 로딩 인디케이터
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
