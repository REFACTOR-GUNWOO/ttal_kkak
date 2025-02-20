import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/custom_decoder.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/provider/onboarding_clothes_select_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:ttal_kkak/update_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

class OnboardingClothesGrid extends StatefulWidget {
  final List<Clothes> clothesList;
  final VoidCallback onReload;

  OnboardingClothesGrid({
    Key? key,
    required this.clothesList,
    required this.onReload,
  }) : super(key: key);

  @override
  _OnboardingClothesGridState createState() => _OnboardingClothesGridState();
}

class _OnboardingClothesGridState extends State<OnboardingClothesGrid>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  List<DrawnLine> lines = [];
  Color clothesColor = Colors.transparent;
  DrawableRoot? svgBgRoot;
  DrawableRoot? svgLineRoot;
  int columnCount(BuildContext context) {
    return ((MediaQuery.of(context).size.width - 80) / 78).floor();
  }

  Map<int, bool> selected = {};

  Widget _buildFloatingActionButton() {
    int selectedCount =
        selected.values.where((isSelected) => isSelected).length;

    return FloatingActionButtonWidget(
      selectedCount: selectedCount,
      onPressed: () async {        
        await Provider.of<OnboardingClothesSelectProvider>(context, listen: false)
            .migrate();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      },
    );
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
    setState(() {
      selected = Provider.of<OnboardingClothesSelectProvider>(context).selected;
    });

    int columnCount = this.columnCount(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: getClothesListLength() != 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(20.0),
                itemCount: ((getClothesListLength()) / columnCount).ceil(),
                itemBuilder: (context, index) {
                  int start = index * columnCount;
                  int end = (start + columnCount) < getClothesListLength()
                      ? start + columnCount
                      : getClothesListLength();

                  List<Clothes> rowClothes =
                      widget.clothesList.sublist(start, end);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildClothesCardRow(context, rowClothes)),
                    ),
                  );
                },
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(20.0),
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
          duration: const Duration(milliseconds: 0), // 애니메이션 시간을 0으로 설정
          child: selected.values.where((isSelected) => isSelected).isNotEmpty
              ? _buildFloatingActionButton()
              : null,
        ));
  }

  List<Widget> _buildClothesCardRow(
      BuildContext context, List<Clothes> rowClothes) {
    List<Widget> list = [];
    rowClothes.map((clothes) {
      list.add(ClothesCard(
          clothes: clothes,
          isSelected: selected[clothes.id] ?? false,
          isOnboarding: true,
          onTap: () => {
                {
                  print(clothes.id),
                  Provider.of<OnboardingClothesSelectProvider>(context,
                          listen: false)
                      .toggle(clothes),
                }
              }));
    }).toList();
    int columnCount = this.columnCount(context);
    int listDiff = columnCount - list.length;

    for (int i = 0; i < listDiff; i++) {
      list.add(SvgPicture.asset("assets/icons/MiddleCloset.svg"));
    }

    list.insert(0, SvgPicture.asset("assets/icons/LeftCloset.svg"));
    list.add(SvgPicture.asset("assets/icons/RightCloset.svg"));
    return list;
  }

  List<Widget> _buildEmptyRow() {
    int columnCount = this.columnCount(context);
    List<Widget> list = [];
    for (int i = 0; i < columnCount; i++) {
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
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
            child: ClothesItem(clothes: clothes, key: ValueKey(Uuid().v4()))));
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
      setState(() {
        svgBgRoot = svgBgRoot;
      });
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
      setState(() {
        svgDecoRoot = svgDecoRoot;
      });
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
      setState(() {
        svgLineRoot = svgLineRoot;
      });
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
                    (clothesColor == ClothesColor.Black ||
                            clothesColor == ClothesColor.LightBlack)
                        ? SystemColors.gray900
                        : SystemColors.black),
              ),
          ],
        ));
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
