import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/clothes_draft.dart';
import 'package:ttal_kkak/clothes_draft_repository.dart';
import 'package:ttal_kkak/provider/clothes_draft_provider.dart';

class DraftClearWarningDialog extends StatelessWidget {
  final String draftFieldName;
  final String? title;
  final String? description;
  final ClothesDraft? draft;
  final VoidCallback onNextStep;
  DraftClearWarningDialog(
      {required this.draftFieldName,
      this.draft,
      required this.onNextStep,
      this.title,
      this.description});
  void clear(BuildContext context) async {
    if (draft != null) {
      ClothesDraftProvider provider =
          Provider.of<ClothesDraftProvider>(context, listen: false);

      await ClothesDraftRepository().save(draft!);
      await provider.updateDraft(draft!);
    }
    onNextStep();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Center(
        child: Text(
          title ?? '${draftFieldName} 변경',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            description ?? '하위 정보가 사라져요.\n${draftFieldName}를 변경하시겠어요?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 버튼 클릭 시 동작할 코드를 여기에 작성
              clear(context);
              Navigator.of(context).pop(); // 모달 닫기
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // 버튼 색상
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              '변경',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
