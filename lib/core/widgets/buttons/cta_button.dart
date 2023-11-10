import 'package:flutter/material.dart';

class CTAbutton extends StatelessWidget{
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final String text;
  final EdgeInsetsGeometry? margin;

  const CTAbutton({
    required this.height,
    required this.width,
    required this.onPressed,
    required this.text,
    this.margin,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ElevatedButton(
        style:  ElevatedButton.styleFrom (
          backgroundColor: const Color(0xffC42225),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xffF3F4F6),
          disabledForegroundColor: const Color(0xffCCCCCC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18
          ),
        ),
      ),
    );
  }
}