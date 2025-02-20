import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/Category.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_5.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/common/common_bottom_sheet.dart';
import 'package:ttal_kkak/common/show_toast.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/provider/reload_home_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

import 'draft_clear_warning_dialog.dart';

class DetailDrawingPage extends StatefulWidget {
  @override
  _DetailDrawingPageState createState() => _DetailDrawingPageState();
  const DetailDrawingPage(
      {super.key, required this.isUpdate, required this.updateProvider});

  final bool isUpdate;
  final ClothesUpdateProvider updateProvider;
}

class _DetailDrawingPageState extends State<DetailDrawingPage> {
  List<DrawnLine> lines = [];
  List<DrawnLine> undoneLines = [];
  DrawnLine? currentLine;
  double brushWidth = 5.0;
  Color brushColor = colorContainers.first.colors.first;
  List<Color> brushColorColorGroup = colorContainers.first.colors;
  String _svgBgUrl = "";
  String _svgLineUrl = "";
  String? _svgDecoUrl = "";
  Color clothesColor = Colors.transparent;
  DrawableRoot? svgBgRoot;
  DrawableRoot? svgLineRoot;
  int _expandedIndex = -1;
  FirstCategory? firstCategory;
  double brushContainerHeight = 120;
  List<PencilInfo> pencilInfos = [
    PencilInfo(pencilSize: 10, width: 40),
    PencilInfo(pencilSize: 5, width: 26),
    PencilInfo(pencilSize: 2, width: 18)
  ];
  double clothesScale = 5.0;
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  bool _isErasing = false;
  final double minDistance = 1.0; // 손떨림 방지를 위한 최소 거리 설정
  bool _showScrollButtons = false;
  bool _isScaling = false; // 1. 확대 상태 추적 변수 추가
  late GestureArenaTeam _gestureTeam; // Gesture Arena Team 추가

  void _checkScrollButtons() {
    print("checkScrollButtons : ${_scrollController.offset}");
    print("checkScrollButtons : ${_scrollController.position.maxScrollExtent}");
    print("checkScrollButtons : ${_scrollController.hasClients}");
    setState(() {
      if (!_scrollController.hasClients) return;

      _showScrollButtons = _scrollController.position.maxScrollExtent > 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollButtons);
    _gestureTeam = GestureArenaTeam(); // GestureArenaTeam 생성

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Clothes? clothes = widget.updateProvider.currentClothes;
      _checkScrollButtons();
      _scrollController.animateTo(1,
          duration: Duration(milliseconds: 1), curve: Curves.easeOut);

      setState(() {
        firstCategory = firstCategories
            .firstWhere((element) => element.id == clothes!.primaryCategoryId);
        lines = clothes!.drawLines;
        clothesColor = clothes.color;
        SecondCategory secondCategory = secondCategories
            .firstWhere((element) => element.id == clothes.secondaryCategoryId);
        ClothesDetails clothesDetails = clothes.details!;
        _loadDrawableRoot(clothesDetails, secondCategory);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void startScrollUp() {
    _scrollTimer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      _scrollUpByLongPress();
    });
  }

  void startScrollDown() {
    _scrollTimer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      _scrollDownByLongPress();
    });
  }

  void _stopScrollTimer() {
    _scrollTimer?.cancel();
  }

  void _scrollUpByLongPress() {
    if (_scrollController.offset <= 0.0) {
      return;
    }

    _scrollController.animateTo(
      _scrollController.offset - 20, // 위로 20px 이동
      duration: Duration(milliseconds: 60),
      curve: Curves.easeOut,
    );
  }

  void _scrollDownByLongPress() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      return;
    }

    _scrollController.animateTo(
      _scrollController.offset + 20, // 위로 20px 이동
      duration: Duration(milliseconds: 60),
      curve: Curves.easeOut,
    );
  }

  void _scrollUpByTab() {
    if (_scrollController.offset <= 0.0) {
      return;
    }

    _scrollController.animateTo(
      _scrollController.offset - 20.0, // 위로 20px 이동
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _scrollDownByTab() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      return;
    }

    _scrollController.animateTo(
      _scrollController.offset + 20.0, // 아래로 20px 이동
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void save() async {
    final clothes = widget.updateProvider.currentClothes!;
    clothes.updateDrawlines(lines);
    await widget.updateProvider.update(clothes);
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return CommonBottomSheet(
              child: Column(children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text("펜 컬러", style: OneLineTextStyles.SemiBold16),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: ColorPalette(
                  colorContainers: colorContainers,
                  selectedColorGroup: brushColorColorGroup,
                  selectedColor: brushColor,
                  onColorSelected: (selectedColorGroup, selectedColor) {
                    setState(() {
                      print("setState");
                      brushColor = selectedColor;
                      brushColorColorGroup = selectedColorGroup;
                    });
                  }),
            ),
          ]));
        }).whenComplete(() {
      setState(() {}); // Ensure UI is updated after the color picker is closed
    });
  }

  void _selectPencil(int index) {
    _isErasing = false;
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = -1; // 클릭한 게 이미 확장된 상태면 축소
      } else {
        brushWidth = pencilInfos[index].pencilSize;
        _expandedIndex = index; // 클릭한 인덱스를 확장된 상태로 설정
      }
    });
  }

  void _selectErase() {
    setState(() {
      _expandedIndex = -1;
      if (!_isErasing) {
        brushWidth = 10;
        _isErasing = true;
      } else {
        _isErasing = false;
      }
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
        "assets/images/clothes/bg/${secondCategory.code + details.map((e) => "_" + e.name).join()}.svg";
    var svgLineUrl =
        "assets/images/clothes/line/${secondCategory.code + details.map((e) => "_" + e.name).join()}.svg";
    _svgDecoUrl =
        "assets/images/clothes/deco/${secondCategory.code + details.map((e) => "_" + e.name).join()}.svg";
    final String svgBgString = await rootBundle.loadString(svgBgUrl);
    final String svgLineString = await rootBundle.loadString(svgLineUrl);
    DrawableRoot bgDrawableRoot =
        await svg.fromSvgString(svgBgString, svgBgString);
    DrawableRoot lineDrawableRoot =
        await svg.fromSvgString(svgLineString, svgLineString);
    setState(() {
      svgBgRoot = bgDrawableRoot;
      svgLineRoot = lineDrawableRoot;
      _svgBgUrl = svgBgUrl;
      _svgLineUrl = svgLineUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignatureColors.begie200,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0, // 그림자 제거
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset('assets/icons/arrow_left.svg',
                              color: SystemColors.black))),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.all(10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => {
                      save(),
                      Provider.of<ClothesUpdateProvider>(context, listen: false)
                          .clear(),
                      Provider.of<ReloadHomeProvider>(context, listen: false)
                          .triggerReload(),
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainLayout()),
                      )
                    },
                    child: Text(
                      '저장',
                      style: OneLineTextStyles.SemiBold16.copyWith(
                          color: SignatureColors.orange400),
                    ),
                  ),
                ],
              ))),
      bottomNavigationBar: Container(
        height: brushContainerHeight,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0), // 양쪽 여백을 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    height: brushContainerHeight,
                    width: double.infinity,
                  ),
                  Container(
                    width: 200,
                    height: brushContainerHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...pencilInfos.asMap().entries.map((e) {
                          return Pencil(
                            color: brushColor,
                            width: e.value.width,
                            isExpanded: _expandedIndex == e.key,
                            onTap: () => _selectPencil(e.key),
                          );
                        }),
                        Eraser(
                          onTap: () => _selectErase(),
                          isExpanded: _isErasing,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 14,
                      right: 14,
                      child: GestureDetector(
                        onTap: () => _showColorPicker(context),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white, // 테두리 색상
                                width: 3.0, // 테두리 두께
                              ),
                              color: brushColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          width: 32,
                          height: 32,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(children: [
        GestureDetector(
            child: SingleChildScrollView(
                controller: _scrollController,
                physics: NeverScrollableScrollPhysics(),
                child: Padding(
                    padding: EdgeInsets.only(
                        top: firstCategory?.drawingPageTopPosition ?? 0,
                        bottom: 94),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        alignment:
                            Alignment.topCenter, // Stack 내에서 모든 위젯을 중앙 정렬
                        children: [
                          if (svgBgRoot != null)
                            CustomPaint(
                              size: Size(
                                  svgBgRoot!.viewport.width * clothesScale,
                                  svgBgRoot!.viewport.height * clothesScale),
                              painter: SvgBgPainter(
                                  svgBgRoot!, clothesColor, clothesScale),
                            ),
                          if (_svgDecoUrl != null)
                            SvgPicture.asset(
                              _svgDecoUrl!,
                              width: 190 * clothesScale / 3,
                            ),
                          if (svgBgRoot != null)
                            CustomPaint(
                              size: Size(
                                  svgBgRoot!.viewport.width * clothesScale,
                                  svgBgRoot!.viewport.height * clothesScale),
                              painter: SvgLinePainter(
                                  svgLineRoot!,
                                  clothesScale,
                                  2,
                                  (clothesColor == ClothesColor.Black ||
                                          clothesColor ==
                                              ClothesColor.LightBlack)
                                      ? SystemColors.gray900
                                      : SystemColors.black),
                            ),
                          if (svgBgRoot != null)
                            GestureDetector(
                              onScaleStart: (details) {
                                if (details.pointerCount >= 2) {
                                  setState(() {
                                    _isScaling = true;
                                    showToast("일러스트 확대 기능은 개발 중입니다");
                                  });
                                  return;
                                }
                                _startDrawing(details.localFocalPoint);
                              },
                              onScaleUpdate: (details) {
                                if (details.pointerCount >= 2) {
                                  // 🔹 핀치 줌 (확대/축소)
                                } else {
                                  // 🔹 팬 (이동)
                                  _updateDrawing(details.localFocalPoint);
                                }
                              },
                              onScaleEnd: (details) {
                                setState(() {
                                  _isScaling = false;
                                });
                                _endDrawing();
                              },
                              child: CustomPaint(
                                size: Size(
                                    svgBgRoot!.viewport.width * clothesScale,
                                    svgBgRoot!.viewport.height * clothesScale),
                                painter: DrawingPainter(
                                    lines, svgBgRoot, clothesScale),
                              ),
                            )
                        ],
                      ),
                    )))),
        _showScrollButtons
            ? Positioned(
                right: 20,
                top: 20,
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                              color: SignatureColors.begie500,
                              borderRadius: BorderRadius.circular(6)),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/arrow_up.svg",
                              width: 24,
                              height: 24,
                            ),
                          )),
                      onTap: () {
                        _scrollUpByTab();
                      },
                      onLongPress: () {
                        startScrollUp();
                      },
                      onLongPressEnd: (details) {
                        _stopScrollTimer();
                      },
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                              color: SignatureColors.begie500,
                              borderRadius: BorderRadius.circular(6)),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/arrow_down.svg",
                              width: 24,
                              height: 24,
                            ),
                          )),
                      onTap: () {
                        _scrollDownByTab();
                      },
                      onLongPress: () {
                        startScrollDown();
                      },
                      onLongPressEnd: (details) {
                        _stopScrollTimer();
                      },
                    ),
                  ],
                ))
            : Container(),
        Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DraftClearWarningDialog(
                                title: "드로잉 초기화",
                                description: "드로잉 정보가 모두 사라져요\n초기화 하시겠어요?",
                                draftFieldName: "",
                                onNextStep: () {
                                  showToast("초기화되었습니다");
                                  clear();
                                });
                          },
                        );
                      },
                      child: Row(children: [
                        SvgPicture.asset(
                          "assets/icons/retry.svg",
                          width: 13,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "초기화",
                          style: OneLineTextStyles.SemiBold16.copyWith(
                              color: SystemColors.black),
                        )
                      ]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SignatureColors.begie500,
                        elevation: 0,
                        maximumSize: Size(94, 44),
                        minimumSize: Size(94, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Container(
                      width: 96,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              undo();
                            },
                            child: SvgPicture.asset(
                              "assets/icons/left_curve_arrow.svg",
                              width: 18,
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              minimumSize: Size(44, 44),
                              maximumSize: Size(44, 44),
                              backgroundColor: SignatureColors.begie500,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              redo();
                            },
                            child: SvgPicture.asset(
                              "assets/icons/right_curve_arrow.svg",
                              width: 18,
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              minimumSize: Size(44, 44),
                              maximumSize: Size(44, 44),
                              backgroundColor: SignatureColors.begie500,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ))
      ]),
    );
  }

  void _startDrawing(Offset position) {
    if (_isScaling) return; // 2. 확대 중이면 드로잉 차단
    Offset localPosition = position * 3 / clothesScale;
    setState(() {
      currentLine = DrawnLine([localPosition], brushWidth,
          _isErasing ? Colors.transparent : brushColor);
      lines.add(currentLine!);
    });
  }

  void _updateDrawing(Offset position) {
    if (_isScaling) return; // 3. 확대 중이면 드로잉 업데이트 차단
    Offset localPosition = position * 3 / clothesScale;
    setState(() {
      if (currentLine != null &&
          (currentLine!.points.isEmpty ||
              (localPosition - currentLine!.points.last).distance >
                  minDistance)) {
        currentLine?.points.add(localPosition);
      }
    });
  }

  void _endDrawing() {
    setState(() {
      if (currentLine != null && currentLine!.points.length == 1) {
        currentLine?.points.add(currentLine!.points.first);
      }

      currentLine = null;
    });
  }

  void undo() {
    setState(() {
      if (lines.isNotEmpty) {
        undoneLines.add(lines.removeLast());
      }
    });
  }

  void redo() {
    if (undoneLines.isNotEmpty) {
      lines.add(undoneLines.removeLast());
    }
  }

  void clear() {
    setState(() {
      lines.clear();
      undoneLines.clear();
    });
  }
}

Path extractPathDataFromDrawableRoot(DrawableRoot root) {
  final Path path = Path();
  root.children.forEach((drawable) {
    if (drawable is DrawableShape) {
      path.addPath(
        drawable.path,
        Offset.zero,
      );
    }
  });
  return path;
}

class SvgBgPainter extends CustomPainter {
  final DrawableRoot drawableRoot;
  final Color? color;
  final scale;
  SvgBgPainter(this.drawableRoot, this.color, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final stopwatch = Stopwatch()..start();

    // 페인트 객체 생성 시간 측정
    stopwatch.reset();
    Paint paint = Paint()
      ..color = color ?? drawableRoot.style?.fill?.color ?? SystemColors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;
    print('SvgBgPainter 페인트 객체 생성 시간: ${stopwatch.elapsedMicroseconds}μs');

    // 경로 변환 시간 측정
    stopwatch.reset();
    final Matrix4 matrix = Matrix4.identity()..scale(scale, scale);
    final Path scaledPath =
        extractPathDataFromDrawableRoot(drawableRoot).transform(matrix.storage);
    print('SvgBgPainter 경로 변환 시간: ${stopwatch.elapsedMicroseconds}μs');

    // 실제 드로잉 시간 측정
    stopwatch.reset();
    canvas.drawPath(scaledPath, paint);
    print('SvgBgPainter 캔버스 드로잉 시간: ${stopwatch.elapsedMicroseconds}μs');

    stopwatch.stop();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SvgLinePainter extends CustomPainter {
  final DrawableRoot drawableRoot;
  final scale;
  final double strokeWidth;
  final Color strokeColor;

  SvgLinePainter(
      this.drawableRoot, this.scale, this.strokeWidth, this.strokeColor);

  @override
  void paint(Canvas canvas, Size size) {
    final stopwatch = Stopwatch()..start();

    // 페인트 객체 생성 시간 측정
    stopwatch.reset();
    Paint paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    print('SvgLinePainter Paint 객체 생성 시간: ${stopwatch.elapsedMicroseconds}μs');

    // 경로 변환 시간 측정
    stopwatch.reset();
    final Matrix4 matrix = Matrix4.identity()..scale(scale, scale);
    final Path scaledPath =
        extractPathDataFromDrawableRoot(drawableRoot).transform(matrix.storage);
    print('SvgLinePainter 경로 변환 시간: ${stopwatch.elapsedMicroseconds}μs');

    // 실제 드로잉 시간 측정
    stopwatch.reset();
    canvas.drawPath(scaledPath, paint);
    print('SvgLinePainter 캔버스 드로잉 시간: ${stopwatch.elapsedMicroseconds}μs');

    stopwatch.stop();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawnLine> lines;
  final DrawableRoot? drawableRoot;
  final double scale;

  DrawingPainter(this.lines, this.drawableRoot, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    if (drawableRoot != null) {
      final Matrix4 matrix = Matrix4.identity()..scale(scale, scale);

      final Path scaledPath = extractPathDataFromDrawableRoot(drawableRoot!)
          .transform(matrix.storage);

      // 중앙에 그리도록 평행 이동 (translate)
      canvas.clipPath(scaledPath);
    }
    canvas.saveLayer(null, Paint());

    for (var line in lines) {
      Paint paint = (line.color != Colors.transparent)
          ? (Paint()
            ..color = line.color
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = line.width * scale / 3)
          : (Paint()
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = line.width * scale / 3
            ..blendMode = BlendMode.clear);

      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(
            line.points[i] * scale / 3, line.points[i + 1] * scale / 3, paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    print("shouldRepaint");
    return true;
  }
}

class DrawnLine {
  List<Offset> points;
  double width;
  Color color;

  DrawnLine(this.points, this.width, this.color);

  Map<String, dynamic> toJson() {
    return {
      'points':
          points.map((point) => {'dx': point.dx, 'dy': point.dy}).toList(),
      'width': width,
      'color': color.value, // Color를 정수값으로 변환
    };
  }

  // JSON에서 객체로 변환
  static DrawnLine fromJson(Map<String, dynamic> json) {
    return DrawnLine(
      (json['points'] as List)
          .map((point) => Offset(point['dx'], point['dy']))
          .toList(),
      json['width'],
      Color(json['color']),
    );
  }
}

class PencilInfo {
  final double width;
  final double pencilSize;

  PencilInfo({required this.width, required this.pencilSize});
}

class Pencil extends StatelessWidget {
  final Color color;
  final double width;
  final bool isExpanded;
  final VoidCallback onTap;

  const Pencil({
    Key? key,
    required this.isExpanded,
    required this.onTap,
    required this.color,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(children: [
            SvgPicture.asset(
              "assets/icons/pencil_top.svg",
              color: Colors.white,
              width: width,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/pencil_top.svg",
                  color: color,
                  width: width - 5,
                ),
              ),
            ),
          ]),
          AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isExpanded ? 80 : 62,
              color: Colors.blue,
              child: Container(
                height: 62,
                width: width,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}

class Eraser extends StatelessWidget {
  final VoidCallback onTap;
  final bool isExpanded;

  const Eraser({super.key, required this.onTap, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    const double baseHeight = 62.0;
    const double expandedHeight = 80.0;
    const double width = 30.0;
    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: isExpanded ? expandedHeight : baseHeight,
        child: Container(
          height: expandedHeight,
          width: width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
