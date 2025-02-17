import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/detail_drawing_page.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class BottomSheetBody6 extends StatefulWidget implements BottomSheetStep {
  final VoidCallback onNextStep;
  const BottomSheetBody6(
      {super.key,
      required this.onNextStep,
      required this.isUpdate,
      required this.updateProvider});
  final bool isUpdate;
  final ClothesUpdateProvider updateProvider;
  @override
  bool Function() get canGoNext => () => true;

  @override
  DetailInfoCards createState() => DetailInfoCards();

  @override
  String getTitle() {
    return "옷 디테일";
  }
}

class DetailInfoCards extends State<BottomSheetBody6> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailDrawingPage(
                        isUpdate: widget.isUpdate,
                        updateProvider: widget.updateProvider,
                      )),
            );
          },
          child: _buildDetailCard(context,
              title: '디테일 드로잉',
              description: '드로잉으로 옷의 디테일을\n표현해주세요!',
              icon: SvgPicture.asset(
                "assets/icons/drawing_guide_icon.svg",
                alignment: Alignment.center,
                height: 56,
                width: 56,
              )),
        ),
      ],
    ));
  }

  Widget _buildDetailCard(BuildContext context,
      {required String title,
      required String description,
      required SvgPicture icon}) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: OneLineTextStyles.SemiBold16.copyWith(
                        color: SystemColors.black)),
                SizedBox(
                  height: 8,
                ),
                Text(
                  description,
                  style: BodyTextStyles.Regular14.copyWith(
                      color: SystemColors.gray700),
                ),
              ],
            ),
            Center(
                // 화면 중앙에 배치
                child: icon),
          ],
        ),
      ),
      Positioned(
        left: 94,
        top: 8,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailDrawingInfoPage(
                          isUpdate: widget.isUpdate,
                          updateProvider: widget.updateProvider,
                        )),
              );
            },
            child: Padding(
                padding: EdgeInsets.all(10),
                child: SvgPicture.asset("assets/icons/coach_mark.svg"))),
      )
    ]);
  }
}

class DetailDrawingInfoPage extends StatelessWidget {
  final bool isUpdate;
  final ClothesUpdateProvider updateProvider;

  // 생성자를 통해 파라미터를 전달받음
  const DetailDrawingInfoPage(
      {Key? key, required this.isUpdate, required this.updateProvider})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '디테일 드로잉',
          style: OneLineTextStyles.Bold18.copyWith(color: SystemColors.black),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 48,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDrawingSection(
              image: Image.asset(
                "assets/images/drawing_guide_image_1.png",
                width: 350,
                height: 152,
              ),
              title: '옷의 프린팅을 그려보세요',
              description: '구체적이기보다는 구분할 수 있을 정도의\n프린팅을 그려 넣어주세요',
            ),
            SizedBox(height: 24.0),
            _buildDrawingSection(
              image: Image.asset(
                "assets/images/drawing_guide_image_2.png",
                width: 350,
                height: 152,
              ),
              title: '옷의 패턴을 그려보세요',
              description: '줄무늬나 체크무늬, 땡땡이 같은 옷의\n패턴을 그려보세요',
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width - 40, 56),
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                ),
                child: Text('확인', style: OneLineTextStyles.SemiBold16),
              ),
            ),
            SizedBox(height: 17.0),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawingSection(
      {required String title,
      required String description,
      required Image image}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(6.0), child: image),
        SizedBox(height: 16.0),
        Text(
          title,
          style: BodyTextStyles.Bold24,
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          textAlign: TextAlign.center,
          style: BodyTextStyles.Regular16,
        ),
      ],
    );
  }
}
