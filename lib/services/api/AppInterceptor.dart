import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/shared_pref.dart';

class AppInterceptors extends Interceptor {

  @override
  Future onRequest(RequestOptions options) async {
    if (!options.headers.containsKey("excludeToken")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.get(Authtoken);
      options.headers.addAll({"Authorization": "Bearer $token"});
    } else {
      options.headers.remove("excludeToken");
    }
    return options;
  }

  // @override
  // Future onError(DioError dioError) async {
    

  //   _dialogService.showDialog(
  //     title: 'Network Error from interceptor',
  //     description: dioError.error,
  //   );

  //   return dioError;
  // }

  // @override
  // Future onResponse(Response options) async {
  //   if (options.headers.value("verifyToken") != null) {
  //     //if the header is present, then compare it with the Shared Prefs key
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var verifyToken = prefs.get("VerifyToken");

  //     // if the value is the same as the header, continue with the request
  //     if (options.headers.value("verifyToken") == verifyToken) {
  //       return options;
  //     }
  //   }

  //   return DioError(request: options.request, error: "User is no longer active");
  // }
}
