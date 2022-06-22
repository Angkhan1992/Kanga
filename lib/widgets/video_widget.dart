import 'package:flutter/material.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MeasureVideoWidget extends StatelessWidget {
  final VideoPlayerController? controller;
  final bool isLoaded;
  final Function()? togglePlay;

  const MeasureVideoWidget({
    Key? key,
    required this.controller,
    this.isLoaded = false,
    this.togglePlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: isLoaded
              ? AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: VideoPlayer(controller!),
                )
              : Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
        ),
        if (controller != null)
          Center(
            child: InkWell(
              onTap: togglePlay,
              child: Icon(
                controller!.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                color: Colors.black.withOpacity(0.5),
                size: 48.0,
              ),
            ),
          ),
      ],
    );
  }
}

class MeasureYoutubeWidget extends StatelessWidget {
  final YoutubePlayerController? controller;
  final Function()? onReady;

  const MeasureYoutubeWidget({
    Key? key,
    required this.controller,
    this.onReady,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: KangaColor.kangaButtonBackColor,
      progressColors: ProgressBarColors(
        playedColor: KangaColor.kangaButtonBackColor,
        handleColor: KangaColor.kangaButtonBackColor,
      ),
      onReady: onReady,
    );
  }
}
