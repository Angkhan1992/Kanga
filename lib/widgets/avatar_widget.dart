import 'package:flutter/material.dart';
import 'package:kanga/themes/color_theme.dart';

class EmptyAvatar extends Container {
  EmptyAvatar({required String name})
      : super(
          width: 48.0,
          height: 48.0,
          decoration: BoxDecoration(
            color: KangaColor.kangaButtonBackColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          child: Center(
            child: Text(
              name[0].toUpperCase(),
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );
}
