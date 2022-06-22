import 'package:flutter/material.dart';
import 'package:kanga/themes/dimen_theme.dart';

class MembershipResultWidget extends Container {
  MembershipResultWidget(
    BuildContext context, {
    Key? key,
    required String content,
    required Function() pop,
  }) : super(
          padding: const EdgeInsets.symmetric(
              vertical: offsetSm, horizontal: offsetXLg),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      content,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                    ),
                    SizedBox(
                      width: offsetXSm,
                    ),
                    InkWell(
                      onTap: pop,
                      child: Icon(
                        Icons.info_outline,
                        key: key,
                        size: 12.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.check,
                color: Colors.white,
                size: 18.0,
              ),
            ],
          ),
        );
}
