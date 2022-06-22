import 'package:flutter/material.dart';

import 'package:kanga/themes/dimen_theme.dart';

OutlineInputBorder textFieldOutBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
);

OutlineInputBorder textFieldErrorOutBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
);