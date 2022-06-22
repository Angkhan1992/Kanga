import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:kanga/providers/loading_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/utils/constants.dart';

class NetworkProvider {
  final BuildContext? context;

  NetworkProvider(this.context);

  static NetworkProvider of(BuildContext? context) {
    return NetworkProvider(context);
  }

  Future post(String header, String link, Map<String, dynamic> parameter,
      {bool isProgress = false}) async {
    if (isProgress && context != null) LoadingProvider.of(context).show();

    var baseUrl = (kReleaseMode || PRODUCTTEST) ? RELEASEBASEURL : DEBUGBASEURL;
    var url = Uri.parse('$baseUrl$header/$link');

    var token = await PrefProvider().getToken();
    if (token.isNotEmpty) {
      parameter['token'] = token;
    }

    _httpRequestLog(url, parameter);

    final response = await http.post(
      url,
      body: parameter,
    );
    if (isProgress && context != null) LoadingProvider.of(context).hide();

    if (response.statusCode == 201 || response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['ret'] == 9999) {
        _httpResponseLog(url, parameter, "Your token was expired");
        Navigator.of(context!)
            .popUntil(ModalRoute.withName(Constants.route_onboard));
        return null;
      }
      _httpResponseLog(url, parameter, json);
      return json;
    } else {
      print('[HTTP] response ===> ${response.statusCode}');
      return {'status': response.statusCode, 'ret': 9998};
    }
  }

  void _httpRequestLog(Uri url, dynamic param) {
    print("""
    |------------------------------------------------------------------ 
    |  link : ${url.toString()}
    |  parameter : $param
    |------------------------------------------------------------------
    """);
  }

  void _httpResponseLog(Uri url, dynamic parameter, dynamic response) {
    print("""
    |------------------------------------------------------------------ 
    |  link : ${url.toString()}
    |  response : $response
    |------------------------------------------------------------------
    """);
  }
}
