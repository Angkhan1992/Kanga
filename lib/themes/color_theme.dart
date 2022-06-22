import 'package:flutter/material.dart';

class KangaColor {
  static const kangaMainColor = Color(0xFFffffff);
  static const kangaMainDarkColor = Color(0xFF000000);
  static const kangaDialogBackColor = Color(0xFF101010);
  static const kangaButtonBackColor = Color(0xFFFA8072);
  static const kangaTextGrayColor = Color(0xFFAAB2BA);

  Color _mainColor = Color(0xFFffffff);
  Color _mainDarkColor = Color(0xFF000000);
  Color _secondColor = Color(0xFF000000);
  Color _secondDarkColor = Color(0xFFffffff);
  Color _accentColor = Color(0xFF8C98A8);
  Color _accentDarkColor = Color(0xFF9999aa);
  Color _scaffoldColor = Color(0xFFFAFAFA);
  Color _darkGrayColor = Color(0xFF101010);

  Color _pinkButtonColor = Color(0xFFFA8072);
  Color _textGreyColor = Color(0xFFAAB2BA);
  Color _bubbleColor = Color(0xFF505050);
  Color _bubbleConnerColor = Color(0xFF303030);



  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }

  Color scaffoldColor(double opacity) {
    return _scaffoldColor.withOpacity(opacity);
  }

  Color pinkButtonColor(double opacity) {
    return _pinkButtonColor.withOpacity(opacity);
  }

  Color textGreyColor(double opacity) {
    return _textGreyColor.withOpacity(opacity);
  }

  Color darkGreyColor(double opacity) {
    return _darkGrayColor.withOpacity(opacity);
  }

  Color bubbleColor(double opacity) {
    return _bubbleColor.withOpacity(opacity);
  }

  Color bubbleConnerColor(double opacity) {
    return _bubbleConnerColor.withOpacity(opacity);
  }

  MaterialColor pinkMatColor = MaterialColor(
    0xFFFA8072,
    const <int, Color>{
      50: const Color(0xFFFA8072),
      100: const Color(0xFFFA8072),
      200: const Color(0xFFFA8072),
      300: const Color(0xFFFA8072),
      400: const Color(0xFFFA8072),
      500: const Color(0xFFFA8072),
      600: const Color(0xFFFA8072),
      700: const Color(0xFFFA8072),
      800: const Color(0xFFFA8072),
      900: const Color(0xFFFA8072),
    },
  );

  MaterialColor textGrayMatColor = MaterialColor(
    0xFFAAB2BA,
    const <int, Color>{
      50: const Color(0xFFAAB2BA),
      100: const Color(0xFFAAB2BA),
      200: const Color(0xFFAAB2BA),
      300: const Color(0xFFAAB2BA),
      400: const Color(0xFFAAB2BA),
      500: const Color(0xFFAAB2BA),
      600: const Color(0xFFAAB2BA),
      700: const Color(0xFFAAB2BA),
      800: const Color(0xFFAAB2BA),
      900: const Color(0xFFAAB2BA),
    },
  );
}
