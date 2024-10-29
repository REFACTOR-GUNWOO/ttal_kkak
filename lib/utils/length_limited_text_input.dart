import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ttal_kkak/styles/colors_styles.dart';
import 'package:ttal_kkak/styles/text_styles.dart';

class LengthLimitedTextInput extends StatefulWidget {
  final int maxLength;
  final String hintText;
  final String description;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String> onSubmit;
  final TextEditingController controller;

  const LengthLimitedTextInput(this.maxLength, this.hintText, this.description,
      this.onTextChanged, this.onSubmit,
      {super.key, required this.controller});

  @override
  _LengthLimitedTextInputStatue createState() =>
      _LengthLimitedTextInputStatue();
}

class _LengthLimitedTextInputStatue extends State<LengthLimitedTextInput> {
  String? errorText;
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  void _handleTextChanged() {
    widget.onTextChanged(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_handleTextChanged);
    _controller.addListener(() {
      setState(() {
        errorText = _controller.text.length >= widget.maxLength
            ? '${widget.maxLength}자까지 입력할 수 있어요.'
            : null;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          focusNode: _focusNode,
          controller: _controller,
          onSubmitted: (value) => {widget.onSubmit(value)},
          inputFormatters: [LengthLimitingTextInputFormatter(8)],
          decoration: InputDecoration(
            suffix: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${_controller.text.length}',
                        style: BodyTextStyles.Regular14.copyWith(
                            color: SignatureColors.orange400),
                      ),
                      TextSpan(
                          text: '/8',
                          style: BodyTextStyles.Regular14.copyWith(
                              color: SystemColors.black)),
                    ],
                  ),
                );
              },
            ),
            hintText: widget.hintText,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: SystemColors.gray500)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: SystemColors.gray500)),
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          ),
        ),
        SizedBox(height: 10),
        errorText == null
            ? Text(widget.description,
                textAlign: TextAlign.left, style: BodyTextStyles.Regular14)
            : Text(errorText!,
                textAlign: TextAlign.left,
                style: BodyTextStyles.Regular14.copyWith(
                    color: SystemColors.caution)),
        SizedBox(height: 20),
      ],
    );
  }
}
