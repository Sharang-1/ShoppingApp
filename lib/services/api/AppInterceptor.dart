import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/shared_pref.dart';
import '../../locator.dart';
import '../push_notification_service.dart';

class AppInterceptors extends Interceptor {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if(kDebugMode) print("in App Interceptor");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get(Authtoken);
    String device = locator<PushNotificationService>().fcmToken;
    options.headers.addAll({
      "Authorization": "Bearer $token",
      "Device": "$device",
    });
    if(kDebugMode) print(options);
    return handler.next(options);
  }
}
