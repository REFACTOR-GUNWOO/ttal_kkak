import 'package:flutter/material.dart';
import 'package:ttal_kkak/onboarding_add_clothes_page.dart';


class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // 백그라운드 색상 설정
      body: Container(), // 빈 컨테이너
    );
  }
}

//바텀시트 UI
class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
        Container(
          height: MediaQuery.of(context).size.height * 0.5, // 화면의 50% 높이를 사용
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                SizedBox(height: 10.0),
                Container(
                  height: 4.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: () => {},
                  child: Text("로띠가 들어갈 곳"),
                ),
                Text(
                  '첫 방문 선물 도착',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  '처음 방문한 기념으로 가지고 있는 기본템을\n터치 한 번으로 쉽게 등록하게 해드릴게요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => OnboardingAddClothesPage()),
                    );
                  },
                  child: Text('등록'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // 버튼 색상
                    onPrimary: Colors.white, // 버튼 텍스트 색상
                    minimumSize: Size(double.infinity, 50), // 버튼 크기
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
     );
  }
}
