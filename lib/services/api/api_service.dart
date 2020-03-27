import 'dart:async';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/models/products.dart';
import 'dart:convert';
import 'package:compound/services/api/AppInterceptor.dart';
import 'package:compound/services/api/CustomLogInterceptor.dart';
import 'package:dio/dio.dart';
import 'package:compound/models/post.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../locator.dart';
import '../dialog_service.dart';

class APIService {
  final apiClient = Dio(BaseOptions(
      baseUrl: "http://52.66.141.191/",
      connectTimeout: 5000,
      receiveTimeout: 5000,
      validateStatus: (status) {
        return status < 500;
      }

      // 200  response code ... you are good
      // 400 response code ... means validation error... like in valid data
      // 401 .. 403 ... issue with login... you will get error message
      ));
  final excludeToken = Options(headers: {"excludeToken": true});
  final DialogService _dialogService = locator<DialogService>();

  APIService() {
    apiClient..interceptors.addAll([AppInterceptors(), CustomLogInterceptor()]);
  }

  Future apiWrapper(String path,
      {data, Map<String, dynamic> queryParameters, Options options}) async {
    Options tempOptions;
    if (options == null) {
      tempOptions = excludeToken;
    } else {
      tempOptions = options;
    }

    try {
      Response res;
      if (data == null) {
        res = await apiClient.get(path,
            options: tempOptions, queryParameters: queryParameters);
      } else {
        res = await apiClient.post(path,
            data: data, queryParameters: queryParameters, options: tempOptions);
      }
      Map resJSON = res.data;
      if (resJSON["error"] != null) {
        throw Exception(resJSON["error"]);
      }
      return resJSON;
    } catch (e, stacktrace) {
      Fimber.e("Api Service error", ex: e, stacktrace: stacktrace);
      _dialogService.showDialog(description: e.toString(), title: "Error");
    }
  }

  Future sendOTP({@required String phoneNo}) {
    return apiWrapper("api/message/generateOtpToLogin",
        data: {"mobile": phoneNo});
  }

  Future verifyOTP({@required String phoneNo, @required String otp}) {
    return apiWrapper("api/message/verifyOtpToLogin",
        data: {"mobile": phoneNo}, queryParameters: {"otp": otp});
  }

  Future<Products> getProducts({ String queryString = "" }) async {
    var productData = await apiWrapper("api/products;$queryString");
    if (productData != null) {
      Products products = Products.fromJson(productData);
      Fimber.d("products : " + products.items.map((o) => o.name).toString());
      return products;
    }
    return null;
  }
}
