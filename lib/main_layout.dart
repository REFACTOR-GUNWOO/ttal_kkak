import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes.dart';
import 'package:ttal_kkak/main_page.dart';
import 'package:ttal_kkak/setting_page.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignatureColors.begie500,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          MainPage(), // 내 옷장 페이지
          SettingPage(), // 통계 페이지
          SettingPage(), // 코디 페이지
          SettingPage(), // 설정 페이지
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: SizedBox(
          height: 82,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: true,
                  enableFeedback: false,
                  elevation: 0,
                  backgroundColor: SignatureColors.begie500,
                  items: [
                    BottomNavigationBarItem(
                      backgroundColor: SignatureColors.begie500,
                      icon: SvgPicture.asset(
                        "assets/icons/tab_1_icon.svg",
                        width: 24,
                        color: _selectedIndex == 0
                            ? SystemColors.black
                            : SystemColors.gray700,
                      ),
                      label: '내 옷장',
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: SignatureColors.begie500,
                      icon: SvgPicture.asset(
                        "assets/icons/tab_2_icon.svg",
                        width: 24,
                        color: _selectedIndex == 1
                            ? SystemColors.black
                            : SystemColors.gray700,
                      ),
                      label: '통계',
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: SignatureColors.begie500,
                      icon: SvgPicture.asset(
                        "assets/icons/tab_3_icon.svg",
                        width: 24,
                        color: _selectedIndex == 2
                            ? SystemColors.black
                            : SystemColors.gray700,
                      ),
                      label: '코디',
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: SignatureColors.begie500,
                      icon: SvgPicture.asset(
                        "assets/icons/tab_4_icon.svg",
                        width: 24,
                        color: _selectedIndex == 3
                            ? SystemColors.black
                            : SystemColors.gray700,
                      ),
                      label: '설정',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: SystemColors.black, // 선택된 아이템 색상
                  unselectedItemColor: SystemColors.gray700, // 선택되지 않은 아이템 색상
                  selectedLabelStyle: OneLineTextStyles.Medium10.copyWith(
                      color: SystemColors.black), // 선택된 텍스트 스타일
                  unselectedLabelStyle: OneLineTextStyles.Medium10.copyWith(
                      color: SystemColors.gray700), // 선택되지 않은 텍스트 스타일
                  onTap: (index) {
                    _onItemTapped(index);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: GestureDetector(
                  onTap: () {
                    ShowAddClothesBottomSheet(context, false);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.orange, // 배경색
                      borderRadius: BorderRadius.circular(8), // 둥근 모서리
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add, // 플러스 아이콘
                        color: Colors.black, // 아이콘 색상
                        size: 20, // 아이콘 크기
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
