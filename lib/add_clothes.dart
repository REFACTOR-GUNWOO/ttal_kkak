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
  showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BottomSheetHandle(),
            BottomSheetAppBar(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: '메모를 입력해주세요.',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 14.0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('옷을 잘 구분할 수 있는 옷 이름으로 등록해주세요.',
                      textAlign: TextAlign.left,
                      style: BodyTextStyles.Regular14),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        );
      });
}

class BottomSheetAppBar extends StatelessWidget {
  const BottomSheetAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        height: 56.0, // 일반적인 앱바 높이
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.close, color: Color(0xff1e1e1e)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              '등록할 옷 이름',
              style: TextStyle(color: Color(0xff1e1e1e), fontSize: 20.0),
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Color(0xff1e1e1e)),
              onPressed: () {
                // 추가 기능
              },
            ),
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
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
