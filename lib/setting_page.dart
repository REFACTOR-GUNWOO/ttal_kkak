import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  //원본위젯
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F6EF),
      appBar: AppBar(
        //앱바
        backgroundColor: Color(0xFFF7F6EF),
        title: Text(
          '설정',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xff1e1e1e),
          ),
        ),
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
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                  'assets/images/setting_illust_makers.png'), // 이미지 경로
              fit: BoxFit.cover, // 이미지 크기에 맞게 조정
            ))),
        Text.rich(
          //텍스트뭉치
          TextSpan(
            // text: '00 디자이너와 ',
            // style: TextStyle(fontFamily: 'Pretendard', fontSize: 16),
            children: <TextSpan>[
              TextSpan(
                text: '00 디자이너',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(text: '와 '),
              TextSpan(
                text: '00 개발자',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(text: '가 \n딸깍을 열심히 만드는 중이에요!'),
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
        color: Color(0xffEFEDE5), // 배경색 설정
        border: Border.all(
          color: Color(0xffE3E0D3), // 아웃라인 색상 설정
          width: 1, // 아웃라인 두께 설정
        ),
        borderRadius: BorderRadius.circular(10), // 테두리 모서리를 둥글게 설정 (선택 사항)
      ),
      child: Column(
        // 리스트 전체
        children: [
          Container(
            //첫번째 리스트
            margin: EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                              Text(
                                '00에게 응원의 메세지 보내기',
                                style: TextStyle(
                                  fontSize: 16, // 텍스트 크기
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black, // 텍스트 색상
                                ),
                              ),
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
                                  '따뜻한 메세지가 00와 00의 능률을 크게 높여요!',
                                  style: TextStyle(
                                    fontSize: 16, // 텍스트 크기
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff717171), // 텍스트 색상
                                  ),
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
          ),
          SizedBox(
            // 디바이더
            height: 0,
            child: Divider(
              color: Color(0xffE3E0D3), // Divider 색상
              thickness: 2, // Divider 두께
              indent: 16, // Divider 시작 지점의 패딩
              endIndent: 16, // Divider 끝 지점의 패딩
            ),
          ),
          Container(
            //첫번째 리스트
            margin: EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                              Text(
                                '00에게 피드백 메세지 보내기',
                                style: TextStyle(
                                  fontSize: 16, // 텍스트 크기
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black, // 텍스트 색상
                                ),
                              ),
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
                                  style: TextStyle(
                                    fontSize: 16, // 텍스트 크기
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff717171), // 텍스트 색상
                                  ),
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
          ),
        ],
      ),
    );
  }
}

class SettingList extends StatelessWidget {
  //앱리뷰,유저피드백
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xffEFEDE5), // 배경색 설정
        border: Border.all(
          color: Color(0xffE3E0D3), // 아웃라인 색상 설정
          width: 1, // 아웃라인 두께 설정
        ),
        borderRadius: BorderRadius.circular(10), // 테두리 모서리를 둥글게 설정 (선택 사항)
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                        child: Text(
                          '앱 버전 ',
                          style: TextStyle(
                            fontSize: 16, // 텍스트 크기
                            fontWeight: FontWeight.w600,
                            color: Colors.black, // 텍스트 색상
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '1.0.1',
                      style: TextStyle(
                        fontSize: 16, // 텍스트 크기
                        fontWeight: FontWeight.w400,
                        color: Color(0xff717171), // 텍스트 색상
                      ),
                    ),
                  ],
                )
              ])
            ]),
          ),
          SizedBox(
            height: 0,
            child: Divider(
              color: Color(0xffE3E0D3), // Divider 색상
              thickness: 2, // Divider 두께
              indent: 16, // Divider 시작 지점의 패딩
              endIndent: 16, // Divider 끝 지점의 패딩
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(//리스트컬럼#1
                children: [
              Column(children: [
                Row(
                  //타이틀
                  children: [
                    Image.asset(
                      'assets/icons/setting_4.png', // 아이콘 파일 경로
                      width: 20, // 아이콘 너비
                      height: 20, // 아이콘 높이
                    ),
                    SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
                    Expanded(
                      child: Container(
                        child: Text(
                          '데이터 백업',
                          style: TextStyle(
                            fontSize: 16, // 텍스트 크기
                            fontWeight: FontWeight.w600,
                            color: Colors.black, // 텍스트 색상
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/arrow_right.png',
                      width: 16,
                      height: 16,
                    ),
                    // ),
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
