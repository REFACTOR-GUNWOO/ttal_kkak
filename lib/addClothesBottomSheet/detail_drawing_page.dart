import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class DetailDrawingPage extends StatefulWidget {
  @override
  _DetailDrawingPageState createState() => _DetailDrawingPageState();
}

class _DetailDrawingPageState extends State<DetailDrawingPage> {
  List<DrawnLine> lines = [];
  List<DrawnLine> undoneLines = [];
  DrawnLine? currentLine;
  double brushWidth = 5.0;
  Color brushColor = Colors.black;
  DrawableRoot? svgRoot;
  int _expandedIndex = -1;
  List<PencilInfo> pencilInfos = [
    PencilInfo(pencilSize: 10, width: 40),
    PencilInfo(pencilSize: 5, width: 26),
    PencilInfo(pencilSize: 2, width: 18)
  ];
  bool _isErasing = false;
  final double minDistance = 4.0; // 손떨림 방지를 위한 최소 거리 설정

  final List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.grey,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black87,
  ];

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '펜 컬러',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: colors.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, colors[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: colors[index] == brushColor
                              ? Colors.orange
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    ).then((selectedColor) {
      if (selectedColor != null) {
        // 선택된 색상을 처리
        setState(() {
          brushColor = selectedColor;
        });
      }
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

  @override
  void initState() {
    super.initState();
    _loadDrawableRoot();
  }

  Future<void> _loadDrawableRoot() async {
    final String svgString =
        await rootBundle.loadString('assets/icons/test_outline_2.svg');
    final DrawableRoot drawableSvgRoot =
        await svg.fromSvgString(svgString, svgString);

    setState(() {
      svgRoot = drawableSvgRoot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignatureColors.begie200,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0, // 그림자 제거

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset('assets/icons/arrow_left.svg'),
              TextButton(
                onPressed: () {
                  // 저장 로직
                },
                child: Text(
                  '저장',
                  style: TextStyle(color: Colors.orange, fontSize: 16),
                ),
              ),
            ],
          )),
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
      body: Center(
        child: Stack(
          alignment: Alignment.center, // Stack 내에서 모든 위젯을 중앙 정렬
          children: [
            if (svgRoot != null)
              CustomPaint(
                size: Size(300, 300),
                painter: SvgPainter(svgRoot!),
              ),
            GestureDetector(
              onPanStart: _startDrawing,
              onPanUpdate: _updateDrawing,
              onPanEnd: _endDrawing,
              child: CustomPaint(
                size: Size(300, 300),
                painter: DrawingPainter(lines, svgRoot),
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

class SvgPainter extends CustomPainter {
  final DrawableRoot drawableRoot;

  SvgPainter(this.drawableRoot);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Matrix4 matrix = Matrix4.identity()..scale(3.0, 3.0);
    final Path scaledPath = extractPathDataFromDrawableRoot(drawableRoot!)
        .transform(matrix.storage);
    final Rect bounds = scaledPath.getBounds();

    // 중앙에 그리도록 평행 이동 (translate)
    final Offset offset = Offset(
      (size.width - bounds.width) / 2 - bounds.left,
      (size.height - bounds.height) / 2 - bounds.top,
    );

    canvas.translate(offset.dx, offset.dy);

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

  DrawingPainter(this.lines, this.drawableRoot);

  Path createSmoothPath(List<Offset> points) {
    Path path = Path();

    if (points.isEmpty) return path;

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length - 1; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];

      final controlPoint = Offset(
        (p0.dx + p2.dx) / 2,
        (p0.dy + p2.dy) / 2,
      );

      path.quadraticBezierTo(
        p1.dx,
        p1.dy,
        controlPoint.dx,
        controlPoint.dy,
      );
    }

    path.lineTo(points.last.dx, points.last.dy);

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (drawableRoot != null) {
      final Matrix4 matrix = Matrix4.identity()..scale(3.0, 3.0);

      final Path scaledPath = extractPathDataFromDrawableRoot(drawableRoot!)
          .transform(matrix.storage);
      final Rect bounds = scaledPath.getBounds();

      // 중앙에 그리도록 평행 이동 (translate)

      final Matrix4 matrix2 = Matrix4.identity()
        ..translate(
          (size.width - bounds.width) / 2 - bounds.left,
          (size.height - bounds.height) / 2 - bounds.top,
        );

      canvas.clipPath(scaledPath.transform(matrix2.storage));
    }
    canvas.saveLayer(null, Paint());

    List<DrawnLine> erasedLines = lines
        .where(
          (e) => e.color == Colors.transparent,
        )
        .toList();

    List<DrawnLine> unerasedLines = lines
        .where(
          (e) => e.color != Colors.transparent,
        )
        .toList();

    for (var line in lines) {
      Paint paint = (line.color != Colors.transparent)
          ? (Paint()
            ..color = line.color
            ..strokeCap = StrokeCap.round
            ..strokeWidth = line.width)
          : (Paint()
            ..strokeCap = StrokeCap.round
            ..strokeWidth = line.width
            ..blendMode = BlendMode.clear);

      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DrawnLine {
  List<Offset> points;
  double width;
  Color color;

  DrawnLine(this.points, this.width, this.color);
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
    return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? 80 : 62,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              height: 80,
              width: 30,
            )));
    ;
  }
}
