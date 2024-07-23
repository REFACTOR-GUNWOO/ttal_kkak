import 'package:flutter/material.dart';
import 'styles/text_styles.dart';
import 'styles/colors_styles.dart';

class AddClothes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowAddClothesBottomSheet(context);
    });

    return Container(); // 빈 컨테이너를 반환합니다.
  }
}

void ShowAddClothesBottomSheet(BuildContext context) {
  final TextEditingController _controller = TextEditingController();

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), // 상단 왼쪽 라운드값
              topRight: Radius.circular(20.0), // 상단 오른쪽 라운드값
            ),
          ),
          height: 240, // 고정된 높이 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BottomSheetHandle(),
              BottomSheetAppBar(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '메모를 입력해주세요.',
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: SystemColors.gray500)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: SystemColors.gray500)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 14.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('옷을 잘 구분할 수 있는 옷 이름으로 등록해주세요.',
                        textAlign: TextAlign.left,
                        style: BodyTextStyles.Regular14),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

class BottomSheetAppBar extends StatelessWidget {
  const BottomSheetAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 48, // 일반적인 앱바 높이
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // IconButton(
            //   icon: const Icon(Icons.close, color: Color(0xff1e1e1e)),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            Text(
              '등록할 옷 이름',
              style:
                  OneLineTextStyles.Bold16.copyWith(color: SystemColors.black),
            ),
            // IconButton(
            //   icon: const Icon(Icons.more_vert, color: Color(0xff1e1e1e)),
            //   onPressed: () {
            //     // 추가 기능
            //   },
            // ),
          ],
        ));
  }
}

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: SignatureColors.begie600,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
