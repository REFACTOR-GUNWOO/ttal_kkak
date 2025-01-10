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
import 'package:ttal_kkak/common/common_bottom_sheet.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/update_bottom_sheet.dart';
import 'package:ttal_kkak/utils/custom_floating_action_button_location.dart';
import 'package:uuid/uuid.dart';

class ClothesGrid extends StatefulWidget {
  final List<Clothes> clothesList;
  final bool isOnboarding;
  final VoidCallback onReload;

  ClothesGrid({
    required this.clothesList,
    required this.isOnboarding,
    required this.onReload,
  });

  @override
  _ClothesGridState createState() => _ClothesGridState();
}

class _ClothesGridState extends State<ClothesGrid> {
  ClothesDraftProvider? draftProvider;
  ClothesUpdateProvider? updateProvider;

  List<DrawnLine> lines = [];
  Color clothesColor = Colors.transparent;
  DrawableRoot? svgBgRoot;
  DrawableRoot? svgLineRoot;

  late Map<int, bool> selected;
  static const int columnCount = 4;

  Widget _buildFloatingActionButton() {
    int selectedCount =
        selected.values.where((isSelected) => isSelected).length;

    return FloatingActionButtonWidget(
      selectedCount: selectedCount,
      onPressed: () async {
        var selectedIds = selected.entries
            .where((it) => it.value == true)
            .map((it) => it.key);

        await ClothesRepository().addClothesList(selectedIds
            .map((it) => widget.clothesList.firstWhere((e) => e.id == it))
            .toSet());

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      },
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
        body: getClothesListLength() != 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(8.0),
                itemCount: ((getClothesListLength()) / columnCount).ceil(),
                itemBuilder: (context, index) {
                  int start = index * columnCount;
                  int end = (start + columnCount) < getClothesListLength()
                      ? start + columnCount
                      : getClothesListLength();

                  print(
                      "updateProvider?.currentClothes: ${updateProvider?.currentClothes?.id}");
                  final clothesList = widget.clothesList
                      .map((e) => updateProvider?.currentClothes?.id == e.id &&
                              updateProvider?.currentClothes != null
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

                  return Padding(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildClothesCardRow(context, rowClothes)),
                    ),
                    padding: EdgeInsets.only(bottom: 32),
                  );
                },
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(8.0),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildEmptyRow()),
                  );
                },
              ),
        floatingActionButton: AnimatedSwitcher(
          duration: Duration(milliseconds: 0), // 애니메이션 시간을 0으로 설정
          child: widget.isOnboarding &&
                  selected.values.where((isSelected) => isSelected).isNotEmpty
              ? _buildFloatingActionButton()
              : null,
        ));
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

  List<Widget> _buildEmptyRow() {
    List<Widget> list = [];
    for (int i = 0; i < columnCount; i++) {
      list.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    }
    list.insert(0, SvgPicture.asset("assets/icons/LeftCloset.svg"));
    list.add(SvgPicture.asset("assets/icons/RightCloset.svg"));

    return list;
  }

  void showClothesOptionsBottomSheet(BuildContext context, Clothes clothes,
      ClothesUpdateProvider? updateProvider) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return UpdateBottomSheet(
          onReload: () => widget.onReload(),
          clothes: clothes,
          updateProvider: updateProvider,
        );
      },
    );
  }

  Widget _buildClothesCard(
      BuildContext context, Clothes clothes, bool isSelected) {
    FirstCategory firstCategory = firstCategories
        .firstWhere((element) => element.id == clothes.primaryCategoryId);
    SecondCategory secondCategory = secondCategories
        .firstWhere((element) => element.id == clothes.secondaryCategoryId);
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
                top: firstCategory.hangerPosition,
                child: SvgPicture.asset(firstCategory.hangerUrl)),
            Positioned(
                top: secondCategory.clothesTopPosition,
                bottom: secondCategory.clothesBottomPosition,
                child: ClothesItem(
                    clothes: clothes, key: ValueKey(ValueKey(Uuid().v4())))),
            if (isSelected)
              Positioned(
                top: 40,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.orange,
                  size: 30,
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
    List<Widget> stackList = [];
    stackList.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    if (clothes.primaryCategoryId == null) {
      stackList.add(Positioned(
          top: 19, child: SvgPicture.asset("assets/icons/NewClothes.svg")));
    } else {
      FirstCategory? firstCategory = firstCategories
          .where((element) => element.id == clothes.primaryCategoryId)
          .firstOrNull;
      SecondCategory? secondCategory = secondCategories
          .where((element) => element.id == clothes.secondaryCategoryId)
          .firstOrNull;
      if (firstCategory != null) {
        stackList.add(Positioned(
            top: firstCategory.hangerPosition,
            child: SvgPicture.asset(firstCategory.hangerUrl)));
      }
      if (secondCategory != null) {
        stackList.add(Positioned(
            top: secondCategory.clothesTopPosition,
            bottom: secondCategory.clothesBottomPosition,
            child: ClothesDraftItem(
                clothesDraft: clothes, key: ValueKey(Uuid().v4()))));
      }
    }
    return GestureDetector(
        child: Column(children: [
      Stack(alignment: Alignment.center, children: stackList),
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
  DrawableRoot? svgDecoRoot;
  String? svgDecoUrl;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeClothesData();
    });
  }

  Future<void> _initializeClothesData() async {
    lines = widget.clothes.drawLines;
    clothesColor = widget.clothes.color;

    SecondCategory secondCategory = secondCategories.firstWhere(
        (element) => element.id == widget.clothes.secondaryCategoryId);

    ClothesDetails clothesDetails = widget.clothes.details;

    // SVG 데이터를 비동기적으로 불러오고, 완료된 후 상태 업데이트
    await _loadDrawableRoot(clothesDetails, secondCategory);

    if (mounted) {
      setState(() {
        svgBgRoot = svgBgRoot;
        svgLineRoot = svgLineRoot;
      });
    }
  }

  Future<void> _loadDrawableRoot(
      ClothesDetails clothesDetails, SecondCategory secondCategory) async {
    List<ClothesDetail> details = clothesDetails.details;

    // 카테고리 우선순위에 따라 정렬
    details.sort((a, b) {
      return b.toString().compareTo(a.toString());
    });

    var svgBgUrl =
        "assets/images/clothes/bg/${secondCategory.code}${details.map((e) => '_${e.name}').join()}.svg";
    var svgLineUrl =
        "assets/images/clothes/line/${secondCategory.code}${details.map((e) => '_${e.name}').join()}.svg";
    if (secondCategory.hasDecorationLayer) {
      svgDecoUrl =
          "assets/images/clothes/deco/${secondCategory.code}${details.map((e) => '_${e.name}').join()}.svg";
    }

    if (svgBgRoot == null) {
      final String svgBgString = await rootBundle.loadString(svgBgUrl);
      svgBgRoot = await svg.fromSvgString(svgBgString, svgBgString);
    }

    if (svgLineRoot == null) {
      final String svgLineString = await rootBundle.loadString(svgLineUrl);
      svgLineRoot = await svg.fromSvgString(svgLineString, svgLineString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            if (svgBgRoot != null)
              CustomPaint(
                size:
                    Size(svgBgRoot!.viewport.width, svgBgRoot!.viewport.height),
                painter: SvgBgPainter(svgBgRoot!, clothesColor, 1.0),
              ),
            if (svgDecoUrl != null) SvgPicture.asset(svgDecoUrl!),
            if (lines.isNotEmpty)
              CustomPaint(
                size:
                    Size(svgBgRoot!.viewport.width, svgBgRoot!.viewport.height),
                painter: DrawingPainter(lines, svgBgRoot, 1),
              ),
            if (svgBgRoot != null)
              CustomPaint(
                size:
                    Size(svgBgRoot!.viewport.width, svgBgRoot!.viewport.height),
                painter: SvgLinePainter(
                    svgLineRoot!,
                    1.0,
                    1.0,
                    clothesColor == Color(0xFF282828)
                        ? SystemColors.gray900
                        : SystemColors.black),
              ),
          ],
        ));
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
      if (!mounted) return;
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
                details:
                    secondCategory.details.map((e) => e.details[0]).toList());
        _loadDrawableRoot(clothesDetails, secondCategory);
      });
    });
  }

  Future<void> _loadDrawableRoot(
      ClothesDetails clothesDetails, SecondCategory secondCategory) async {
    List<ClothesDetail> details = clothesDetails.details;

    // 카테고리 우선순위에 따라 정렬
    details.sort((a, b) {
      return b.toString().compareTo(a.toString());
    });
    var svgBgUrl =
        "assets/images/clothes/bg/${secondCategory.code}${details.map((e) => '_${e.name}').join()}.svg";
    var svgLineUrl =
        "assets/images/clothes/line/${secondCategory.code}${details.map((e) => '_${e.name}').join()}.svg";

    final String svgBgString = await rootBundle.loadString(svgBgUrl);

    final String svgLineString = await rootBundle.loadString(svgLineUrl);
    DrawableRoot bgDrawableRoot =
        await svg.fromSvgString(svgBgString, svgBgString);
    DrawableRoot lineDrawableRoot =
        await svg.fromSvgString(svgLineString, svgLineString);
    if (!mounted) return; // 위젯이 제거된 경우 작업 중단

    setState(() {
      svgBgRoot = bgDrawableRoot;
      svgLineRoot = lineDrawableRoot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter, // Stack 내에서 모든 위젯을 중앙 정렬

      children: [
        if (svgBgRoot != null)
          CustomPaint(
            size: Size(svgBgRoot!.viewport.width, svgBgRoot!.viewport.height),
            painter: SvgBgPainter(svgBgRoot!, clothesColor, 1.0),
          ),
        if (svgBgRoot != null)
          CustomPaint(
            size: Size(svgBgRoot!.viewport.width, svgBgRoot!.viewport.height),
            painter: SvgLinePainter(
                svgLineRoot!,
                1.0,
                1.0,
                clothesColor == Color(0xFF282828)
                    ? SystemColors.gray900
                    : SystemColors.black),
          ),
      ],
    );
  }
}

class FloatingActionButtonWidget extends StatefulWidget {
  final int selectedCount;
  final VoidCallback onPressed;

  FloatingActionButtonWidget({
    required this.selectedCount,
    required this.onPressed,
  });

  @override
  _FloatingActionButtonWidgetState createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState
    extends State<FloatingActionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        isExtended: true,
        enableFeedback: false,
        elevation: 0,
        onPressed: widget.onPressed,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 모서리 둥글게
        ),
        label: Row(
          children: [
            Text(
              '총 ${widget.selectedCount}개 선택',
              style: OneLineTextStyles.Medium14.copyWith(
                  color: SystemColors.white),
            ),
            SizedBox(width: 8), // 텍스트와 아이콘 사이 간격
            SvgPicture.asset('assets/icons/arrow_right.svg',
                color: SystemColors.white)
          ],
        ));
  }
}
