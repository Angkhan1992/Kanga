import 'package:flutter/material.dart';
import 'package:kanga/themes/dimen_theme.dart';

class SuccessScreen extends StatefulWidget {
  final String title;
  final String description;

  const SuccessScreen({
    Key? key,
    this.title = '',
    this.description = '',
  }) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    var iconSize = 150.0;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(offsetXMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(iconSize / 2.0)),
                ),
                child: Center(
                  child: Icon(Icons.check, color: Colors.white, size: iconSize / 2.0,),
                ),
              ),
              SizedBox(
                height: offsetXMd,
              ),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: offsetXMd,
              ),
              Text(
                widget.description,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
