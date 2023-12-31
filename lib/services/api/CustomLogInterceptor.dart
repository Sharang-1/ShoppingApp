import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';

class CustomLogInterceptor extends Interceptor {
  CustomLogInterceptor() {
    if (kDebugMode) print("interceptor called");
  }

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (kDebugMode) print("On req");
    Fimber.d(
        "--> ${options.method.isNotEmpty ? options.method.toUpperCase() : 'METHOD'} ${"" + (options.baseUrl) + (options.path)}");
    Fimber.d("Headers:");
    options.headers.forEach((k, v) => Fimber.d('$k: $v'));
    if (options.queryParameters.isNotEmpty) {
      Fimber.d("queryParameters:");
      options.queryParameters.forEach((k, v) => Fimber.d('$k: $v'));
    }
    if (options.data != null) {
      Fimber.d("Body: ${options.data}");
    }
    Fimber.d(
        "--> END ${options.method.isNotEmpty ? options.method.toUpperCase() : 'METHOD'}");

    return handler.next(options);
  }

  @override
  Future onError(DioError dioError, ErrorInterceptorHandler handle) async {
    if (kDebugMode) print("On err");
    // Fimber.e(
    //     "<-- ${dioError.message} ${(dioError.response.request != null ? (dioError.response.request.baseUrl + dioError.response.request.path) : 'URL')}");
    // Fimber.e(
    //     "${dioError.response != null ? dioError.response!.data : 'Unknown Error'}");
    // Fimber.e("<-- End error");
    handle.next(dioError);

    // return dioError;
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) print("On resp");
    // Fimber.d(
    //     "<-- ${response.statusCode} ${(response.request != null ? (response.request.baseUrl + response.request.path) : 'URL')}");
    // Fimber.d("Headers:");
    response.headers.forEach((k, v) => Fimber.d('$k: $v'));
    handler.next(response);
    // Fimber.d("Response: ${response.data}");
    // Fimber.d("<-- END HTTP");
  }
}
