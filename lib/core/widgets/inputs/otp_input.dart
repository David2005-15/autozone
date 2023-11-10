import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationInput extends StatefulWidget {
  final List<TextEditingController> contollers;
  final VoidCallback? onCompleted;

  const OtpVerificationInput({required this.contollers, required this.onCompleted,  super.key});

  @override
  State<StatefulWidget> createState() => _OtpVerificationInputState();
}

class _OtpVerificationInputState extends State<OtpVerificationInput> {
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in widget.contollers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Container(
          width: 50,
          height: 70,
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: TextField(
            controller: widget.contollers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xff164866),
            ),
            decoration: InputDecoration(
              counterText: ' ',
              contentPadding: const EdgeInsets.only(top: 5, left: 2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
              ),
              filled: true,
              fillColor: const Color(0xffF2F2F4)
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 3) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              } else {
                if (index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              }

              if (widget.contollers.every((element) => element.text.isNotEmpty)) {
                widget.onCompleted?.call();
              }
            },
          ),
        ),
      ),
    );
  }
}
