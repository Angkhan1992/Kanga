import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/widgets/path_widget.dart';

class OnDemandModel {
  String id;
  String name;
  String reg_date;
  String thumbnail;
  String other;
  int classes;

  OnDemandModel({
    this.id = '',
    this.name = '',
    this.reg_date = '',
    this.thumbnail = '',
    this.other = '',
    this.classes = 0,
  });

  factory OnDemandModel.fromJson(Map<String, dynamic> json) {
    return OnDemandModel(
      id: json["id"],
      name: json["name"],
      reg_date: json["reg_date"],
      thumbnail: json["thumbnail"],
      other: json["other"],
      classes: json["classes"],
    );
  }

  Widget getWidget(BuildContext context, {Function()? onDetail}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onDetail,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(offsetBase),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
              ClipPath(
                clipper: KangaRectClipper(),
                child: Container(
                  color: KangaColor().bubbleColor(1),
                  child: CachedNetworkImage(
                    imageUrl: thumbnail,
                    width: 160.0,
                    height: 120.0,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(offsetBase),
                      child: Stack(
                        children: [
                          Center(
                              child: Image.asset(
                            'assets/images/logo.png',
                            width: 60.0,
                            height: 60.0,
                          )),
                          Center(child: CupertinoActivityIndicator()),
                        ],
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClassModel {
  String id;
  String title;
  String demand_id;
  String admin_id;
  String detail;
  String thumbnail;
  String videourl;
  String reg_date;
  String other;
  int likes;
  String is_play;
  String video_time;
  String difficulty;

  ClassModel({
    this.id = '',
    this.title = '',
    this.demand_id = '',
    this.admin_id = '',
    this.detail = '',
    this.thumbnail = '',
    this.videourl = '',
    this.reg_date = '',
    this.other = '',
    this.likes = 0,
    this.is_play = 'false',
    this.video_time = '',
    this.difficulty = '',
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json["id"],
      title: json["title"],
      demand_id: json["demand_id"],
      admin_id: json["admin_id"],
      detail: json["detail"],
      thumbnail: json["thumbnail"],
      videourl: json["videourl"],
      reg_date: json["reg_date"],
      other: json["other"],
      likes: json["likes"] ?? 0,
      video_time: json["video_time"],
      difficulty: json["difficulty"],
    );
  }

  Map<String, dynamic> toBaseJson() {
    return {
      "title": this.title,
      "demand_id": this.demand_id,
      "detail": this.detail,
      "thumbnail": this.thumbnail,
      "videourl": this.videourl,
      "video_time": this.video_time,
    };
  }

  Widget getWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: offsetBase),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(offsetBase),
        ),
        border: Border.all(
          color: KangaColor().textGreyColor(1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(offsetBase - 2),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: thumbnail,
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
                        '$title',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: offsetSm,
                left: offsetSm,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: offsetSm,
                vertical: offsetXSm,
              ),
              decoration: BoxDecoration(
                color: KangaColor().pinkButtonColor(1),
                borderRadius: BorderRadius.all(
                  Radius.circular(offsetBase),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 18.0,
                  ),
                  SizedBox(
                    width: offsetXSm,
                  ),
                  Text(
                    '$video_time sec',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
