import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuffixInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final EdgeInsetsGeometry? margin;
  final TextInputType? keyboardType;
  final Function(dynamic)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback onSuffixIcon;

  const SuffixInput(
      {required this.label,
      required this.controller,
      required this.onSuffixIcon,
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
        child: TextField(
          inputFormatters: inputFormatters ?? [],
          autofillHints: const [AutofillHints.postalCode],
          onChanged: onChanged,
          keyboardType: keyboardType ?? TextInputType.text,
          autocorrect: false,
          enableSuggestions: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF2F2F4),
            contentPadding: const EdgeInsets.only(top: 42 / 2, left: 40),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            suffixIcon: InkWell(
              onTap: onSuffixIcon,
              child: const Image(
                image: AssetImage("assets/DocIcon.png"),
              ),
            ),
            hintText: label,
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Color(0xffCCCCCC)),
          ),
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xff164866)),
          controller: controller,
        ));
  }
}
