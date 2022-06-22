import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/measure_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/measure/measure_detail_screen.dart';
import 'package:kanga/screens/measure/view_score_screen.dart';
import 'package:kanga/screens/profile/edit_profile_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/measure_widget.dart';
import 'package:kanga/widgets/video_widget.dart';

class MeasureScreen extends StatefulWidget {
  final Function()? onCancelEvent;

  const MeasureScreen({
    Key? key,
    this.onCancelEvent,
  }) : super(key: key);

  @override
  _MeasureScreenState createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;

  var _isLoaded = false;
  var isSensorMode = true;

  dynamic measureInfo;
  List<MeasureModel> measures = [];

  @override
  void initState() {
    super.initState();
    _checkAgree();
    Timer.run(() => _initData());
  }

  @override
  void dispose() {
    super.dispose();
    if (_videoController != null) _videoController!.dispose();
    if (_youtubeController != null) _youtubeController!.dispose();
  }

  void _checkAgree() async {
    var isAgree = await PrefProvider().getMeasureAgree();
    if (!isAgree) {
      DialogProvider.of(context).kangaBubbleDialog(
        child: Column(
          children: [
            Text(
              S.current.measureAlertTitle,
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: offsetBase,
            ),
            Text(
              S.current.measureAlertMsg01,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Text(
              S.current.measureAlertMsg02,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: offsetBase,
            ),
          ],
        ),
        actions: [
          KangaMeasureDialogButton(
            context,
            action: widget.onCancelEvent!,
            text: S.current.cancel,
          ),
          KangaMeasureDialogButton(
            context,
            action: () async {
              await PrefProvider().setMeasureAgree(true);
              Navigator.of(context).pop();
            },
            text: S.current.accept,
            isFull: true,
          ),
        ],
      );
    }
  }

  void _showSensorDialog({
    bool isSensor = false,
  }) {
    DialogProvider.of(context).kangaBubbleDialog(
      child: Column(
        children: [
          Column(
            children: [
              Text(
                isSensor
                    ? S.current.sensorModeOnTitle
                    : S.current.sensorModeOffTitle,
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                height: offsetBase,
              ),
              Text(
                isSensor
                    ? S.current.sensorModeOnDesc
                    : S.current.sensorModeOffDesc,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 18.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
      actions: [
        KangaMeasureDialogButton(
          context,
          action: () => Navigator.of(context).pop(),
          text: S.current.ok,
        ),
      ],
    );
  }

  void _initVideo(String link) {
    if (link.contains('youtube')) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: link.split('watch?v=').last,
        flags: YoutubePlayerFlags(),
      );
    } else {
      _videoController = VideoPlayerController.network(link)
        ..initialize().then((_) {
          _isLoaded = true;
          setState(() {});
        });
      _videoController!.play();
      _videoController!.addListener(() {
        setState(() {});
      });
    }
  }

  void _initData() async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_measure,
      Constants.link_measure_info,
      {},
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      measureInfo = res['result']['info'];
      measures.clear();
      for (var measureJson in res['result']['measures']) {
        measures.add(MeasureModel.fromJson(measureJson));
      }

      _initVideo(measureInfo['video_link']);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Container(),
        title: Text(
          S.current.measure,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(offsetBase),
              child: Container(
                height: 200.0,
                child: measureInfo == null
                    ? Image.asset('assets/images/logo.png')
                    : measureInfo['video_link'].contains('youtube')
                        ? MeasureYoutubeWidget(
                            controller: _youtubeController,
                            onReady: () {},
                          )
                        : MeasureVideoWidget(
                            controller: _videoController,
                            isLoaded: _isLoaded,
                            togglePlay: () => setState(() {
                              _videoController!.value.isPlaying
                                  ? _videoController!.pause()
                                  : _videoController!.play();
                            }),
                          ),
              ),
            ),
            if (measureInfo != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: offsetBase,
                  horizontal: offsetXLg,
                ),
                child: Text(
                  measureInfo['description'],
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: KangaColor().textGreyColor(1),
                        fontSize: 16.0,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            Container(
              height: 0.5,
              color: Colors.white,
            ),
            Container(
              height: 52.0,
              padding: EdgeInsets.symmetric(horizontal: offsetBase),
              color: KangaColor().bubbleColor(1),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    S.current.sensorMode,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(
                    width: offsetSm,
                  ),
                  CupertinoSwitch(
                    onChanged: (flag) {
                      setState(() {
                        isSensorMode = !isSensorMode;
                      });
                      _showSensorDialog(isSensor: isSensorMode);
                    },
                    value: isSensorMode,
                    activeColor: KangaColor().pinkButtonColor(1),
                    trackColor: Colors.grey,
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.white,
            ),
            SizedBox(
              height: offsetXMd,
            ),
            for (var measure in measures)
              Padding(
                padding: const EdgeInsets.only(
                  top: offsetXMd,
                  left: offsetXLg,
                  right: offsetXLg,
                ),
                child: ((kReleaseMode && measure.f_release == '1') ||
                        !kReleaseMode)
                    ? KangaButton(
                        btnText: measure.title,
                        onPressed: () async {
                          var user = (await PrefProvider().getUser())!;
                          if ((user.dob == '0000-00-00')) {
                            DialogProvider.of(context).kangaBubbleDialog(
                              child: Column(
                                children: [
                                  Text(
                                    S.current.notCorrectUserInfo,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  SizedBox(
                                    height: offsetBase,
                                  ),
                                  Text(
                                    S.current.notCorrectWrongDetail,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          fontSize: 16.0,
                                        ),
                                  ),
                                ],
                              ),
                              actions: [
                                KangaMeasureDialogButton(
                                  context,
                                  action: () {
                                    Navigator.of(context).pop();
                                    NavigatorProvider.of(context).pushToWidget(
                                      screen: EditProfileScreen(
                                        currentUser: user,
                                      ),
                                      pop: (flag) {
                                        _videoController!.play();
                                      },
                                    );
                                  },
                                  text: S.current.completeNow,
                                ),
                                KangaMeasureDialogButton(
                                  context,
                                  action: () {
                                    Navigator.of(context).pop();
                                    _gotoNext(measure);
                                  },
                                  text: S.current.ok,
                                  isFull: true,
                                ),
                              ],
                            );
                            return;
                          } else {
                            _gotoNext(measure);
                          }
                        },
                      )
                    : Container(),
              ),
            Padding(
              padding: const EdgeInsets.all(offsetXLg),
              child: KangaButton(
                btnText: S.current.viewScore,
                borderWidth: 2.0,
                onPressed: () => NavigatorProvider.of(context).pushToWidget(
                  screen: ViewScoreScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _gotoNext(MeasureModel measure) async {
    if (_videoController != null) _videoController!.pause();
    if (_youtubeController != null) _youtubeController!.pause();
    NavigatorProvider.of(context).pushToWidget(
      screen: MeasureDetailScreen(
        measure: measure,
        isSensor: isSensorMode,
      ),
      pop: (flag) {
        if (_videoController != null) _videoController!.play();
        if (_youtubeController != null) _youtubeController!.play();
      },
    );
  }
}
