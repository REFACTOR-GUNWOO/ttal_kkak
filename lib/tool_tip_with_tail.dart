// 꼬리를 가진 툴팁 위젯
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class RandomTooltipScreen extends StatefulWidget {
  @override
  _RandomTooltipScreenState createState() => _RandomTooltipScreenState();
}

class _RandomTooltipScreenState extends State<RandomTooltipScreen> {
  // 4가지 문구를 리스트로 저장
  final List<TooltipText> tooltips = [
    TooltipText(mainText: "오늘 입은 옷", subText: "이 옷장에 다 있어요?"),
    TooltipText(mainText: "등록을 깜빡한 아우터 ", subText: "없으신가요?"),
    TooltipText(mainText: "등록을 깜빡한 상의 ", subText: "없으신가요?"),
    TooltipText(mainText: "제일 좋아하는 옷  ", subText: "을 등록하셨나요?"),
  ];

  // 랜덤하게 선택된 문구를 저장할 변수
  TooltipText selectedTooltip =
      TooltipText(mainText: "오늘 입은 옷", subText: "이 옷장에 다 있어요?");

  @override
  void initState() {
    print("${selectedTooltip} init state");
    super.initState();
    _showRandomTooltip(); // 앱 시작 시 랜덤 문구 선택
  }

  // 랜덤 문구 선택 함수
  void _showRandomTooltip() {
    final random = Random();
    int index = random.nextInt(tooltips.length);
    setState(() {
      selectedTooltip = tooltips[index]; // 랜덤 문구 선택
    });
  }

  @override
  Widget build(BuildContext context) {
    return TooltipWithTail(text: selectedTooltip);
  }
}

// 툴팁 본체와 꼬리를 분리해서 보여주는 위젯
class TooltipWithTail extends StatelessWidget {
  final TooltipText text;

  TooltipWithTail({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 네모 부분
        TooltipBody(text: text),
        // 세모 부분 (꼬리)

        Padding(
          padding: const EdgeInsets.only(right: 20), // 오른쪽에서 10픽셀 떨어지도록 설정
          child: TooltipTail(),
        ),
      ],
    );
  }
}

// 네모 부분
class TooltipBody extends StatelessWidget {
  final TooltipText text;

  TooltipBody({required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TooltipBodyClipper(), // 네모 부분을 자르는 클리퍼
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.black.withOpacity(0.8),
        child: text,
      ),
    );
  }
}

// 세모 부분 (꼬리)
class TooltipTail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TooltipTailClipper(), // 세모 부분을 자르는 클리퍼
      child: Container(
        width: 10,
        height: 5,
        color: Colors.black.withOpacity(0.8),
      ),
    );
  }
}

// 네모 부분을 자르는 클리퍼
class TooltipBodyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(8), // 모서리 둥글게
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// 세모 부분을 자르는 클리퍼
class TooltipTailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TooltipText extends StatelessWidget {
  String mainText;
  String subText;

  TooltipText({required this.mainText, required this.subText});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: mainText, // 기본 스타일 텍스트
        style:
            OneLineTextStyles.Bold12.copyWith(color: SignatureColors.orange400),
        children: <TextSpan>[
          TextSpan(
            text: subText, // 굵은 텍스트 스타일
            style: OneLineTextStyles.Bold12.copyWith(color: SystemColors.white),
          ),
        ],
      ),
    );
  }
}
