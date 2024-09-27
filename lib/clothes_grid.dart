import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/add_clothes.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/utils/custom_floating_action_button_location.dart';
import 'package:uuid/uuid.dart';

class ClothesGrid extends StatefulWidget {
  final List<Clothes> clothesList;
  final bool isOnboarding;

  ClothesGrid({
    required this.clothesList,
    required this.isOnboarding,
  });

  @override
  _ClothesGridState createState() => _ClothesGridState();
}

class _ClothesGridState extends State<ClothesGrid> {
  ClothesDraftProvider? draftProvider;
  ClothesUpdateProvider? updateProvider;
  List<ClothesFamily> clothesWithDraft = [];

  List<DrawnLine> lines = [];
  Color clothesColor = Colors.transparent;
  DrawableRoot? svgBgRoot;
  DrawableRoot? svgLineRoot;

  late Map<int, bool> selected;
  static const int columnCount = 4;

  Widget _buildFloatingActionButton() {
    int selectedCount =
        selected.values.where((isSelected) => isSelected).length;
    return FloatingActionButton.extended(
      onPressed: () async {
        var selectedIds = selected.entries
            .where(
              (it) => it.value == true,
            )
            .map(
              (it) => it.key,
            );
        await ClothesRepository().addClothesList(selectedIds
            .map((it) => widget.clothesList.firstWhere(
                  (e) => e.id == it,
                ))
            .toSet());
        // 플로팅 버튼 클릭 시의 동작
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      },
      backgroundColor: Colors.black,
      label: Text(
        '총 $selectedCount개 선택',
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(Icons.arrow_forward, color: Colors.white),
    );
  }

  @override
  void initState() {
    super.initState();
    selected = {for (var clothes in widget.clothesList) clothes.id!: false};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 여기서 Provider에 접근
    setState(() {
      draftProvider = Provider.of<ClothesDraftProvider>(context);
      updateProvider = Provider.of<ClothesUpdateProvider>(context);
    });
  }

  int getClothesListLength() {
    return (draftProvider?.currentDraft == null ? 0 : 1) +
        widget.clothesList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(8.0),
        itemCount: ((getClothesListLength()) / columnCount).ceil(),
        itemBuilder: (context, index) {
          int start = index * columnCount;
          int end = (start + columnCount) < getClothesListLength()
              ? start + columnCount
              : getClothesListLength();

          print(
              "updateProvider?.currentClothes: ${updateProvider?.currentClothes?.color}");
          final clothesList = widget.clothesList
              .map((e) => updateProvider?.currentClothes?.id == e.id
                  ? updateProvider!.currentClothes!
                  : e)
              .toList();
          List<ClothesFamily> rowClothes =
              ((draftProvider?.currentDraft != null)
                  ? (index == 0)
                      ? [
                          draftProvider!.currentDraft!,
                          ...clothesList.sublist(start, end - 1)
                        ]
                      : clothesList.sublist(start - 1, end - 1)
                  : widget.clothesList.sublist(start, end));

          return Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildClothesCardRow(context, rowClothes)),
          );
        },
      ),
      floatingActionButton:
          widget.isOnboarding ? _buildFloatingActionButton() : null,
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.endFloat, // 기본 위치를 기준으로
        offsetX: -20.0, // X축 위치를 오른쪽으로 이동
      ),
    );
  }

  List<Widget> _buildClothesCardRow(
      BuildContext context, List<ClothesFamily> rowClothes) {
    List<Widget> list = rowClothes.map((clothes) {
      if (clothes is Clothes) {
        return _buildClothesCard(
            context, clothes, selected[clothes.id] ?? false);
      } else if (clothes is ClothesDraft) {
        return _buildClothesDraftCard(context, clothes);
      } else {
        throw Error();
      }
    }).toList();
    int listDiff = columnCount - list.length;

    for (int i = 0; i < listDiff; i++) {
      list.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    }

    list.insert(0, SvgPicture.asset("assets/icons/LeftCloset.svg"));
    list.add(SvgPicture.asset("assets/icons/RightCloset.svg"));
    return list;
  }

  Widget _buildClothesCard(
      BuildContext context, Clothes clothes, bool isSelected) {
    return GestureDetector(
        onTap: () => {
              widget.isOnboarding
                  ? setState(() {
                      selected[clothes.id!] = !selected[clothes.id]!;
                    })
                  : showClothesOptionsBottomSheet(
                      context, clothes, updateProvider)
            },
        child: Column(children: [
          Stack(alignment: Alignment.topCenter, children: [
            SvgPicture.asset("assets/icons/MiddleCloset.svg"),
            Positioned(
                top: 17, child: SvgPicture.asset("assets/icons/hanger.svg")),
            Positioned(
                top: 30,
                child: ClothesItem(
                    clothes: clothes, key: ValueKey(ValueKey(Uuid().v4())))),
            if (isSelected)
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
          ]),
          SizedBox(
            height: 8,
          ),
          Text(clothes.name,
              style: OneLineTextStyles.SemiBold10.copyWith(
                  color: SystemColors.gray800)),
          SizedBox(
            height: 8,
          ),
        ]));
  }

  Widget _buildClothesDraftCard(
    BuildContext context,
    ClothesDraft clothes,
  ) {
    return GestureDetector(
        child: Column(children: [
      Stack(alignment: Alignment.center, children: [
        SvgPicture.asset("assets/icons/MiddleCloset.svg"),
        Positioned(top: 17, child: SvgPicture.asset("assets/icons/hanger.svg")),
        if (clothes.primaryCategoryId == null)
          Positioned(
              top: 19, child: SvgPicture.asset("assets/icons/NewClothes.svg"))
        else
          Positioned(
              top: 30,
              child: ClothesDraftItem(
                  clothesDraft: clothes, key: ValueKey(Uuid().v4()))),
      ]),
      SizedBox(
        height: 8,
      ),
      Text(clothes.name ?? "",
          style: OneLineTextStyles.SemiBold10.copyWith(
              color: SystemColors.gray800)),
      SizedBox(
        height: 8,
      ),
    ]));
  }
}

void showClothesOptionsBottomSheet(BuildContext context, Clothes clothes,
    ClothesUpdateProvider? updateProvider) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text('정보 수정하기'),
              onTap: () {
                Navigator.pop(context);

                // 정보 수정 기능
                updateProvider!.set(clothes);
                ShowAddClothesBottomSheet(context, true);
              },
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('메모 남기기'),
              onTap: () {
                // 메모 남기기 기능
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('좋아하는 옷 OFF'),
              onTap: () {
                // 좋아하는 옷 기능
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('삭제하기', style: TextStyle(color: Colors.red)),
              onTap: () {
                // 삭제 기능
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

class ClothesItem extends StatefulWidget {
  final Clothes clothes;
  const ClothesItem({Key? key, required this.clothes}) : super(key: key);

  @override
  _ClothesItemState createState() => _ClothesItemState();
}

class _ClothesItemState extends State<ClothesItem> {
  List<DrawnLine> lines = [];
  Color clothesColor = Colors.transparent;
  DrawableRoot? svgBgRoot;
  DrawableRoot? svgLineRoot;
  ClothesUpdateProvider? updateProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final updateProvider =
          Provider.of<ClothesUpdateProvider>(context, listen: false);
      final clothesToUpdate = updateProvider.currentClothes;
      setState(() {
        if (clothesToUpdate != null) {
          lines = clothesToUpdate.drawLines;
          clothesColor = clothesToUpdate.color;
          SecondCategory secondCategory = secondCategories.firstWhere(
              (element) => element.id == clothesToUpdate.secondaryCategoryId);
          ClothesDetails clothesDetails = clothesToUpdate.details;
          _loadDrawableRoot(clothesDetails, secondCategory);
        } else {
          lines = widget.clothes.drawLines;
          clothesColor = widget.clothes.color;
          SecondCategory secondCategory = secondCategories.firstWhere(
              (element) => element.id == widget.clothes.secondaryCategoryId);
          ClothesDetails clothesDetails = widget.clothes.details;
          _loadDrawableRoot(clothesDetails, secondCategory);
        }
      });
    });
  }

  Future<void> _loadDrawableRoot(
      ClothesDetails clothesDetails, SecondCategory secondCategory) async {
    final String svgBgString = await rootBundle.loadString(
        "assets/images/clothes/bg/${secondCategory.code}_${clothesDetails.neckline.name}_${clothesDetails.topLength.name}_${clothesDetails.sleeveLength.name}.svg");
    final String svgLineString = await rootBundle.loadString(
        "assets/images/clothes/line/${secondCategory.code}_${clothesDetails.neckline.name}_${clothesDetails.topLength.name}_${clothesDetails.sleeveLength.name}.svg");
    DrawableRoot bgDrawableRoot =
        await svg.fromSvgString(svgBgString, svgBgString);
    DrawableRoot lineDrawableRoot =
        await svg.fromSvgString(svgLineString, svgLineString);
    setState(() {
      svgBgRoot = bgDrawableRoot;
      svgLineRoot = lineDrawableRoot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (svgBgRoot != null)
          CustomPaint(
            size: Size(
                svgBgRoot!.viewport.width / 2, svgBgRoot!.viewport.height / 2),
            painter: SvgBgPainter(svgBgRoot!, clothesColor, 0.5),
          ),
        if (svgBgRoot != null)
          CustomPaint(
            size: Size(
                svgBgRoot!.viewport.width / 2, svgBgRoot!.viewport.height / 2),
            painter: SvgLinePainter(svgLineRoot!, 0.5),
          ),
        if (svgBgRoot != null)
          CustomPaint(
            size: Size(
                svgBgRoot!.viewport.width / 2, svgBgRoot!.viewport.height / 2),
            painter: DrawingPainter(lines, svgBgRoot, 0.5),
          ),
      ],
    );
  }
}

class ClothesDraftItem extends StatefulWidget {
  final ClothesDraft clothesDraft;
  const ClothesDraftItem({Key? key, required this.clothesDraft})
      : super(key: key);

  @override
  _ClothesDraftItemState createState() => _ClothesDraftItemState();
}

class _ClothesDraftItemState extends State<ClothesDraftItem> {
  List<DrawnLine> lines = [];
  Color clothesColor = Colors.transparent;
  DrawableRoot? svgBgRoot;
  DrawableRoot? svgLineRoot;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        lines = widget.clothesDraft.drawLines ?? [];
        clothesColor = widget.clothesDraft.color ?? Colors.white;
        SecondCategory secondCategory = secondCategories
                .where((element) =>
                    element.id == widget.clothesDraft.secondaryCategoryId)
                .firstOrNull ??
            secondCategories[0];
        ClothesDetails clothesDetails = widget.clothesDraft.details ??
            ClothesDetails(
                topLength: secondCategory.topLengths[0],
                sleeveLength: secondCategory.sleeveLengths[0],
                neckline: secondCategory.necklines[0]);
        _loadDrawableRoot(clothesDetails, secondCategory);
      });
    });
  }

  Future<void> _loadDrawableRoot(
      ClothesDetails clothesDetails, SecondCategory secondCategory) async {
    final String svgBgString = await rootBundle.loadString(
        "assets/images/clothes/bg/${secondCategory.code}_${clothesDetails.neckline.name}_${clothesDetails.topLength.name}_${clothesDetails.sleeveLength.name}.svg");
    final String svgLineString = await rootBundle.loadString(
        "assets/images/clothes/line/${secondCategory.code}_${clothesDetails.neckline.name}_${clothesDetails.topLength.name}_${clothesDetails.sleeveLength.name}.svg");
    DrawableRoot bgDrawableRoot =
        await svg.fromSvgString(svgBgString, svgBgString);
    DrawableRoot lineDrawableRoot =
        await svg.fromSvgString(svgLineString, svgLineString);
    setState(() {
      svgBgRoot = bgDrawableRoot;
      svgLineRoot = lineDrawableRoot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (svgBgRoot != null)
          CustomPaint(
            size: Size(
                svgBgRoot!.viewport.width / 2, svgBgRoot!.viewport.height / 2),
            painter: SvgBgPainter(svgBgRoot!, clothesColor, 0.5),
          ),
        if (svgBgRoot != null)
          CustomPaint(
            size: Size(
                svgBgRoot!.viewport.width / 2, svgBgRoot!.viewport.height / 2),
            painter: SvgLinePainter(svgLineRoot!, 0.5),
          ),
        if (svgBgRoot != null)
          CustomPaint(
            size: Size(
                svgBgRoot!.viewport.width / 2, svgBgRoot!.viewport.height / 2),
            painter: DrawingPainter(lines, svgBgRoot, 0.5),
          ),
      ],
    );
  }
}
