import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_drawing/path_drawing.dart';

void main() {
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
  Path? svgClipPath;

  @override
  void initState() {
    super.initState();
    _loadSvgPath();
  }

  Future<void> _loadSvgPath() async {
    final String svgString =
        await rootBundle.loadString('assets/icons/test_outline_2.svg');
    final DrawableRoot svgRoot = await svg.fromSvgString(svgString, svgString);

    final Path clipPath = extractPathDataFromDrawableRoot(svgRoot);

    setState(() {
      svgClipPath = clipPath;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
      ),
      body: Stack(
        children: [
          if (svgClipPath != null)
            Center(
              child: CustomPaint(
                size: Size(300, 300),
                painter: SvgPainter(svgClipPath!),
              ),
            ),
          Center(
            child: GestureDetector(
              onPanStart: _startDrawing,
              onPanUpdate: _updateDrawing,
              onPanEnd: _endDrawing,
              child: CustomPaint(
                size: Size(300, 300),
                painter: DrawingPainter(lines, svgClipPath),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: "5",
                  onPressed: undo,
                  child: Icon(Icons.undo),
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: "1",
                  onPressed: redo,
                  child: Icon(Icons.redo),
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: "2",
                  onPressed: clear,
                  child: Icon(Icons.clear),
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: "3",
                  onPressed: () => _selectBrushSize(context),
                  child: Icon(Icons.brush),
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: "4",
                  onPressed: selectColor,
                  child: Icon(Icons.color_lens),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startDrawing(DragStartDetails details) {
    Offset localPosition = details.localPosition;
    // print("lines : ${lines.last}");
    setState(() {
      currentLine = DrawnLine([localPosition], brushWidth, brushColor);
      lines.add(currentLine!);
    });
  }

  void _updateDrawing(DragUpdateDetails details) {
    Offset localPosition = details.localPosition;
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

  void _selectBrushSize(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Brush Size'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (double size in [1.0, 3.0, 5.0, 7.0, 10.0, 15.0, 20.0])
                  ListTile(
                    title: Text(size.toString()),
                    onTap: () {
                      setState(() {
                        brushWidth = size;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
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

class SvgPainter extends CustomPainter {
  final Path path;

  SvgPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawnLine> lines;
  final Path? clipPath;

  DrawingPainter(this.lines, this.clipPath);

  @override
  void paint(Canvas canvas, Size size) {
    if (clipPath != null) {
      canvas.clipPath(clipPath!);
    }

    for (var line in lines) {
      Paint paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = line.width;

      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    }
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
