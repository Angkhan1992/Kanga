import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _appLink = 'App Link';
  var _chestLink = 'Chest Link';
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLink();
  }

  void _getLink() async {
    var result = await NetworkProvider.of(context)
        .post(Constants.header_auth, Constants.link_app_info, {});
    var _appInfo = result['result'];
    await PrefProvider().setAppInfo(_appInfo);

    if (Platform.isIOS) {
      _appLink = _appInfo['apple'];
    } else {
      _appLink = _appInfo['google'];
    }
    _chestLink = _appInfo['chest'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          S.current.share,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(offsetBase),
        child: Column(
          children: [
            SizedBox(
              height: offsetXMd,
            ),
            Text(
              S.current.findYourFriends,
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: offsetBase,
            ),
            Column(
              children: [
                Text(
                  S.current.addOrInviteDetail,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: offsetXMd,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(offsetSm),
                        padding: EdgeInsets.all(offsetSm),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(child: Text(_appLink)),
                            SizedBox(
                              width: offsetBase,
                            ),
                            InkWell(
                              child: Icon(Icons.copy),
                              onTap: () async {
                                await Clipboard.setData(
                                    new ClipboardData(text: _appLink));
                                DialogProvider.of(context).showSnackBar(
                                  S.current.copyShareLink,
                                  // type: SnackBarType.ERROR,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: offsetBase,
                    ),
                    isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              KangaColor().pinkButtonColor(1),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Share.share(_appLink);
                            },
                            child: Container(
                              width: offsetXLg,
                              height: offsetXLg,
                              decoration: BoxDecoration(
                                color: KangaColor().pinkButtonColor(1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(offsetXLg / 2.0)),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: offsetXMd,
            ),
            Column(
              children: [
                Text(
                  S.current.chestLink,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: offsetXMd,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(offsetSm),
                        padding: EdgeInsets.all(offsetSm),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(child: Text(_chestLink)),
                            SizedBox(
                              width: offsetBase,
                            ),
                            InkWell(
                              child: Icon(Icons.copy),
                              onTap: () async {
                                await Clipboard.setData(
                                    new ClipboardData(text: _chestLink));
                                DialogProvider.of(context).showSnackBar(
                                  S.current.copyShareLink,
                                  // type: SnackBarType.ERROR,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: offsetBase,
                    ),
                    isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              KangaColor().pinkButtonColor(1),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Share.share(_chestLink);
                            },
                            child: Container(
                              width: offsetXLg,
                              height: offsetXLg,
                              decoration: BoxDecoration(
                                color: KangaColor().pinkButtonColor(1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(offsetXLg / 2.0)),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
