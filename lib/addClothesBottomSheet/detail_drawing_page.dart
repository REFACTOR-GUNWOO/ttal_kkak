import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailDrawingPage(),
    );
  }
}

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
                            color: Colors.green,
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
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        width: 32,
                        height: 32,
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
    print("_updateDrawing :${localPosition}");

    setState(() {
      currentLine?.points.add(localPosition);
    });
  }

  void _endDrawing(DragEndDetails details) {
    setState(() {
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

  void selectColor() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = brushColor;
        return AlertDialog(
          title: Text('Select Color'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Brightness'),
              Slider(
                value: 1.0,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    brushColor = tempColor.withOpacity(value);
                  });
                },
              ),
              Text('Saturation'),
              Slider(
                value: 1.0,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    HSLColor hslColor = HSLColor.fromColor(tempColor);
                    brushColor = hslColor.withSaturation(value).toColor();
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Done'),
              onPressed: () {
                setState(() {
                  brushColor = tempColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  color: Colors.black,
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
            color: Colors.blue,
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
