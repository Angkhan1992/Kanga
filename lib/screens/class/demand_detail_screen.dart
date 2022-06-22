import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:kanga/models/class_model.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/screens/class/class_detail_screen.dart';
import 'package:kanga/screens/class/youtube_detail_screen.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';

class DemandDetailScreen extends StatefulWidget {
  final OnDemandModel? model;

  const DemandDetailScreen({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  _DemandDetailScreenState createState() => _DemandDetailScreenState();
}

class _DemandDetailScreenState extends State<DemandDetailScreen> {
  var _refreshController = RefreshController(initialRefresh: false);
  List<ClassModel> _classes = [];

  @override
  void initState() {
    super.initState();

    Timer.run(() => _getData());
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void _getData({
    bool isProcessing = true,
  }) async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_demand_class,
      {'demand_id': widget.model!.id},
      isProgress: isProcessing,
    );
    if (res['ret'] == 10000) {
      _classes.clear();
      for (var json in res['result']) {
        var classModel = ClassModel.fromJson(json);
        _classes.add(classModel);
      }
    }
    if (!isProcessing) {
      _refreshController.refreshCompleted();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.model!.name,
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {},
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        child: ListView.builder(
          padding: EdgeInsets.all(offsetBase),
          itemBuilder: (context, i) {
            var _class = _classes[i];
            return AspectRatio(
              aspectRatio: 1.6,
              child: InkWell(
                onTap: () => NavigatorProvider.of(context).pushToWidget(
                  screen: _class.videourl.contains('youtube')
                      ? YoutubeDetailScreen(classModel: _class)
                      : ClassDetailScreen(classModel: _class),
                  pop: (value) => _getData(
                    isProcessing: false,
                  ),
                ),
                child: _class.getWidget(
                  context,
                ),
              ),
            );
          },
          itemCount: _classes.length,
        ),
        onRefresh: () => _getData(isProcessing: false),
      ),
    );
  }
}
