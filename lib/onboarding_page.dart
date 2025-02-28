import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/is_newbie_repository.dart';
import 'package:ttal_kkak/onboarding_add_clothes_page.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: SystemColors.gray700,
      context: context,
      builder: (BuildContext context) {
        return BottomSheetContent();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true, // 바텀시트가 전체 화면을 사용하게 함
    );
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context);
      LogService().log(LogType.view_screen, "first_gift_page", null, {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black, // 백그라운드 색상 설정
      body: Container(), // 빈 컨테이너
    );
  }
}

//바텀시트 UI
class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, // 화면의 50% 높이를 사용
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.0),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => OnboardingAddClothesPage()),
                  );
                },
                child: Lottie.asset(
                  'assets/lotties/onboarding_present.json',
                  width: 240,
                  height: 240,
                  fit: BoxFit.fill,
                ),
              ),
              Text('첫 방문 선물 도착', style: BodyTextStyles.Bold24),
              SizedBox(height: 10.0),
              Text(
                '처음 방문한 기념으로 가지고 있는 기본템을\n터치 한 번으로 쉽게 등록하게 해드릴게요!',
                textAlign: TextAlign.center,
                style: BodyTextStyles.Regular14,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => OnboardingAddClothesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width - 40, 56),
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                ),
                child: Text('선물 받기', style: OneLineTextStyles.SemiBold16),
              ),
              // Spacer(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ));
  }
}
