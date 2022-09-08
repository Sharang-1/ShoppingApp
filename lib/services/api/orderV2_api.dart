import 'dart:io';

import 'package:compound/models/orderV2.dart';
import 'package:dio/dio.dart' as dio;
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../models/orderV2_response.dart';
import '../error_handling_service.dart';

class GroupOrderApi {
  final userToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5MTo3ODM4MDYzMTM5IiwidXNlciI6IntcImFjY291bnROb25Mb2NrZWRcIjp0cnVlLFwiY3JlZGVudGlhbHNOb25FeHBpcmVkXCI6dHJ1ZSxcImFjY291bnROb25FeHBpcmVkXCI6dHJ1ZSxcImVuYWJsZWRcIjp0cnVlLFwidXNlcm5hbWVcIjpcIjkxOjc4MzgwNjMxMzlcIixcInJvbGVzXCI6W1wiUk9MRV9GaXhlZFwiXSxcInVzZXJJZFwiOjY0MzE2NjcxLFwicm9sZUlkXCI6NjQzMTY2NzEsXCJmYWNlYm9va0xvZ2luXCI6ZmFsc2UsXCJtb2JpbGVMb2dpblwiOnRydWUsXCJyb2xlXCI6e1wicGVybWlzc2lvbnNcIjpbe1widHlwZVwiOntcInR5cGVcIjo4fSxcImxldmVsXCI6e1wibGV2ZWxcIjo4fX0se1widHlwZVwiOntcInR5cGVcIjo5fSxcImxldmVsXCI6e1wibGV2ZWxcIjo4fX0se1widHlwZVwiOntcInR5cGVcIjoxMH0sXCJsZXZlbFwiOntcImxldmVsXCI6MX19LHtcInR5cGVcIjp7XCJ0eXBlXCI6MTJ9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjR9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjd9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjh9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjZ9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjZ9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjF9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjR9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjR9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjZ9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjN9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjB9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjJ9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjR9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjExfSxcImxldmVsXCI6e1wibGV2ZWxcIjoxfX1dfSxcIndhdGNoXCI6dHJ1ZX0iLCJpYXQiOjE2NjIzNTQyNjksImV4cCI6MTY3MDk5NDI2OX0.QdAunjGcq8ZYE1xqTQlXFQ6AlxK2KGjwUZBHZA79JhM';
  final apiClient = dio.Dio(dio.BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: 15000,
      receiveTimeout: 15000,
      validateStatus: (status) {
        return status! < 500;
      }

      // 200  response code ... you are good
      // 400 response code ... means validation error... like in valid data
      // 401 .. 403 ... issue with login... you will get error message
      ));

  final ErrorHandlingService _errorHandlingService = locator<ErrorHandlingService>();

  Future apiWrapper(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    bool authenticated = false,
  }) async {
    print("IN API Wrapper $path");
    print(data);

    if (authenticated) {
      print("AUTHENTICATED");

      if (options == null) {
        options = dio.Options(headers: {'excludeToken': true});
      }
      print("options $options");
      // options.headers!["excludeToken"] = true;
    }

    try {
      late dio.Response res;
      if (data == null) {
        res = await apiClient.get(path, options: options, queryParameters: queryParameters);
      } else if (options == null ||
          options.method == null ||
          options.method!.toLowerCase() == "post") {
        res = await apiClient.post(path,
            data: data, queryParameters: queryParameters, options: options);
      } else if (options.method!.toLowerCase() == "put") {
        res = await apiClient.put(path,
            data: data, queryParameters: queryParameters, options: options);
      }
      print("res = $res and path = $path");
      if (res.statusCode == 401) {
        return null;
      }

      print("Fetched Raw Response From API");
      Map resJSON = res.data;
      print("Response converted to json");

      if (resJSON.containsKey("error") == true) {
        throw Exception(resJSON["error"]);
      }

      return resJSON;
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.connectTimeout) {
        _errorHandlingService.showError(Errors.PoorConnection);
      }
    } catch (e, stacktrace) {
      Fimber.e("Api Service error", ex: e, stacktrace: stacktrace);
      if (e.toString().contains("Unauthorized")) {
        if (locator<HomeController>().isLoggedIn) {
          try {
            await BaseController.logout();
            await locator<HomeController>().updateIsLoggedIn();
          } catch (e) {
            Fimber.e("Error while logging out: ${e.toString()}");
          }
        }
      }
    }
  }

  // Future<Order2?> createGroupOrder({
  //   CustomerDetails? customerDetails,
  //   Payment? payment,
  //   List<Orderv2>? products,
  // }) async {
  //   try {
  //     try {
  //       print("--------- api testing ----------");
  //       print(customerDetails);
  //       print(products![0].productId);
  //       print(payment);
  //       print(locator<HomeController>().details!.key);

  //       final response = await apiWrapper("v2/orders",
  //           authenticated: true,
  //           options: dio.Options(
  //               headers: {
  //                 'excludeToken': false,
  //                 'Authorisation' : userToken},
  //               method: "POST"),
  //           data: {
  //             "customerDetails" : customerDetails,
  //             "orders" : products,
  //             "payment" : payment
  //             // "customerDetails": {
  //             //   "address": "test billing address",
  //             //   "city": "test billing city",
  //             //   "state": "test billing state",
  //             //   "pincode": "380060",
  //             //   "country": "india"
  //             // },
  //             // "orders": [
  //             //   {
  //             //     "productId": 83885946,
  //             //     "variation": {"size": "xl", "quantity": 1, "color": "pink"},
  //             //     "orderQueue": {"clientQueueId": 1}
  //             //   }
  //             // ]
  //           }
  //           );
  //       print("response data");
  //       print(response);

  //       if (response != null) {
  //         final orderResponse = GroupOrderReponseModel.fromJson(response);
  //         print("order response");
  //         print(orderResponse);
  //       }
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   } on SocketException catch (_) {
  //     Fluttertoast.showToast(
  //         msg: "No Internet Connection",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
}
