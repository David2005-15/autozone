import 'package:autozone/core/widgets/buttons/cta_button.dart';
import 'package:autozone/core/widgets/buttons/green_search_button.dart';
import 'package:autozone/core/widgets/buttons/onprimary_button.dart';
import 'package:autozone/core/widgets/buttons/red_search_button.dart';
import 'package:flutter/material.dart';

class ButtonFactory {
  static Widget createButton(String type, String text, VoidCallback? onPressed, double width, double height,
      {EdgeInsetsGeometry? margin}) {
    switch (type) {
      case 'cta':
        return CTAbutton(
          text: text,
          onPressed: onPressed,
          width: width,
          height: height,
          margin: margin,
        );
      case "onprim":
        return ONPRIMbutton(
          text: text,
          onPressed: onPressed,
          width: width,
          height: height,
          margin: margin,
        );
      case "cta_green":
        return GreenCta(
          text: text,
          onPressed: onPressed,
          width: width,
          height: height,
          margin: margin,
        );
      case "cta_red":
        return RedCta(
          text: text,
          onPressed: onPressed,
          width: width,
          height: height,
          margin: margin,
        );
      default:
        throw Exception('Unknown button type');
    }
  }
}
