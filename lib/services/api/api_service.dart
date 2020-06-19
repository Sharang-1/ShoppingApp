import 'dart:async';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/models/categorys.dart';
import 'package:compound/models/orders.dart';
import 'package:compound/models/payment_options.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/models/reviews.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/models/tailors.dart';
import 'package:compound/models/user_details.dart';
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
      baseUrl: "http://52.66.141.191/api/",
      connectTimeout: 15000,
      receiveTimeout: 15000,
      validateStatus: (status) {
        return status < 500;
      }

      // 200  response code ... you are good
      // 400 response code ... means validation error... like in valid data
      // 401 .. 403 ... issue with login... you will get error message
      ));
  // final excludeToken = Options(headers: {"excludeToken": true});
  final DialogService _dialogService = locator<DialogService>();

  APIService() {
    apiClient..interceptors.addAll([AppInterceptors(), CustomLogInterceptor()]);
  }

  // Future<T> mApiWrapper<T extends genericModel>() async {
  //   var data = await apiWrapper("products");
  //   if (data != null) {
  //     T products = T.fromJson(data);
  //     Fimber.d("products : " + products.items.map((o) => o.name).toString());
  //     return products;
  //   }
  //   return products;
  // }

  Future apiWrapper(String path,
      {data,
      Map<String, dynamic> queryParameters,
      Options options,
      bool authenticated = false}) async {
    // if (authenticated) {
    //   options.headers["excludeToken"] = true;
    // }

    if (authenticated) {
      if (options == null) {
        options = Options();
      }
      options.headers["excludeToken"] = true;
    }
    // Options tempOptions = options;
    // if (options == null) {
    //   tempOptions = excludeToken;
    // } else {
    //   tempOptions = options;
    // }

    try {
      Response res;
      if (data == null) {
        res = await apiClient.get(path,
            options: options, queryParameters: queryParameters);
      } else if(options ==null || options.method==null || options.method.toLowerCase() == "post") {
        res = await apiClient.post(path,
            data: data, queryParameters: queryParameters, options: options);
      } else if(options.method.toLowerCase() == "put") {
        res = await apiClient.put(path,
            data: data, queryParameters: queryParameters, options: options);
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
    return apiWrapper("message/generateOtpToLogin", data: {"mobile": phoneNo});
  }

  Future verifyOTP({@required String phoneNo, @required String otp}) {
    return apiWrapper("message/verifyOtpToLogin",
        data: {"mobile": phoneNo}, queryParameters: {"otp": otp});
  }

  // Use regex of API Class Name
  //Future<ApiClassName> getApiClassName() async {
  //   var mApiClassNameData = await apiWrapper("ApiClassName");
  //   if (mApiClassNameData != null) {
  //     ApiClassName mApiClassName = ApiClassName.fromJson(mApiClassNameData);
  //     Fimber.d("mApiClassNameData : " + mApiClassNameData.items.map((o) => o.name).toString());
  //     return mApiClassNameData;
  //   }
  //   return null;
  // }

  Future<Reviews> getReviews({String productId}) async {
    var mReviewsData = await apiWrapper("products/$productId/reviews");
    if (mReviewsData != null) {
      Reviews mReviews = Reviews.fromJson(mReviewsData);
      Fimber.d("mReviewsData : " +
          mReviews.items.map((o) => o.description).toString());
      return mReviews;
    }
    return null;
  }

  Future<Products> getProducts({String queryString = ""}) async {
    var productData = await apiWrapper("products;$queryString");
    if (productData != null) {
      Products products = Products.fromJson(productData);
      Fimber.d("products : " + products.items.map((o) => o.name).toString());
      return products;
    }
    return null;
  }

  Future<Promotions> getPromotions() async {
    var promotionsData = await apiWrapper("promotions:active=true");
    if (promotionsData != null) {
      Promotions promotions = Promotions.fromJson(promotionsData);
      Fimber.d("promotions : " +
          promotions.promotions.map((o) => o.name).toString());
      return promotions;
    }
    return null;
  }

  Future<Categorys> getCategory({String queryString = ""}) async {
    var category = await apiWrapper("categories?context=subCategory");
    if (category != null) {
      Categorys categoryData = Categorys.fromJson(category);
      Fimber.d("Subcategories : " +
          categoryData.items.map((o) => o.name).toString());
      return categoryData;
    }
    return null;
  }

  Future<Sellers> getSellers({String queryString = ""}) async {
    var sellersData = await apiWrapper("sellers;$queryString");
    if (sellersData != null) {
      Sellers sellers = Sellers.fromJson(sellersData);
      Fimber.d("Sellers : " + sellers.items.map((o) => o.name).toString());
      return sellers;
    }
    return null;
  }

  Future<Seller> getSellerByID(String id) async {
    var sellersData = await apiWrapper("sellers/$id");
    if (sellersData != null) {
      Seller seller = Seller.fromJson(sellersData);
      Fimber.d("Seller : " + seller.name);
      return seller;
    }
    return null;
  }

  Future<Tailors> getTailors() async {
    var tailorsData = await apiWrapper("tailors", authenticated: true);
    if (tailorsData != null) {
      Tailors tailors = Tailors.fromJson(tailorsData);
      Fimber.d("Tailors : " + tailors.items.map((o) => o.name).toString());
      return tailors;
    }
    return null;
  }

  Future<dynamic> getCart({ String queryString = "" }) async {
    var cartData = await apiWrapper("carts/my?context=productDetails",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}));
    if (cartData != null) {
      print("...............Cart...............................");
      print(cartData);
      print("..................................................");
      // Tailors tailors = Tailors.fromJson(cartData);
      // Fimber.d("Tailors : " + tailors.tailors.map((o) => o.name).toString());
      try {
        Cart cart = Cart.fromJson(cartData);
        return cart;
      } catch(err) {
        print(err);
        return null;
      }
    }
    return null;
  }

  Future<dynamic> addToCart(String productId, int qty, String size) async {
    var cartData = await apiWrapper(
      "carts/?context=add",
      authenticated: true,
      options: Options(headers: {'excludeToken': false}, method: "put"),
      data: {
        "items": [
          {
            "productId": productId,
            "quantity": qty, 
            "size": size
          }
        ]
      }
    );
    if (cartData != null) {
      print("...............Cart Item added...............................");
      print(cartData);
      print("..................................................");
      return cartData;
    }
    return null;
  }

  Future<dynamic> removeFromCart(int productId) async {
    var cartData = await apiWrapper(
      "carts/?context=remove",
      authenticated: true,
      options: Options(headers: {'excludeToken': false}),
      data: {
        "items": [
          {
            "productId": productId,
          }
        ]
      }
    );
    if (cartData != null) {
      print("...............Cart Item Removed ..............................");
      print(cartData);
      print("..................................................");
      return cartData;
    }
    return null;
  }

  Future<Orders> getAllOrders() async {
    var ordersData = await apiWrapper("orders",authenticated: true);
    if(ordersData != null){
      return Orders.fromJson(ordersData);
    }
  }

  Future<UserDetails> getUserData() async {
    var userData = await apiWrapper("users/me",authenticated: true);
    if(userData != null){
      return UserDetails.fromJson(userData);
    }
  }

  Future<List<PaymentOption>> getPaymentOptions() async {
    var mPaymentOptionsData = await apiWrapper("payments/options");
    if(mPaymentOptionsData != null){
      return paymentOptionsFromJson(mPaymentOptionsData);
    }
  }

  // List<PaymentOption> mPaymentOptions;
  // Future getPaymentOptions() async {

  //   setBusy(true);
  //   final result = await _APIService.getPaymentOptions();
  //   setBusy(false);
  //   if (result != null) {
  //     mPaymentOptions = result;
  //   }
  //   notifyListeners();
  // }
}
