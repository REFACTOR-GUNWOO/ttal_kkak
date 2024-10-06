import 'package:flutter/material.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignatureColors.begie500,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MainPage(), // 내 옷장 페이지
          SettingPage(),
          SettingPage(),
          SettingPage()
        ], // 설정 페이지
      ),
      bottomNavigationBar: SizedBox(
        height: 82,
        child: BottomNavigationBar(
          backgroundColor: SignatureColors.begie500,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.checkroom, size: 24),
              label: '내 옷장',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart, size: 24),
              label: '통계',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.style, size: 24),
              label: '코디',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 24),
              label: '설정',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add, size: 24),
              label: '추가',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange, // 선택된 아이템 색상
          unselectedItemColor: Colors.black, // 선택되지 않은 아이템 색상
          selectedLabelStyle: OneLineTextStyles.Medium10.copyWith(
              color: SystemColors.black), // 선택된 텍스트 스타일
          unselectedLabelStyle: OneLineTextStyles.Medium10.copyWith(
              color: SystemColors.gray700), // 선택되지 않은 텍스트 스타일
          onTap: (index) {
            if (index == 4) {
              ShowAddClothesBottomSheet(context, false);
            } else {
              _onItemTapped(index);
            }
          },
        ),
      ),
    );
  }
}
