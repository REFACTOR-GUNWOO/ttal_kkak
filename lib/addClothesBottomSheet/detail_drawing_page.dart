import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/Category.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_5.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_repository.dart';
import 'package:ttal_kkak/common/common_bottom_sheet.dart';
import 'package:ttal_kkak/common/show_toast.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

import 'draft_clear_warning_dialog.dart';

class DetailDrawingPage extends StatefulWidget {
  @override
  _DetailDrawingPageState createState() => _DetailDrawingPageState();
  const DetailDrawingPage(
      {super.key,
      required this.isUpdate,
      required this.draftProvider,
      required this.updateProvider});

  final bool isUpdate;
  final ClothesDraftProvider draftProvider;
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
  List<PencilInfo> pencilInfos = [
    PencilInfo(pencilSize: 10, width: 40),
    PencilInfo(pencilSize: 5, width: 26),
    PencilInfo(pencilSize: 2, width: 18)
  ];

  bool _isErasing = false;
  final double minDistance = 1.0; // 손떨림 방지를 위한 최소 거리 설정

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ClothesDraft? draft = widget.draftProvider.currentDraft;
      Clothes? clothes = widget.updateProvider.currentClothes;

      setState(() {
        if (widget.isUpdate) {
          lines = clothes!.drawLines;
          clothesColor = clothes.color;
          SecondCategory secondCategory = secondCategories.firstWhere(
              (element) => element.id == clothes.secondaryCategoryId);
          ClothesDetails clothesDetails = clothes.details!;
          _loadDrawableRoot(clothesDetails, secondCategory);
        } else {
          lines = draft!.drawLines ?? [];
          clothesColor = draft.color!;
          SecondCategory secondCategory = secondCategories
              .firstWhere((element) => element.id == draft.secondaryCategoryId);
          ClothesDetails clothesDetails = draft.details!;
          _loadDrawableRoot(clothesDetails, secondCategory);
        }
      });
    });
  }

  void save() async {
    if (widget.isUpdate) {
      final clothes = widget.updateProvider.currentClothes!;
      clothes.updateDrawlines(lines);
      await widget.updateProvider.update(clothes);
    } else {
      final provider =
          Provider.of<ClothesDraftProvider>(context, listen: false);

      ClothesDraft? draft = provider.currentDraft;
      print("drawing Save: ${draft}");
      if (draft != null) {
        print("draft lines${lines}");
        draft.drawLines = lines;
        await ClothesRepository().addClothes(draft.toClotehs());
        provider.clearDraft();
      }
    }
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MainLayout()),
                        );
                      },
                      child: SvgPicture.asset('assets/icons/arrow_left.svg',
                          color: SystemColors.black)),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => {
                      save(),
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
        height: 180,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0), // 양쪽 여백을 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
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
                                    showToast("초기화 되었습니다.", context);
                                  });
                            },
                          );

                          clear();
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
              ),
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
                    height: 120,
                    width: double.infinity,
                  ),
                  Container(
                    width: 200,
                    height: 120,
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
      body: Align(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.topCenter, // Stack 내에서 모든 위젯을 중앙 정렬
          children: [
            if (svgBgRoot != null)
              CustomPaint(
                size: Size(svgBgRoot!.viewport.width * 3,
                    svgBgRoot!.viewport.height * 3),
                painter: SvgBgPainter(svgBgRoot!, clothesColor, 3.0),
              ),
            if (_svgDecoUrl != null)
              SvgPicture.asset(
                _svgDecoUrl!,
                width: 190,
              ),
            if (svgBgRoot != null)
              CustomPaint(
                size: Size(svgBgRoot!.viewport.width * 3,
                    svgBgRoot!.viewport.height * 3),
                painter: SvgLinePainter(
                    svgLineRoot!,
                    3.0,
                    2.0,
                    clothesColor == Color(0xFF282828)
                        ? SystemColors.gray900
                        : SystemColors.black),
              ),
            if (svgBgRoot != null)
              GestureDetector(
                onPanStart: _startDrawing,
                onPanUpdate: _updateDrawing,
                onPanEnd: _endDrawing,
                child: CustomPaint(
                  size: Size(svgBgRoot!.viewport.width * 3,
                      svgBgRoot!.viewport.height * 3),
                  painter: DrawingPainter(lines, svgBgRoot, 3.0),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _startDrawing(DragStartDetails details) {
    Offset localPosition = details.localPosition;
    setState(() {
      currentLine = DrawnLine([localPosition], brushWidth,
          _isErasing ? Colors.transparent : brushColor);
      lines.add(currentLine!);
    });
  }

  void _updateDrawing(DragUpdateDetails details) {
    Offset localPosition = details.localPosition;
    setState(() {
      if (currentLine != null &&
          (currentLine!.points.isEmpty ||
              (localPosition - currentLine!.points.last).distance >
                  minDistance)) {
        currentLine?.points.add(localPosition);
      }
    });
  }

  void _endDrawing(DragEndDetails details) {
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
  final color;
  final scale;
  SvgBgPainter(this.drawableRoot, this.color, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final Matrix4 matrix = Matrix4.identity()..scale(scale, scale);
    final Path scaledPath =
        extractPathDataFromDrawableRoot(drawableRoot).transform(matrix.storage);

    // // 중앙에 그리도록 평행 이동 (translate)
    // final Offset offset = Offset(
    //   (size.width - bounds.width) / 2 - bounds.left,
    //   (size.height - bounds.height) / 2 - bounds.top,
    // );

    // canvas.translate(offset.dx, offset.dy);

    canvas.drawPath(scaledPath, paint);
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
    Paint paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Matrix4 matrix = Matrix4.identity()..scale(scale, scale);
    final Path scaledPath =
        extractPathDataFromDrawableRoot(drawableRoot).transform(matrix.storage);

    // 중앙에 그리도록 평행 이동 (translate)
    // final Offset offset = Offset(
    //   (size.width - bounds.width) / 2 - bounds.left,
    //   (size.height - bounds.height) / 2 - bounds.top,
    // );

    // canvas.translate(offset.dx, offset.dy);

    canvas.drawPath(scaledPath, paint);
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
