import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/class_model.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';

class YoutubeDetailScreen extends StatefulWidget {
  final ClassModel classModel;
  const YoutubeDetailScreen({
    Key? key,
    required this.classModel,
  }) : super(key: key);

  @override
  _YoutubeDetailScreenState createState() => _YoutubeDetailScreenState();
}

class _YoutubeDetailScreenState extends State<YoutubeDetailScreen> {
  YoutubePlayerController? _controller;

  var _isPlayerReady = false;
  var _isPlaying = false;

  var _isFav = false;
  var _isFavoring = false;

  @override
  void initState() {
    super.initState();

    print('[Class] detail : ${widget.classModel.toBaseJson()}');

    _isFav = widget.classModel.likes > 0;
    _controller = YoutubePlayerController(
      initialVideoId: widget.classModel.videourl.split('watch?v=').last,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  void listener() {
    print('[Youtube] status : ${_controller!.value.playerState.toString()}');
    if (_controller!.value.playerState == PlayerState.ended) {
      _playList();
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
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
            child: Stack(
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.amber,
                  onReady: () {
                    setState(() {
                      _isPlayerReady = true;
                    });
                    _controller!.addListener(listener);
                  },
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
                  !_isPlayerReady
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              KangaColor.kangaButtonBackColor,
                            ),
                          ),
                        )
                      : KangaButton(
                          onPressed: () {
                            if (_isPlaying) {
                              _controller!.pause();
                              setState(() {
                                _isPlaying = false;
                              });
                            } else {
                              _controller!.play();
                              setState(() {
                                _isPlaying = true;
                              });
                            }
                          },
                          btnText:
                              _isPlaying ? S.current.pause : S.current.start,
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
}
