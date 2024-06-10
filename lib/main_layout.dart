import 'package:flutter/material.dart';
import 'package:ttal_kkak/main_page.dart';

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
      body: IndexedStack(
        index: _selectedIndex,
        children: [MainPage(), MainPage(), MainPage(), MainPage(), MainPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: '내 옷장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            label: '코디',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '추가',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange, // 선택된 아이템 색상
        unselectedItemColor: Colors.black, // 선택되지 않은 아이템 색상
        selectedLabelStyle: TextStyle(fontSize: 14), // 선택된 텍스트 스타일
        unselectedLabelStyle: TextStyle(fontSize: 14), // 선택되지 않은 텍스트 스타일
        onTap: _onItemTapped,
      ),
    );
  }
}
