import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/shared_pref.dart';
import '../../locator.dart';
import '../push_notification_service.dart';

class AppInterceptors extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get(Authtoken);
    String device = locator<PushNotificationService>()?.fcmToken;
    options.headers.addAll({
      "Authorization": "Bearer $token",
      "Device": "$device",
    });
    return options;
  }
}
