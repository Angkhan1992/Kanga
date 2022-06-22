import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:kanga/themes/color_theme.dart';

class HtmlViewScreen extends StatefulWidget {
  final String title;
  final HtmlViewType viewType;

  HtmlViewScreen({
    required this.title,
    required this.viewType,
  });

  @override
  _HtmlViewScreenState createState() => _HtmlViewScreenState();
}

class _HtmlViewScreenState extends State<HtmlViewScreen> {
  var isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: KangaColor().pinkButtonColor(1),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: Stack(
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -50.0, 0.0),
            child: WebView(
              initialUrl: widget.viewType == HtmlViewType.PrivacyPolicy
                  ? 'https://www.kangabalance.com/privacy-policy/'
                  : widget.viewType == HtmlViewType.TermsService
                      ? 'https://www.kangabalance.com/terms-of-service/'
                      : 'https://www.kangabalance.com/',
              onPageFinished: (String url) {
                setState(() {
                  isLoaded = true;
                });
              },
            ),
          ),
          if (!isLoaded)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  KangaColor().pinkButtonColor(1),
                ),
              ),
            )
        ],
      ),
    );
  }
}

enum HtmlViewType {
  PrivacyPolicy,
  TermsService,
  MembershipTerm,
}
