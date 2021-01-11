import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceInterceptor extends Interceptor {

  PerformanceInterceptor({
    this.requestContentLengthMethod = defaultRequestContentLength,
      this.responseContentLengthMethod = defaultResponseContentLength
  });

  final _map = <int, HttpMetric>{};
  final RequestContentLengthMethod requestContentLengthMethod;
  final ResponseContentLengthMethod responseContentLengthMethod;

  @override
  Future onRequest(RequestOptions options) async {
    try {
      final metric = FirebasePerformance.instance.newHttpMetric(
          options.uri.normalized(), options.method.asHttpMethod());

      final requestKey = options.extra.hashCode;
      _map[requestKey] = metric;
      final requestContentLength = requestContentLengthMethod(options);
      await metric.start();
      if (requestContentLength != null) {
        metric.requestPayloadSize = requestContentLength;
      }
    } catch (_) {}
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    try {
      final requestKey = response.request.extra.hashCode;
      final metric = _map[requestKey];
      metric.setResponse(response, responseContentLengthMethod);
      await metric.stop();
      _map.remove(requestKey);
    } catch (_) {}
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) async {
    try {
      final requestKey = err.request.extra.hashCode;
      final metric = _map[requestKey];
      metric.setResponse(err.response, responseContentLengthMethod);
      await metric.stop();
      _map.remove(requestKey);
    } catch (_) {}
    return super.onError(err);
  }
}
typedef RequestContentLengthMethod = int Function(RequestOptions options);
int defaultRequestContentLength(RequestOptions options) {
  try {
    if (options.data is String || options.data is Map) {
      return options.headers.toString().length +
          (options.data?.toString()?.length ?? 0);
    }
  } catch (_) {
    return null;
  }
  return null;
}

typedef ResponseContentLengthMethod = int Function(Response options);
int defaultResponseContentLength(Response response) {
  if (response.data is String) {
    return (response?.headers?.toString()?.length ?? 0) + response.data.length;
  } else {
    return null;
  }
}

extension _ResponseHttpMetric on HttpMetric {
  void setResponse(
      Response value, ResponseContentLengthMethod responseContentLengthMethod) {
    if (value == null) {
      return;
    }
    final responseContentLength = responseContentLengthMethod(value);
    if (responseContentLength != null) {
      responsePayloadSize = responseContentLength;
    }
    final contentType = value?.headers?.value?.call(Headers.contentTypeHeader);
    if (contentType != null) {
      responseContentType = contentType;
    }
    if (value.statusCode != null) {
      httpResponseCode = value.statusCode;
    }
  }
}

extension _UriHttpMethod on Uri {
  String normalized() {
    return "$scheme://$host$path";
  }
}

extension _StringHttpMethod on String {
  HttpMethod asHttpMethod() {
    if (this == null) {
      return null;
    }

    switch (toUpperCase()) {
      case "POST":
        return HttpMethod.Post;
      case "GET":
        return HttpMethod.Get;
      case "DELETE":
        return HttpMethod.Delete;
      case "PUT":
        return HttpMethod.Put;
      case "PATCH":
        return HttpMethod.Patch;
      case "OPTIONS":
        return HttpMethod.Options;
      default:
        return null;
    }
  }
}