import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/is_newbie_repository.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttal_kkak/onboarding_page.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // ClothesRepository().deleteAllClothes();
    _navigateToHome();
    _controller = AnimationController(vsync: this);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  _navigateToHome() async {
    // 스플래시 화면을 3초 동안 표시한 후 홈 화면으로 이동합니다.
    await Future.delayed(Duration(seconds: 4), () {});
    _checkButtonClickStatus();
  }

  Future<void> _checkButtonClickStatus() async {
    if (await IsNewbieRepository().load() == false) {
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
            SvgPicture.asset("assets/icons/splash_icon.svg"),
            SizedBox(
              height: 12,
            ),
            Text(
              "내 첫 모바일 옷장 딸깍",
              style: BodyTextStyles.Regular16.copyWith(
                  color: SystemColors.gray900),
            ),
            SizedBox(
              height: 36,
            ),
            Padding(
              child: Lottie.asset(
                "assets/lotties/splash_lottie.json",
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
              padding: EdgeInsets.only(left: 20, right: 20),
            )
          ],
        ),
      ),
    );
  }
}
