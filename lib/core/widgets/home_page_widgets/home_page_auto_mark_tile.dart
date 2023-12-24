import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomePageAutoMarkTile extends StatelessWidget {
  final String imagePath;
  final String autoNumber;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const HomePageAutoMarkTile(
      {required this.imagePath,
      required this.autoNumber,
      required this.onPressed,
      required this.backgroundColor,
      required this.foregroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 73,
        height: 80,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        margin: const EdgeInsets.only(right:5, left: 5, top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(imagePath,), width: 30, height: 30,),
            const SizedBox(height: 5,),
            AutoSizeText(
              autoNumber,
              maxFontSize: 12,
              minFontSize: 9,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: foregroundColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

