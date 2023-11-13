import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputBoxWithoutSuffix extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final EdgeInsetsGeometry? margin;
  final TextInputType? keyboardType;
  final Function(dynamic)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isSearchable;

  const InputBoxWithoutSuffix(
      {required this.label,
      required this.controller,
      this.margin,
      this.keyboardType,
      this.onChanged,
      this.inputFormatters,
      this.isSearchable,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 42,
        margin: margin,
        child: TextField(
          autofillHints: const [],
          inputFormatters: inputFormatters ?? [],
          onChanged: onChanged,
          keyboardType: keyboardType ?? TextInputType.visiblePassword,
          autocorrect: false,
          enableSuggestions: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF2F2F4),
            contentPadding: EdgeInsets.only(
                top: 42 / 2, right: isSearchable != null ? 40 : 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            prefixIcon: isSearchable != null
                ? const IntrinsicWidth(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.search,
                          color: Color.fromRGBO(241, 34, 34, 1)),
                    ),
                  )
                : Container(),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: label,
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
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
