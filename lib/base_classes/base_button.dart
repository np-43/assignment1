import 'package:flutter/material.dart';
import '../constants/color_constant.dart';
import '../utilities/managers/font_enum.dart';
import 'base_text.dart';

class BaseMaterialButton extends MaterialButton{
  final VoidCallback? onPressed;
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final double? borderRadius;
  final MyFont myFont;
  final double? fontSize;
  final double verticalPadding;
  final double? horizontalPadding;

  BaseMaterialButton(this.buttonText, this.onPressed, {Key? key, this.buttonColor, this.textColor, this.myFont = MyFont.rcBold, this.fontSize, this.borderRadius, this.verticalPadding = 10, this.horizontalPadding}) :
        super(
          key: key,
          child: BaseText(text: buttonText, color: textColor ?? Colors.white, myFont: myFont, fontSize: fontSize ?? 20,),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          ),
          color: buttonColor ?? ColorConst.buttonBG,
          disabledColor: ColorConst.grey,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding ?? 40)
      );
}