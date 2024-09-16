import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody5 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody5(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.draftProvider,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesDraftProvider draftProvider;
  final ClothesUpdateProvider updateProvider;

  @override
  _ColorSelectionGridState createState() => _ColorSelectionGridState();

  @override
  String getTitle() {
    return "옷 컬러";
  }
}

class _ColorSelectionGridState extends State<BottomSheetBody5> {
  Color _selectedColor = Colors.transparent;
  late ClothesDraftProvider provider;

  @override
  void initState() {
    super.initState();
    setState(() {
      provider = Provider.of<ClothesDraftProvider>(context, listen: false);
      provider.loadDraftFromLocal();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ClothesDraft? draft = await ClothesDraftRepository().load();

      setState(() {
        Color? color = draft?.color;
        if (color != null) {
          _selectedColor = color;
        }
      });
    });
  }

  void save() async {
    ClothesDraft? draft = await ClothesDraftRepository().load();
    if (draft != null) {
      draft.color = _selectedColor;
      ClothesDraftRepository().save(draft);
      provider.updateDraft(draft);
    }
  }

  final List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.grey,
    Colors.red[300]!,
    Colors.orange[300]!,
    Colors.yellow[300]!,
    Colors.green[300]!,
    Colors.blue[300]!,
    Colors.purple[300]!,
    Colors.pink[300]!,
    Colors.brown[300]!,
    Colors.grey[200]!,
    Colors.grey[300]!,
    Colors.grey[400]!,
    Colors.grey[500]!,
    Colors.grey[600]!,
    Colors.grey[700]!,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // 한 줄에 8개의 색상
          crossAxisSpacing: 10.0, // 색상 간의 수평 간격
          mainAxisSpacing: 10.0, // 색상 간의 수직 간격
          childAspectRatio: 1, // 정사각형 비율
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          Color color = colors[index];
          bool isSelected = color == _selectedColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
                save();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
