import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class DailyOutfitPage extends StatefulWidget {
  @override
  _DailyOutfitPageState createState() => _DailyOutfitPageState();
}

class _DailyOutfitPageState extends State<DailyOutfitPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LogService().log(LogType.view_screen, "daily_outfit_page", null, {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignatureColors.begie200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //앱바
        backgroundColor: SignatureColors.begie200,
        title: Text('데일리 코디',
            style:
                OneLineTextStyles.Bold18.copyWith(color: SystemColors.black)),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: Column(children: [
        Expanded(
          flex: 2, // 1의 비율
          child: Container(color: Colors.transparent), // 투명으로 유지
        ),
        Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SvgPicture.asset(
                "assets/icons/daily_outfit_page_icon.svg",
                width: 180,
              ),
              SizedBox(
                  width: 172,
                  child: Text('곧 데일리 코디\n기능이 추가됩니다',
                      textAlign: TextAlign.center,
                      style: BodyTextStyles.Bold24.copyWith(
                          color: SystemColors.black))),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 178,
                  child: Text('등록한 옷으로 오늘의 코디를 미리 정해보세요!',
                      textAlign: TextAlign.center,
                      style: BodyTextStyles.Regular16.copyWith(
                          color: SystemColors.gray800)))
            ])),
        Expanded(
          flex: 3, // 1.5의 비율
          child: Container(color: Colors.transparent), // 투명으로 유지
        ),
      ]),
    );
  }
}
