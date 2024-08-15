import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody4 extends StatefulWidget implements BottomSheetStep {
  @override
  _ClothesDetailSettingsState createState() => _ClothesDetailSettingsState();

  @override
  String getTitle() {
    return "옷 상세설정";
  }
}

class _ClothesDetailSettingsState extends State<BottomSheetBody4> {
  String _selectedLength = '중간길이';
  String _selectedSleeve = '반팔';
  String _selectedNeckline = '라운드넥';
  bool _isLengthDropdownVisible = false;
  bool _isSleeveDropdownVisible = false;
  bool _isNecklineDropdownVisible = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategorySection(
            '상의 길이',
            _selectedLength,
            ['중간길이', '짧은길이', '긴길이'],
            _isLengthDropdownVisible,
            () {
              setState(() {
                _isLengthDropdownVisible = !_isLengthDropdownVisible;
                _isSleeveDropdownVisible = false;
                _isNecklineDropdownVisible = false;
              });
            },
          ),
          SizedBox(height: 24),
          _buildCategorySection(
            '팔 길이',
            _selectedSleeve,
            ['반팔', '긴팔', '중간팔', '민소매'],
            _isSleeveDropdownVisible,
            () {
              setState(() {
                _isSleeveDropdownVisible = !_isSleeveDropdownVisible;
                _isLengthDropdownVisible = false;
                _isNecklineDropdownVisible = false;
              });
            },
          ),
          SizedBox(height: 24),
          _buildCategorySection(
            '넥 라인',
            _selectedNeckline,
            ['브이넥', '라운드넥', '스퀘어넥'],
            _isNecklineDropdownVisible,
            () {
              setState(() {
                _isNecklineDropdownVisible = !_isNecklineDropdownVisible;
                _isLengthDropdownVisible = false;
                _isSleeveDropdownVisible = false;
              });
            },
          ),
        ],
      ),
    ));
  }

  Widget _buildCategorySection(
    String title,
    String selectedValue,
    List<String> options,
    bool isDropdownVisible,
    VoidCallback toggleDropdown,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: OneLineTextStyles.ExtraBold16.copyWith(
                        color: SystemColors.black),
                  ),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.orange, size: 16),
                      SizedBox(width: 2),
                      Text(
                        '$selectedValue 적용됨',
                        style: OneLineTextStyles.Medium12.copyWith(
                            color: SignatureColors.orange400),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 8),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0), // 모서리 둥글게
                  color: SystemColors.black, // 배경색 설정
                ),
                child: IconButton(
                  icon: isDropdownVisible
                      ? SvgPicture.asset("assets/icons/arrow_up.svg")
                      : SvgPicture.asset("assets/icons/arrow_down.svg"),
                  iconSize: 14,
                  onPressed: toggleDropdown,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height:
                isDropdownVisible ? (options.length / 3).ceil() * 50.0 : 0.0,
            curve: Curves.easeInOut,
            child: Visibility(
              visible: isDropdownVisible,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(), // 그리드 뷰 내에서 스크롤 비활성화
                shrinkWrap: true, // 그리드 뷰가 컨테이너에 맞게 축소되도록 함
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 한 줄에 3개의 아이템
                  crossAxisSpacing: 10.0, // 아이템 간의 수평 간격
                  mainAxisSpacing: 10.0, // 아이템 간의 수직 간격
                  childAspectRatio: 3 / 1, // 가로 세로 비율
                ),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  String option = options[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        switch (title) {
                          case '상의 길이':
                            _selectedLength = option;
                            break;
                          case '팔 길이':
                            _selectedSleeve = option;
                            break;
                          case '넥 라인':
                            _selectedNeckline = option;
                            break;
                        }
                        toggleDropdown(); // 옵션 선택 후 드롭다운 닫기
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: selectedValue == option
                              ? Colors.black
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: selectedValue == option
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
