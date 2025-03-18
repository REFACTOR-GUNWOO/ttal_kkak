import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes_page.dart';
import 'package:ttal_kkak/common/log_service.dart';
import 'package:ttal_kkak/daily_outfit_page.dart';
import 'package:ttal_kkak/main_page.dart';
import 'package:ttal_kkak/setting_page.dart';
import 'package:ttal_kkak/widgets/statistics/statistics_page.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/tool_tip_with_tail.dart';
import 'dart:ui'; // BackdropFilter를 사용하기 위한 라이브러리 추가

class MainLayout extends StatefulWidget {
  final int? currentTabIndex;
  const MainLayout({super.key, this.currentTabIndex = 0});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentTabIndex ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pageController.jumpToPage(_selectedIndex);
    });
  }

  // 탭 정보 공통 리스트
  final List<Map<String, String>> _tabs = [
    {"name": "내 옷장", "icon": "assets/icons/tab_1_icon.svg"},
    {"name": "통계", "icon": "assets/icons/tab_2_icon.svg"},
    {"name": "설정", "icon": "assets/icons/tab_4_icon.svg"},
  ];

  void _onItemTapped(int index) {
    LogService().log(
      LogType.click_button,
      "main_layout",
      "tab_button",
      {"tab_name": _tabs[index]["name"] ?? "unknown"},
    );

    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignatureColors.begie500,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          MainPage(isOnboarding: false), // 내 옷장 페이지
          StatisticsPage(), // 통계 페이지
          SettingPage(), // 설정 페이지
        ],
      ),
      bottomNavigationBar:SafeArea(child: Container(
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
                          items: _tabs.map((tab) {
                            int index = _tabs.indexOf(tab);
                            return BottomNavigationBarItem(
                              icon: SvgPicture.asset(
                                tab["icon"]!,
                                width: 24,
                                color: _selectedIndex == index
                                    ? SystemColors.black
                                    : SystemColors.gray600,
                              ),
                              label: tab["name"],
                            );
                          }).toList(),
                          currentIndex: _selectedIndex,
                          selectedItemColor: SystemColors.black,
                          unselectedItemColor: SystemColors.gray700,
                          selectedLabelStyle:
                              OneLineTextStyles.Medium10.copyWith(
                                  color: SystemColors.black),
                          unselectedLabelStyle:
                              OneLineTextStyles.Medium10.copyWith(
                                  color: SystemColors.gray700),
                          onTap: _onItemTapped,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6, left: 30),
                      child: GestureDetector(
                        onTap: () async {
                          await LogService().log(
                            LogType.click_button,
                            "main_page",
                            "clothing_register_button",
                            {},
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddClothesPage(
                                isUpdate: false,
                                onClose: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => MainLayout()),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: SignatureColors.orange400,
                            borderRadius: BorderRadius.circular(8),
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
            ),
          ),
        ),
      );
  }
}
