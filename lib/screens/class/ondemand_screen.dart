import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kanga/models/class_model.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/screens/class/demand_detail_screen.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/common_widget.dart';

class OnDemandScreen extends StatefulWidget {
  const OnDemandScreen({Key? key}) : super(key: key);

  @override
  _OnDemandScreenState createState() => _OnDemandScreenState();
}

class _OnDemandScreenState extends State<OnDemandScreen> {
  List<OnDemandModel> _demands = [];
  var _isLoaded = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() => _getData());
  }

  void _getData({
    bool isProcessing = true,
  }) async {
    if (isProcessing) setState(() {
      _isLoaded = false;
    });
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_get_demand,
      {},
    );
    if (res['ret'] == 10000) {
      _demands.clear();
      for (var json in res['result']) {
        var demand = OnDemandModel.fromJson(json);
        _demands.add(demand);
      }
    }
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoaded? ListView.builder(
        padding: EdgeInsets.all(offsetBase),
        itemBuilder: (context, i) {
          var _demand = _demands[i];
          return _demand.getWidget(
            context,
            onDetail: () => NavigatorProvider.of(context).pushToWidget(
              screen: DemandDetailScreen(
                model: _demand,
              ),
              pop: (flag) {
                _getData();
              },
            ),
          );
        },
        itemCount: _demands.length,
      ) : EmptyWidget(context),
    );
  }
}
