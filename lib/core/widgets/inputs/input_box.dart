import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final EdgeInsetsGeometry? margin;
  final TextInputType? keyboardType;
  final Function(dynamic)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const InputBox(
      {required this.label,
      required this.controller,
      this.margin,
      this.keyboardType,
      this.onChanged,
      this.inputFormatters,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 42,
        margin: margin,
        padding: const EdgeInsets.only(left: 40, right: 40),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F4),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: TextField(
            inputFormatters: inputFormatters ?? [],
            onChanged: onChanged,
            keyboardType: keyboardType ?? TextInputType.text,
            autocorrect: false,
            enableSuggestions: false,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF2F2F4),
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  " +374",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xff164866)),
                ),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: label,
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xffCCCCCC)),
            ),
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xff164866)),
            controller: controller,
          ),
        ));
  }
}
