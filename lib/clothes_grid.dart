import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/common/custom_decoder.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/update_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

class ClothesGrid extends StatefulWidget {
  final List<Clothes> clothesList;
  final bool isOnboarding;
  final VoidCallback onReload;

  const ClothesGrid({
    super.key,
    required this.clothesList,
    required this.isOnboarding,
    required this.onReload,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ClothesGridState createState() => _ClothesGridState();
}

class _ClothesGridState extends State<ClothesGrid>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  List<DrawnLine> lines = [];
  Color clothesColor = Colors.transparent;
  DrawableRoot? svgBgRoot;
  DrawableRoot? svgLineRoot;

  int columnCount(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 360) {
      return 4;
    }
    return ((MediaQuery.of(context).size.width - 80) / 78).floor();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  int getClothesListLength() {
    return widget.clothesList.length;
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = this.columnCount(context);
    return SliverPadding(
      padding: EdgeInsets.all(0),
      sliver: getClothesListLength() != 0
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  int start = index * columnCount;
                  int end = (start + columnCount) < getClothesListLength()
                      ? start + columnCount
                      : getClothesListLength();

                  List<Clothes> rowClothes =
                      widget.clothesList.sublist(start, end);

                  return Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildClothesCardRow(context, rowClothes),
                      ),
                    ),
                  );
                },
                childCount: ((getClothesListLength()) / columnCount).ceil(),
              ),
            )
          : SliverFillRemaining(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildEmptyRow(),
                    ),
                  );
                },
              ),
            ),
    );
  }

  List<Widget> _buildClothesCardRow(
      BuildContext context, List<Clothes> rowClothes) {
    List<Widget> list = [];
    rowClothes.map((clothes) {
      list.add(ClothesCard(
          clothes: clothes,
          isSelected: false,
          isOnboarding: widget.isOnboarding,
          onTap: () => {showClothesOptionsBottomSheet(context, clothes)}));
    }).toList();
    int listDiff = columnCount(context) - list.length;

    for (int i = 0; i < listDiff; i++) {
      list.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    }

    list.insert(0, SvgPicture.asset("assets/icons/LeftCloset.svg"));
    list.add(SvgPicture.asset("assets/icons/RightCloset.svg"));
    return list;
  }

  List<Widget> _buildEmptyRow() {
    List<Widget> list = [];
    for (int i = 0; i < columnCount(context); i++) {
      list.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    }
    list.insert(0, SvgPicture.asset("assets/icons/LeftCloset.svg"));
    list.add(SvgPicture.asset("assets/icons/RightCloset.svg"));

    return list;
  }

  void showClothesOptionsBottomSheet(
    BuildContext context,
    Clothes clothes,
  ) {
    showModalBottomSheet(
      context: context,
      elevation: 10,
      barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        HapticFeedback.heavyImpact();
        return UpdateBottomSheet(
          onReload: () => widget.onReload(),
          clothes: clothes,
        );
      },
    );
  }
}

class ClothesCard extends StatefulWidget {
  final Clothes clothes;
  final bool isSelected;
  final bool isOnboarding;
  final VoidCallback onTap;

  ClothesCard({
    required this.clothes,
    required this.isSelected,
    required this.isOnboarding,
    required this.onTap,
  });

  @override
  _ClothesCardState createState() => _ClothesCardState();
}

class _ClothesCardState extends State<ClothesCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _clickCount = 0;

  void _toggleAnimation() {
    setState(() {
      _clickCount++;
      if (_clickCount % 2 == 1) {
        // 홀수 클릭: 앞으로 재생
        _controller.forward(from: 0.0);
      } else {
        // 짝수 클릭: 뒤로 재생
        _controller.reverse(from: 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Clothes clothes = widget.clothes;

    List<Widget> stackList = [];
    stackList.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    if (clothes.isDraft) {
      stackList.add(Positioned(
          top: 12, child: SvgPicture.asset("assets/icons/hanger.svg")));
      stackList.add(Positioned(
          top: 12, child: SvgPicture.asset("assets/icons/NewClothes.svg")));
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
            child: ClothesItem(
                clothes: clothes,
                key: clothes.id == null
                    ? Key(Uuid().v4())
                    : Key(clothes.id.toString()))));
      }
    }

    if (widget.isOnboarding) {
      stackList.add(Positioned(
        top: 30,
        child: Lottie.asset(
          'assets/lotties/select_motion.lottie',
          decoder: customDecoder,
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
          },
        ),
      ));
    }

    FirstCategory firstCategory = firstCategories
        .firstWhere((element) => element.id == clothes.primaryCategoryId);
    SecondCategory secondCategory = secondCategories
        .firstWhere((element) => element.id == clothes.secondaryCategoryId);
    return GestureDetector(
        onTap: () =>
            {widget.onTap(), if (widget.isOnboarding) _toggleAnimation()},
        child: Column(children: [
          Stack(alignment: Alignment.topCenter, children: [
            ...stackList,
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
}

class ClothesItem extends StatefulWidget {
  final Clothes clothes;
  final double scale;
  const ClothesItem({
    Key? key,
    required this.clothes,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  _ClothesItemState createState() => _ClothesItemState();
}

class _ClothesItemState extends State<ClothesItem> {
  List<DrawnLine> lines = [];
  ClothesColor clothesColor = ClothesColor.white;
  DrawableRoot? svgBgRoot;
  DrawableRoot? svgLineRoot;
  DrawableRoot? svgDecoRoot;
  String? svgDecoUrl;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('ClothesItem initState');
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
    final stopwatch = Stopwatch()..start();

    List<ClothesDetail> details = clothesDetails.details;

    // 세부 정보 정렬 시간 측정
    stopwatch.reset();
    details.sort((a, b) {
      return b.toString().compareTo(a.toString());
    });
    print('_loadDrawableRoot 세부 정보 정렬 시간: ${stopwatch.elapsedMilliseconds}ms');

    // SVG URL 생성 시간 측정
    stopwatch.reset();
    var svgBgUrl =
        "assets/images/clothes/bg/${secondCategory.code}${details.map((e) => '_${e.name}').join()}.svg";
    var svgLineUrl =
        "assets/images/clothes/line/${secondCategory.code}${details.map((e) => '_${e.name}').join()}.svg";
    if (secondCategory.hasDecorationLayer) {
      svgDecoUrl =
          "assets/images/clothes/deco/${secondCategory.code}${details.map((e) => '_${e.name}').join()}.svg";
    }
    print(
        '_loadDrawableRoot SVG URL 생성 시간: ${stopwatch.elapsedMilliseconds}ms');

    // 배경 SVG 로드 시간 측정
    if (svgBgRoot == null) {
      stopwatch.reset();
      final String svgBgString = await rootBundle.loadString(svgBgUrl);
      print(
          '_loadDrawableRoot 배경 SVG 파일 로드 시간: ${stopwatch.elapsedMilliseconds}ms');

      stopwatch.reset();
      svgBgRoot = await svg.fromSvgString(svgBgString, svgBgString);
      print(
          '_loadDrawableRoot 배경 SVG 파싱 시간: ${stopwatch.elapsedMilliseconds}ms');
    }

    if (svgDecoRoot == null && svgDecoUrl != null) {
      stopwatch.reset();
      final String svgDecoString = await rootBundle.loadString(svgDecoUrl!);
      print(
          '_loadDrawableRoot 배경 SVG 파일 로드 시간: ${stopwatch.elapsedMilliseconds}ms');

      stopwatch.reset();
      svgDecoRoot = await svg.fromSvgString(svgDecoString, svgDecoString);
      print(
          '_loadDrawableRoot 배경 SVG 파싱 시간: ${stopwatch.elapsedMilliseconds}ms');
    }
    // 라인 SVG 로드 시간 측정
    if (svgLineRoot == null) {
      stopwatch.reset();
      final String svgLineString = await rootBundle.loadString(svgLineUrl);
      print(
          '_loadDrawableRoot 라인 SVG 파일 로드 시간: ${stopwatch.elapsedMilliseconds}ms');

      stopwatch.reset();
      svgLineRoot = await svg.fromSvgString(svgLineString, svgLineString);
      print(
          '_loadDrawableRoot 라인 SVG 파싱 시간: ${stopwatch.elapsedMilliseconds}ms');
    }

    stopwatch.stop();
    print(
        '_loadDrawableRoot 전체 _loadDrawableRoot 실행 시간: ${stopwatch.elapsedMilliseconds}ms');
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            if (svgBgRoot != null)
              CustomPaint(
                size: Size(svgBgRoot!.viewport.width * widget.scale,
                    svgBgRoot!.viewport.height * widget.scale),
                painter:
                    SvgBgPainter(svgBgRoot!, clothesColor.color, widget.scale),
              ),
            if (svgDecoUrl != null)
              CustomPaint(
                size: Size(svgBgRoot!.viewport.width * widget.scale,
                    svgBgRoot!.viewport.height * widget.scale),
                painter: SvgBgPainter(svgDecoRoot!, null, widget.scale),
              ),
            if (lines.isNotEmpty)
              CustomPaint(
                size: Size(svgBgRoot!.viewport.width * widget.scale,
                    svgBgRoot!.viewport.height * widget.scale),
                painter: DrawingPainter(lines, svgBgRoot, widget.scale),
              ),
            if (svgBgRoot != null)
              CustomPaint(
                size: Size(svgBgRoot!.viewport.width * widget.scale,
                    svgBgRoot!.viewport.height * widget.scale),
                painter: SvgLinePainter(
                    svgLineRoot!,
                    widget.scale,
                    widget.scale,
                    (clothesColor == ClothesColor.black ||
                            clothesColor == ClothesColor.lightBlack)
                        ? SystemColors.gray900
                        : SystemColors.black),
              ),
          ],
        ));
  }
}
