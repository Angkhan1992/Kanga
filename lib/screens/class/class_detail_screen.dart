import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/class_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/native_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';

class ClassDetailScreen extends StatefulWidget {
  final ClassModel classModel;

  const ClassDetailScreen({
    Key? key,
    required this.classModel,
  }) : super(key: key);

  @override
  _ClassDetailScreenState createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  var _isLoading = true;
  var _isPlaying = false;
  var _isFav = false;
  var _isFavoring = false;

  @override
  void initState() {
    super.initState();

    _isFav = widget.classModel.likes > 0;
    Timer.run(() => _initControllers());
  }

  void _initControllers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _videoPlayerController =
          VideoPlayerController.network(widget.classModel.videourl);
      await Future.wait([_videoPlayerController!.initialize()]);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
      );
      _videoPlayerController!.addListener(() {
        if (_isPlaying && !_videoPlayerController!.value.isPlaying) {
          print('Video Play Ended');
          if (_chewieController!.isFullScreen) {
            _chewieController!.exitFullScreen();
            _isPlaying = false;
          }
          setState(() {});
        }
      });
      _chewieController!.addListener(() {});
    } catch (e) {
      DialogProvider.of(context).showSnackBar(
        e.toString(),
        type: SnackBarType.ERROR,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();

    super.dispose();
  }

  void _addFavorite() async {
    if (_isFav) {
      return;
    }
    setState(() {
      _isFavoring = true;
    });
    var _user = await PrefProvider().getUser();
    var param = {
      'class_id': widget.classModel.id,
      'user_id': _user!.id,
    };
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_add_favorite,
      param,
    );
    if (res['ret'] == 10000) {
      _isFav = true;
    }
    setState(() {
      _isFavoring = false;
    });
  }

  void _playList() async {
    var _user = await PrefProvider().getUser();
    var param = {
      'class_id': widget.classModel.id,
      'user_id': _user!.id,
      'like_type': '2',
    };
    await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_add_favorite,
      param,
      isProgress: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.classes,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 2,
          ),
          AspectRatio(
            aspectRatio: 1.8,
            child: _chewieController != null &&
                    _chewieController!
                        .videoPlayerController.value.isInitialized &&
                    _chewieController!.isPlaying
                ? Chewie(
                    controller: _chewieController!,
                  )
                : Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: widget.classModel.thumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(offsetBase),
                            child: Stack(
                              children: [
                                Center(
                                    child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 100.0,
                                  height: 100.0,
                                )),
                                Center(child: CupertinoActivityIndicator()),
                              ],
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          height: 75.0,
                          padding: EdgeInsets.symmetric(horizontal: offsetBase),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x00000000),
                                  const Color(0xFF000000),
                                ],
                                begin: const FractionalOffset(0.5, 0.0),
                                end: const FractionalOffset(0.5, 1.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${widget.classModel.video_time} sec - ${widget.classModel.title}',
                                  style: Theme.of(context).textTheme.headline4,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(offsetBase),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _isFavoring
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    KangaColor().pinkButtonColor(1),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () => _addFavorite(),
                                child: ClassDetailButton(
                                  context,
                                  isAlreadyFav: _isFav,
                                ),
                              ),
                      ),
                      SizedBox(
                        width: offsetBase,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => Share.share('https://kangabalance.com',
                              subject: 'Kanga'),
                          child: ClassDetailButton(
                            context,
                            isFav: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: offsetBase,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClassFavButton(context),
                      ClassFavButton(
                        context,
                        isRating: false,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: offsetBase,
                  ),
                  Text(
                    S.current.description,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Divider(),
                  Text(
                    widget.classModel.detail,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Spacer(),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              KangaColor().pinkButtonColor(1),
                            ),
                          ),
                        )
                      : KangaButton(
                          onPressed: _chewieController == null
                              ? null
                              : () async {
                                  if (Platform.isIOS) {
                                    var result =
                                        await NativeProvider.loadVideoApple(
                                            widget.classModel.videourl);
                                    if (result == 'Finished') {
                                      _playList();
                                    }
                                    return;
                                  }
                                  if (_chewieController!.isPlaying) {
                                    _chewieController!.pause();
                                    _isPlaying = false;
                                  } else {
                                    await _chewieController!.play();
                                    Future.delayed(
                                        Duration(milliseconds: 200),
                                        () => _chewieController!
                                            .enterFullScreen());
                                    _isPlaying = true;
                                    _playList();
                                  }
                                  setState(() {});
                                },
                          btnText: _chewieController == null
                              ? 'Disabled'
                              : _chewieController!.isPlaying
                                  ? S.current.pause
                                  : S.current.start,
                        ),
                  SizedBox(
                    height: offsetXMd,
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
