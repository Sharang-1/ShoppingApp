import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';

class CustomLogInterceptor extends Interceptor {
  CustomLogInterceptor() {
    print("interceptor called");
  }

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Fimber.d(
        "--> ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"" + (options.baseUrl) + (options.path)}");
    Fimber.d("Headers:");
    options.headers.forEach((k, v) => Fimber.d('$k: $v'));
    if (options.queryParameters != null) {
      Fimber.d("queryParameters:");
      options.queryParameters.forEach((k, v) => Fimber.d('$k: $v'));
    }
    if (options.data != null) {
      Fimber.d("Body: ${options.data}");
    }
    Fimber.d(
        "--> END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}");

    return options;
  }

  @override
  Future onError(DioError dioError, ErrorInterceptorHandler handle) async {
    // Fimber.e(
    //     "<-- ${dioError.message} ${(dioError.response.request != null ? (dioError.response.request.baseUrl + dioError.response.request.path) : 'URL')}");
    // Fimber.e(
    //     "${dioError.response != null ? dioError.response!.data : 'Unknown Error'}");
    // Fimber.e("<-- End error");

    return dioError;
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // Fimber.d(
    //     "<-- ${response.statusCode} ${(response.request != null ? (response.request.baseUrl + response.request.path) : 'URL')}");
    // Fimber.d("Headers:");
    response.headers.forEach((k, v) => Fimber.d('$k: $v'));
    // Fimber.d("Response: ${response.data}");
    // Fimber.d("<-- END HTTP");
  }
}
