import 'package:assignment1/utilities/general_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_constant.dart';
import '../utilities/managers/font_enum.dart';

class BaseTextField extends TextFormField {
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final bool isSecure;
  final MyFont myFont;
  final double? fontSize;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color borderColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Widget? prefixIcon;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChange;
  final TextCapitalization textCapitalization;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final double? cursorHeight;
  final Color? cursorColor;
  final bool autoFocus;
  final bool readOnly;
  final bool? isDense;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final bool? autoValidate;

  BaseTextField(
      {Key? key,
        this.initialValue,
        this.hintText,
        this.controller,
        this.textInputType,
        this.isSecure = false,
        this.myFont = MyFont.rRegular,
        this.fontSize,
        this.autoValidate,
        this.validator,
        this.suffixIcon,
        this.fillColor,
        this.borderColor = ColorConst.black,
        this.textColor,
        this.hintTextColor,
        this.prefixIcon,
        this.onTap,
        this.onEditingComplete,
        this.onFieldSubmitted,
        this.onChange,
        this.textCapitalization = TextCapitalization.none,
        this.borderRadius,
        this.borderWidth = 0,
        this.maxLength,
        this.maxLines,
        this.minLines,
        this.enabled = true,
        this.cursorHeight,
        this.cursorColor,
        this.autoFocus = false,
        this.readOnly = false,
        this.isDense,
        this.contentPadding,
        this.textInputAction,
        this.focusNode,
        this.textAlign = TextAlign.start,
        this.inputFormatters}) : super(key: key,
      initialValue: initialValue,
      enabled: enabled,
      controller: controller,
      keyboardType: textInputType,
      obscureText: isSecure,
      cursorHeight: cursorHeight,
      cursorColor: cursorColor ?? textColor ?? ColorConst.black,
      autofocus: autoFocus,
      readOnly: readOnly,
      maxLength: maxLength,
      style: GeneralUtility.shared.getTextStyle(myFont: myFont, fontSize: fontSize ?? 15, color: textColor),
      onTap: onTap,
      onChanged: onChange,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      textAlign: textAlign,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
          errorMaxLines: 2,
          // isDense: isDense ?? true,
          prefixIcon: prefixIcon,
          fillColor: fillColor,
          filled: true,
          suffixIconConstraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 24
          ),
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: borderWidth)),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: borderWidth)),
          border: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: borderWidth)),
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          hintText: hintText,
          hintMaxLines: 1,
          hintStyle: GeneralUtility.shared.getTextStyle(myFont: myFont, color: hintTextColor, fontSize: fontSize ?? 15)
      ),
      validator: validator,
      autocorrect: false
  );
}