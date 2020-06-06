import 'dart:async';

import 'package:compound/models/order.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';

import 'package:compound/services/api/AppInterceptor.dart';
import 'package:compound/services/api/CustomLogInterceptor.dart';

import 'package:compound/models/calculatedPrice.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/models/categorys.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/promoCode.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/models/reviews.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/models/tailors.dart';

import '../../locator.dart';
import '../dialog_service.dart';

class APIService {
  final DialogService _dialogService = locator<DialogService>();

  APIService() {
    apiClient..interceptors.addAll([AppInterceptors(), CustomLogInterceptor()]);
  }

  final apiClient = Dio(
    BaseOptions(
      baseUrl: "http://52.66.141.191/api/",
      connectTimeout: 15000,
      receiveTimeout: 15000,
      validateStatus: (status) {
        // 200  response code ... you are good
        // 400 response code ... means validation error... like in valid data
        // 401 .. 403 ... issue with login... you will get error message
        return status < 500;
      },
    ),
  );

  Future apiWrapper(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    bool authenticated = false,
  }) async {
    if (authenticated) {
      if (options == null) {
        options = Options();
      }
      options.headers["excludeToken"] = true;
    }

    try {
      Response res;
      if (data == null) {
        res = await apiClient.get(path,
            options: options, queryParameters: queryParameters);
      } else if (options == null ||
          options.method == null ||
          options.method.toLowerCase() == "post") {
        res = await apiClient.post(path,
            data: data, queryParameters: queryParameters, options: options);
      } else if (options.method.toLowerCase() == "put") {
        res = await apiClient.put(path,
            data: data, queryParameters: queryParameters, options: options);
      }
      Map resJSON = res.data;
      print("Debug api wrapper");
      print(res);
      print(res.data);
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

  Future<Cart> getCart({String queryString = ""}) async {
    var cartData = await apiWrapper("carts/my?context=productDetails",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}));
    if (cartData != null) {
      try {
        Cart cart = Cart.fromJson(cartData);
        Fimber.d("Cart : " + cart.items.map((o) => o.productId).toString());
        return cart;
      } catch (err) {
        print(err);
        return null;
      }
    }
    return null;
  }

  Future<dynamic> addToCart(
      String productId, int qty, String size, String color) async {
    var cartData = await apiWrapper("carts/?context=add",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}, method: "put"),
        data: {
          "items": [
            {
              "productId": productId,
              "quantity": qty,
              "size": size,
              "color": color
            }
          ]
        });
    if (cartData != null) {
      Fimber.d("Cart Item Added : " + cartData.toString());
      return cartData;
    }
    return null;
  }

  Future<dynamic> removeFromCart(int productId) async {
    var cartData = await apiWrapper("carts/?context=remove",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}, method: "PUT"),
        data: {
          "items": [
            {
              "productId": productId,
            }
          ]
        });
    if (cartData != null) {
      Fimber.d("Cart Item Removed : " + cartData.toString());
      return cartData;
    }
    return null;
  }

  Future<CalculatedPrice> calculateProductPrice(
      String productId, int qty) async {
    final quantity = qty >= 1 ? qty : 1;
    final calculatedPriceData = await apiWrapper(
        "orders​/cost?productKey=$productId&quantity=$quantity",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}));
    if (calculatedPriceData != null) {
      try {
        CalculatedPrice calPrice =
            CalculatedPrice.fromJson(calculatedPriceData);
        Fimber.d("Calculated Price : " + calPrice.cost.toString());
        return calPrice;
      } catch (err) {
        print("Calculated Price Error : ");
        print(err);
        return null;
      }
    }
    return null;
  }

  Future<PromoCode> applyPromocode(
      String productId, int qty, String code, String promotion) async {
    final quantity = qty >= 1 ? qty : 1;
    final promoCodeData = await apiWrapper(
        "orders​/cost?productKey=$productId&quantity=$quantity&promocode=$code&&promotionId=$promotion",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}));
    if (promoCodeData != null) {
      try {
        PromoCode promoCode = PromoCode.fromJson(promoCodeData);
        Fimber.d("Apply promocode : " + promoCode.productId.toString());
        return promoCode;
      } catch (err) {
        print(err);
        return null;
      }
    }
    return null;
  }

  Future<Order> createOrder(
    String billingAddress,
    String productId,
    String promoCode,
    String promoCodeId,
    String size,
    String color,
    int qty,
    int paymentOptionId,
  ) async {
    final quantity = qty >= 1 ? qty : 1;

    final orderData = await apiWrapper(
      "orders​/",
      authenticated: true,
      options: Options(headers: {'excludeToken': false}, method: "POST"),
      data: {
        "billingAddress": billingAddress,
        "productId": productId,
        "promoCode": promoCode,
        "variation": {
          "size": size,
          "quantity": quantity,
          "color": color,
        },
        "payment": {
          "option": {
            "id": paymentOptionId,
          }
        }
      },
    );

    if (orderData != null) {
      try {
        Order order = Order.fromJson(orderData);
        Fimber.d("Order : " + order.key);
        return order;
      } catch (err) {
        print(err);
        return null;
      }
    }

    return null;
  }
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
