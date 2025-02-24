import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LogService().log(LogType.view_screen, "statistics_page", null, {});
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
        title: Text('통계',
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
                "assets/icons/statistics_page_icon.svg",
                width: 180,
              ),
              Text('곧 통계 기능이 추가됩니다',
                  style: BodyTextStyles.Bold24.copyWith(
                      color: SystemColors.black)),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 287,
                  child: Text('카테고리, 계절별로 옷을 얼마나 가지고 있는지 알려드릴게요. 조금만 기다려주세요.',
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
