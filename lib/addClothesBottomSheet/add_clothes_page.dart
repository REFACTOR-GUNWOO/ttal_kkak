import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_appbar.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_1.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_2.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_3.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_4.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_5.dart';
import 'package:ttal_kkak/addClothesBottomSheet/bottom_sheet_step_6.dart';
import 'package:ttal_kkak/category.dart';
import 'package:ttal_kkak/clothes.dart';
import 'package:ttal_kkak/clothes_grid.dart';
import 'package:ttal_kkak/common/custom_decoder.dart';
import 'package:ttal_kkak/main_layout.dart';
import 'package:ttal_kkak/provider/clothes_update_provider.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';
import 'package:uuid/uuid.dart';

class AddClothesPage extends StatelessWidget {
  final bool isUpdate;
  const AddClothesPage({super.key, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      isUpdate: isUpdate,
    );
  }
}

class StepContainer extends StatefulWidget {
  const StepContainer({super.key, required this.isUpdate});

  @override
  _StepContainerState createState() => _StepContainerState();
  final bool isUpdate;
}

class _StepContainerState extends State<StepContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // provider = Provider.of<ClothesDraftProvider>(context, listen: false);
    // provider?.loadFromLocal();
  }

  int _currentStep = 0;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  List<BottomSheetStep> _buildSteps() {
    return [
      BottomSheetBody1(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody2(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody3(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody4(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody5(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      ),
      BottomSheetBody6(
        onNextStep: _nextStep,
        isUpdate: widget.isUpdate,
        updateProvider: Provider.of<ClothesUpdateProvider>(context),
      )
    ];
  }

  // int getCurrentDraftLevel() {
  //   print("getCurrentDraftLevel : ${provider?.currentDraft?.countLevel()}");
  //   return provider?.currentDraft?.countLevel() ?? 0;
  // }

  Widget clothesWidget() {
    Clothes? clothes =
        Provider.of<ClothesUpdateProvider>(context).currentClothes;
    List<Widget> stackList = [];
    if (clothes == null || clothes.isDraft) {
      stackList.add(Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/icons/NewClothes.svg",
            width: 112,
          )));
    } else {
      SecondCategory? secondCategory = secondCategories
          .where((element) => element.id == clothes.secondaryCategoryId)
          .firstOrNull;
      if (secondCategory != null) {
        stackList.add(Align(
            alignment: Alignment.center,
            child: ClothesItem(
                scale: 1.5, clothes: clothes, key: ValueKey(Uuid().v4()))));
      }
    }
    stackList.add(Align(
        alignment: Alignment.center,
        child: Lottie.asset(
          'assets/lotties/add_clothes.lottie',
          decoder: customDecoder,
          width: 75,
        )));

    return Container(
        width: double.infinity,
        height: 294,
        child: Column(children: [
          Expanded(
              child: Stack(alignment: Alignment.center, children: [
            ...stackList,
          ])),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 8,
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomSheetAppBar(
            nextStepFun: _nextStep,
            previousStepFun: _previousStep,
            nextStep: _currentStep == _buildSteps().length - 1
                ? null
                : _buildSteps()[_currentStep + 1],
            previousStep:
                _currentStep == 0 ? null : _buildSteps()[_currentStep - 1],
            currentStep: _buildSteps()[_currentStep],
            currentStepCount: _currentStep,
            isUpdate: widget.isUpdate),
        body: GestureDetector(
            onTap: () {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild!.unfocus();
              }
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              Provider.of<ClothesUpdateProvider>(context,
                                      listen: false)
                                  .clear();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MainLayout()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow_left.svg',
                                  color: SystemColors.black,
                                  height: 12,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  "내 옷장",
                                  style: OneLineTextStyles.Bold14.copyWith(
                                      color: SystemColors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(
                              widget.isUpdate ? "옷수정" : "옷등록",
                              textAlign: TextAlign.center,
                              style: OneLineTextStyles.Bold18.copyWith(
                                  color: SystemColors.black),
                            )),
                        Expanded(
                            flex: 2,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerRight,
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.all(10),
                                ),
                                onPressed: () {
                                  Provider.of<ClothesUpdateProvider>(context,
                                          listen: false)
                                      .clear();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => MainLayout()),
                                  );
                                },
                                child: Text("완료",
                                    style:
                                        OneLineTextStyles.SemiBold16.copyWith(
                                            color:
                                                SignatureColors.orange400)))),
                      ]),
                ),
                SliverToBoxAdapter(child: clothesWidget()),
                SliverToBoxAdapter(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _buildSteps()[_currentStep].getTitle(),
                          style: OneLineTextStyles.SemiBold20.copyWith(
                              color: SystemColors.black),
                        ))),
                SliverPadding(
                    padding: EdgeInsets.all(20),
                    sliver: _buildSteps()[_currentStep]),
              ],
            )));
  }
}
