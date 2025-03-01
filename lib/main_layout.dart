import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes_page.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/daily_outfit_page.dart';
import 'package:ttal_kkak/main_page.dart';
import 'package:ttal_kkak/setting_page.dart';
import 'package:ttal_kkak/statistics_page.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/tool_tip_with_tail.dart';
import 'dart:ui'; // BackdropFilter를 사용하기 위한 라이브러리 추가

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1), // 아래에서 시작
      end: Offset(0, 0), // 원래 위치로 이동
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  // 툴팁을 보여주는 함수
  void _showTooltip() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward(); // 애니메이션 시작
  }

  // 툴팁을 숨기는 함수
  void _hideTooltip() {
    try {
      if (_overlayEntry?.mounted == true) _overlayEntry?.remove();
    } catch (e) {
      print(e);
    }
  }

  // OverlayEntry 생성 함수
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _hideTooltip(); // 화면 다른 곳을 클릭하면 툴팁이 사라짐
            },
            onPanStart: (details) {
              _hideTooltip(); // 드래그 시작 시 툴팁 숨김
            },
            onPanUpdate: (details) {
              _hideTooltip(); // 드래그 중에도 툴팁 숨김
            },
            onPanEnd: (details) {
              _hideTooltip(); // 드래그 끝에도 툴팁 숨김
            },
            child: Container(
              color: Colors.transparent, // 투명한 배경으로 다른 곳 클릭 인식
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            bottom: 100, // 바텀 탭 위에 위치
            right: 20, // 중앙에서 약간 왼쪽에 위치
            child: Material(
              color: Colors.transparent,
              child: SlideTransition(
                position: _offsetAnimation,
                child: RandomTooltipScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initializeAnimation(); // 애니메이션 초기화 함수 호출
      _showTooltip();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SignatureColors.begie500,
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            MainPage(
              isOnboarding: false,
            ), // 내 옷장 페이지
            // StatisticsPage(), // 통계 페이지
            // DailyOutfitPage(), // 코디 페이지
            SettingPage(), // 설정 페이지
          ],
        ),
        bottomNavigationBar: ClipRRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40), // 블러 효과 설정
                child: Container(
                    color: SignatureColors.begie500.withOpacity(0.5), // 반투명 배경
                    child: Padding(
                      padding: const EdgeInsets.only(left: 42, right: 30),
                      child: SizedBox(
                        height: 82,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: BottomNavigationBar(
                                backgroundColor: Colors.transparent,
                                type: BottomNavigationBarType.fixed,
                                showUnselectedLabels: true,
                                enableFeedback: false,
                                elevation: 0,
                                items: [
                                  BottomNavigationBarItem(
                                    icon: SvgPicture.asset(
                                      "assets/icons/tab_1_icon.svg",
                                      width: 24,
                                      color: _selectedIndex == 0
                                          ? SystemColors.black
                                          : SystemColors.gray600,
                                    ),
                                    label: '내 옷장',
                                  ),
                                  // BottomNavigationBarItem(
                                  //   icon: SvgPicture.asset(
                                  //     "assets/icons/tab_2_icon.svg",
                                  //     width: 24,
                                  //     color: _selectedIndex == 1
                                  //         ? SystemColors.black
                                  //         : SystemColors.gray600,
                                  //   ),
                                  //   label: '통계',
                                  // ),
                                  // BottomNavigationBarItem(
                                  //   icon: SvgPicture.asset(
                                  //     "assets/icons/tab_3_icon.svg",
                                  //     width: 24,
                                  //     color: _selectedIndex == 2
                                  //         ? SystemColors.black
                                  //         : SystemColors.gray600,
                                  //   ),
                                  //   label: '코디',
                                  // ),
                                  BottomNavigationBarItem(
                                    icon: SvgPicture.asset(
                                      "assets/icons/tab_4_icon.svg",
                                      width: 24,
                                      color: _selectedIndex == 3
                                          ? SystemColors.black
                                          : SystemColors.gray600,
                                    ),
                                    label: '설정',
                                  ),
                                ],
                                currentIndex: _selectedIndex,
                                selectedItemColor:
                                    SystemColors.black, // 선택된 아이템 색상
                                unselectedItemColor:
                                    SystemColors.gray700, // 선택되지 않은 아이템 색상
                                selectedLabelStyle:
                                    OneLineTextStyles.Medium10.copyWith(
                                        color:
                                            SystemColors.black), // 선택된 텍스트 스타일
                                unselectedLabelStyle:
                                    OneLineTextStyles.Medium10.copyWith(
                                        color: SystemColors
                                            .gray700), // 선택되지 않은 텍스트 스타일
                                onTap: (index) {
                                  _onItemTapped(index);
                                },
                              ),
                            )),
                            Padding(
                              padding: EdgeInsets.only(top: 6, left: 30),
                              child: GestureDetector(
                                onTap: () async {
                                  await LogService().log(
                                      LogType.click_button,
                                      "main_page",
                                      "clothing_register_button", {});

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddClothesPage(isUpdate: false)),
                                  );
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: SignatureColors.orange400, // 배경색
                                    borderRadius:
                                        BorderRadius.circular(8), // 둥근 모서리
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                        "assets/icons/add_clothes_icon.svg"),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )))));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose(); // 애니메이션 컨트롤러도 해제
    _overlayEntry?.dispose(); // 오버레이 엔트리도 해제
    super.dispose();
  }
}
