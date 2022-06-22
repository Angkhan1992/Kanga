import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/measure_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/stt_provider.dart';
import 'package:kanga/screens/measure/measure_balance_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/measure_widget.dart';
import 'package:kanga/widgets/video_widget.dart';

class MeasureDetailScreen extends StatefulWidget {
  final MeasureModel measure;
  final bool isSensor;

  const MeasureDetailScreen({
    Key? key,
    required this.measure,
    this.isSensor = true,
  }) : super(key: key);

  @override
  _MeasureDetailScreenState createState() => _MeasureDetailScreenState();
}

class _MeasureDetailScreenState extends State<MeasureDetailScreen> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;

  var _isLoaded = false;

  @override
  void initState() {
    super.initState();

    if (!widget.isSensor) _checkPermission();
    _initVideo(widget.isSensor
        ? widget.measure.video_sensor
        : widget.measure.video_voice);
  }

  @override
  void dispose() {
    super.dispose();

    if (_videoController != null) _videoController!.dispose();
    if (_youtubeController != null) _youtubeController!.dispose();
  }

  void _checkPermission() async {
    if (!await KangaSTTProvider.checkPermission()) {
      DialogProvider.of(context).kangaBubbleDialog(
        child: Column(
          children: [
            Text(
              S.current.permissionDenied,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 22.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: offsetBase,
            ),
            Text(
              S.current.permissionVoice,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 18.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: offsetSm,
            ),
            Text(
              S.current.permissionHint,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          KangaMeasureDialogButton(
            context,
            action: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            text: S.current.ok,
          ),
        ],
      );
      return;
    }
  }

  void _initVideo(String link) async {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.kangaMeasure,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(offsetBase),
            child: Container(
              height: 200.0,
              child: (widget.isSensor
                          ? widget.measure.video_sensor
                          : widget.measure.video_voice)
                      .contains('youtube')
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
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: offsetSm,
              horizontal: offsetXLg,
            ),
            child: Text(
              widget.measure.title.toUpperCase(),
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
          Expanded(
            child: Container(
              width: double.infinity,
              color: KangaColor().bubbleConnerColor(1),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: offsetBase,
                    ),
                    child: Text(
                      (widget.isSensor
                              ? S.current.sensorMode
                              : S.current.voiceMode)
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: KangaColor().pinkMatColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: offsetBase,
                    ),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: KangaColor().textGreyColor(1)),
                      borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
                      gradient: gradientSensor,
                    ),
                    child: Text(
                      widget.isSensor
                          ? widget.measure.desc_sensor
                          : widget.measure.desc_voice,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  Spacer(),
                  KangaButton(
                    padding: const EdgeInsets.symmetric(horizontal: offsetXLg),
                    btnText: S.current.ok,
                    onPressed: () {
                      NavigatorProvider.of(context).pushToWidget(
                        screen: MeasureBalanceScreen(
                          measure: widget.measure,
                          isSensor: widget.isSensor,
                        ),
                        replace: true,
                      );
                    },
                  ),
                  SizedBox(
                    height: offsetLg,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

LinearGradient gradientSensor = LinearGradient(
  colors: [
    const Color(0xFF000000),
    const Color(0xFF050505),
    const Color(0xFF1D1D1D),
    const Color(0xFF2A2A2A),
    const Color(0xFF3E3E3E),
    const Color(0xFF545454),
  ],
  begin: const FractionalOffset(0.5, 0.0),
  end: const FractionalOffset(0.5, 1.0),
  stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  tileMode: TileMode.clamp,
);
