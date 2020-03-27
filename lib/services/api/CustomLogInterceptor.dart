import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';

class CustomLogInterceptor extends Interceptor {

  CustomLogInterceptor() {
    print("interceptor called");
  }

  @override
  Future onRequest(RequestOptions options) async {
    Fimber.i(
        "--> ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"" + (options.baseUrl ?? "") + (options.path ?? "")}");
    Fimber.i("Headers:");
    options.headers.forEach((k, v) => Fimber.i('$k: $v'));
    if (options.queryParameters != null) {
      Fimber.i("queryParameters:");
      options.queryParameters.forEach((k, v) => Fimber.i('$k: $v'));
    }
    if (options.data != null) {
      Fimber.i("Body: ${options.data}");
    }
    Fimber.i(
        "--> END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}");

    return options;
  }

  @override
  Future onError(DioError dioError) async{
    Fimber.e(
        "<-- ${dioError.message} ${(dioError.response?.request != null ? (dioError.response.request.baseUrl + dioError.response.request.path) : 'URL')}");
    Fimber.e(
        "${dioError.response != null ? dioError.response.data : 'Unknown Error'}");
    Fimber.e("<-- End error");

    return dioError;
  }

  @override
  Future onResponse(Response response) async {
    Fimber.i(
        "<-- ${response.statusCode} ${(response.request != null ? (response.request.baseUrl + response.request.path) : 'URL')}");
    Fimber.i("Headers:");
    response.headers?.forEach((k, v) => Fimber.i('$k: $v'));
    Fimber.i("Response: ${response.data}");
    Fimber.i("<-- END HTTP");
  }
}