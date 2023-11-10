import 'package:flutter/material.dart';

class SMSLimitPage extends StatelessWidget {
  const SMSLimitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: const Text(
          "SMS հաղորդագրության\nստացման սահմանափակում (24 ժամ)",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xff164866),
          ),
        ),
      ),
    );
  }
}
