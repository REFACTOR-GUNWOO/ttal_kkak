import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody4 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody4({super.key, required this.onNextStep});

  @override
  _ClothesDetailSettingsState createState() => _ClothesDetailSettingsState();

  @override
  String getTitle() {
    return "옷 상세설정";
  }
}

class _ClothesDetailSettingsState extends State<BottomSheetBody4> {
  TopLength _selectedLength = TopLength.long;
  SleeveLength _selectedSleeve = SleeveLength.short;
  Neckline _selectedNeckline = Neckline.round;
  bool _isLengthDropdownVisible = false;
  bool _isSleeveDropdownVisible = false;
  bool _isNecklineDropdownVisible = false;
  List<TopLength> topLengthOptions = [TopLength.long];
  List<SleeveLength> sleeveLengthOptions = [SleeveLength.short];
  List<Neckline> necklineOptions = [Neckline.round];
  late ClothesDraftProvider provider;

  @override
  void initState() {
    print("_AddClothesState");
    super.initState();
    setState(() {
      provider = Provider.of<ClothesDraftProvider>(context, listen: false);
      provider.loadDraftFromLocal();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ClothesDraft? draft = await ClothesDraftRepository().load();
      int? secondaryCategoryId = draft?.secondaryCategoryId;

      SecondCategory? secondCategory = secondaryCategoryId == null
          ? null
          : secondCategories.firstWhere((e) => e.id == secondaryCategoryId);

      setState(() {
        if (secondCategory != null) {
          topLengthOptions = secondCategory.topLengths;
          sleeveLengthOptions = secondCategory.sleeveLengths;
          necklineOptions = secondCategory.necklines;
        }

        ClothesDetails? details = draft?.details;
        _selectedLength = details?.topLength ?? topLengthOptions.first;
        _selectedSleeve = details?.sleeveLength ?? sleeveLengthOptions.first;
        _selectedNeckline = details?.neckline ?? necklineOptions.first;
        if (details == null) {
          save();
        }
      });
    });
  }

  void save() async {
    ClothesDraft? draft = await ClothesDraftRepository().load();
    if (draft != null) {
      draft.details = ClothesDetails(
          topLength: _selectedLength,
          sleeveLength: _selectedSleeve,
          neckline: _selectedNeckline);
      ClothesDraftRepository().save(draft);
      provider.updateDraft(draft);

      // widget.onNextStep();
      return;
    }
  }

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
            topLengthOptions,
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
            sleeveLengthOptions,
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
            necklineOptions,
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
    Descriptive? selectedValue,
    List<Descriptive> options,
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
                        '${selectedValue == null ? options.first.label : selectedValue.label} 적용됨',
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
                  Descriptive option = options[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        switch (title) {
                          case '상의 길이':
                            _selectedLength = option as TopLength;
                          case '팔 길이':
                            _selectedSleeve = option as SleeveLength;
                          case '넥 라인':
                            _selectedNeckline = option as Neckline;
                        }
                        save();
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
                        option.label,
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
