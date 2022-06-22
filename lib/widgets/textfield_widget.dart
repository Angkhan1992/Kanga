import 'package:flutter/material.dart';
import 'package:kanga/themes/border_theme.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';

class KangaTextField extends TextFormField {
  KangaTextField({
    Key? key,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    Function(String)? onSubmitted,
    Function()? onTap,
    bool obscureText = false,
    bool readOnly = false,
    bool circleConner = false,
    bool isMemo = false,
    TextEditingController? controller,
  }) : super(
          controller: controller,
          keyboardAppearance: Brightness.dark,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          cursorColor: Colors.white,
          readOnly: readOnly,
          maxLines: isMemo ? 5 : 1,
          minLines: isMemo ? 5 : 1,
          decoration: InputDecoration(
            contentPadding:
                isMemo ? EdgeInsets.all(offsetBase) : EdgeInsets.zero,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: KangaColor().secondDarkColor(0.6),
              fontWeight: FontWeight.w200,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldOutBorder,
            enabledBorder: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldOutBorder,
            focusedBorder: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldOutBorder,
            errorBorder: circleConner
                ? textFieldErrorOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldErrorOutBorder,
            disabledBorder: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldOutBorder,
            focusedErrorBorder: circleConner
                ? textFieldErrorOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldErrorOutBorder,
          ),
          onSaved: onSaved,
          validator: validator,
          onTap: onTap,
          onFieldSubmitted: onSubmitted,
        );
}
