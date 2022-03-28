import 'package:flutter/material.dart';
import '../constants/color_constant.dart';
import '../utilities/managers/font_enum.dart';

class BaseText extends Text {
  final String text;
  final Color color;
  final TextAlign textAlignment;
  final MyFont myFont;
  final double fontSize;
  final double letterSpacing;
  final TextOverflow textOverflow;
  final TextDecoration textDecoration;
  final int numberOfLines;

  BaseText({Key? key, required this.text, this.color = ColorConst.black, this.fontSize = 22, this.textAlignment = TextAlign.center, this.myFont = MyFont.rRegular, this.textOverflow = TextOverflow.ellipsis, this.textDecoration = TextDecoration.none, this.numberOfLines = 1, this.letterSpacing = 0.0}) : super(
      text,
      key: key,
      textScaleFactor: 0.80,
      textAlign: textAlignment,
      overflow: textOverflow,
      maxLines: numberOfLines,
      style: TextStyle(
        decoration: textDecoration,
        decorationStyle: TextDecorationStyle.solid,
        color: color,
        fontSize: fontSize,
        fontFamily: myFont.family,
        fontWeight: myFont.weight,
        letterSpacing: letterSpacing,
      ));
}