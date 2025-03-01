import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'styles/text_styles.dart';
import 'styles/colors_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';

final InAppReview inAppReview = InAppReview.instance;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LogService().log(LogType.view_screen, "setting_page", null, {});
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
        title: Text('설정',
            style:
                OneLineTextStyles.Bold18.copyWith(color: SystemColors.black)),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
        child: Padding(
          //바디
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            children: [
              PageGuidanceIllust(), // 페이지 가이드 일러스트 영역
              SizedBox(height: 40),
              CommunicationList(), // 커뮤니케이션 리스트 영역
              SizedBox(height: 16),
              SettingList(), // 설정 리스트 영역
            ],
          ),
        ),
      ),
    );
  }
}

class PageGuidanceIllust extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //일러스트박스
          width: 310,
          height: 170,
          child: SvgPicture.asset(
              'assets/icons/setting_illust_makers.svg'), // 이미지 경로
        ),
        Text.rich(
          //텍스트뭉치
          TextSpan(
            // text: '00 디자이너와 ',
            // style: TextStyle(fontFamily: 'Pretendard', fontSize: 16),
            children: <TextSpan>[
              TextSpan(
                text: '디자이너',
                style:
                    BodyTextStyles.Bold16.copyWith(color: SystemColors.black),
              ),
              TextSpan(
                text: '와 ',
                style: BodyTextStyles.Regular16.copyWith(
                    color: SystemColors.black),
              ),
              TextSpan(
                text: '개발자',
                style:
                    BodyTextStyles.Bold16.copyWith(color: SystemColors.black),
              ),
              TextSpan(
                  text: '가 \n딸깍을 열심히 만드는 중이에요!',
                  style: BodyTextStyles.Regular16.copyWith(
                      color: SystemColors.black)),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class CommunicationList extends StatelessWidget {
  //앱리뷰,유저피드백
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: SignatureColors.begie300, // 배경색 설정
        border: Border.all(
          color: SignatureColors.begie500, // 아웃라인 색상 설정
          width: 1, // 아웃라인 두께 설정
        ),
        borderRadius: BorderRadius.circular(10), // 테두리 모서리를 둥글게 설정 (선택 사항)
      ),
      child: Column(
        // 리스트 전체
        children: [
          GestureDetector(
              onTap: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  LogService().log(LogType.click_button, "setting_page",
                      "send_cheerup_message_button", {});
                });

                if (Platform.isAndroid) {
                  inAppReview.openStoreListing();
                }
                if (Platform.isIOS) {
                  if (!await launchUrl(Uri(
                      scheme: 'https',
                      host: 'itunes.apple.com',
                      path: "/app/id6739421950",
                      queryParameters: {'action': 'write-review'}))) {
                    throw Exception('Could not launch');
                  }
                }
              },
              child: Container(
                //첫번째 리스트
                margin: EdgeInsets.fromLTRB(16, 22, 16, 14),
                child: Column(//텍스트뭉치
                    children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                            //리스트#1
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                //타이틀
                                children: [
                                  Image.asset(
                                    'assets/icons/setting_1.png', // 아이콘 파일 경로
                                    width: 20, // 아이콘 너비
                                    height: 20, // 아이콘 높이
                                  ),
                                  SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
                                  Text('응원의 메세지 보내기',
                                      style:
                                          OneLineTextStyles.SemiBold16.copyWith(
                                              color: SystemColors.black)),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  // 본문
                                  SizedBox(
                                    width: 28,
                                  ),
                                  Flexible(
                                    child: Text(
                                      '따뜻한 응원의 메시지를 남겨주시면 디자이너의 능률이 크게 높아져요',
                                      style: BodyTextStyles.Regular14.copyWith(
                                          color: SystemColors.gray800),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        'assets/icons/arrow_right.png', // 아이콘 파일 경로
                        width: 16, // 아이콘 너비
                        height: 16, // 아이콘 높이
                      ),
                    ],
                  )
                ]),
              )),
          SizedBox(
            // 디바이더
            height: 0,
            child: Divider(
              color: SignatureColors.begie500, // Divider 색상
              thickness: 2, // Divider 두께
              indent: 16, // Divider 시작 지점의 패딩
              endIndent: 16, // Divider 끝 지점의 패딩
            ),
          ),
          GestureDetector(
            child: Container(
              //첫번째 리스트
              margin: EdgeInsets.fromLTRB(16, 14, 16, 22),
              child: Column(//텍스트뭉치
                  children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                          //리스트#1
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              //타이틀
                              children: [
                                Image.asset(
                                  'assets/icons/setting_2.png', // 아이콘 파일 경로
                                  width: 20, // 아이콘 너비
                                  height: 20, // 아이콘 높이
                                ),
                                SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
                                Text('피드백 보내기',
                                    style:
                                        OneLineTextStyles.SemiBold16.copyWith(
                                            color: SystemColors.black)),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                // 본문
                                SizedBox(
                                  width: 28,
                                ),
                                Flexible(
                                  child: Text(
                                      '추가됐으면 하는 기능이나 사용하면서 불편했던 점이 있나요? 사소한 내용이라도 좋아요!',
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: BodyTextStyles.Regular14.copyWith(
                                          color: SystemColors.gray800)),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/icons/arrow_right.png', // 아이콘 파일 경로
                      width: 16, // 아이콘 너비
                      height: 16, // 아이콘 높이
                    ),
                  ],
                )
              ]),
            ),
            onTap: () async {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                LogService().log(LogType.click_button, "setting_page",
                    "send_feedback_button", {});
              });

              if (Platform.isAndroid) {
                inAppReview.openStoreListing();
              }
              if (Platform.isIOS) {
                if (!await launchUrl(Uri(
                    scheme: 'https',
                    host: 'www.instagram.com',
                    path: "/ttal_kkak_2",
                    queryParameters: {'igsh': 'ZWlqMWhhZWE1bmd2-review'}))) {
                  throw Exception('Could not launch');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class SettingList extends StatefulWidget {
  SettingList({Key? key}) : super(key: key);

  @override
  _SettingListState createState() => _SettingListState();
}

class _SettingListState extends State<SettingList> {
  String version = "";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: SignatureColors.begie300, // 배경색 설정
        border: Border.all(
          color: SignatureColors.begie500, // 아웃라인 색상 설정
          width: 1, // 아웃라인 두께 설정
        ),
        borderRadius: BorderRadius.circular(10), // 테두리 모서리를 둥글게 설정 (선택 사항)
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 22, 16, 22),
            child: Column(//리스트컬럼#1
                children: [
              Column(children: [
                Row(
                  //타이틀
                  children: [
                    Image.asset(
                      'assets/icons/setting_3.png', // 아이콘 파일 경로
                      width: 20, // 아이콘 너비
                      height: 20, // 아이콘 높이
                    ),
                    SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
                    Expanded(
                      child: Container(
                        child: Text('앱 버전 ',
                            style: OneLineTextStyles.SemiBold16.copyWith(
                                color: SystemColors.black)),
                      ),
                    ),
                    Text(version,
                        style: OneLineTextStyles.SemiBold16.copyWith(
                            color: SystemColors.gray800))
                  ],
                )
              ])
            ]),
          ),
        ],
      ),
    );
  }
}
