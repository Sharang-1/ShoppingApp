import 'dart:async';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/models/subcategories.dart';
import 'package:compound/models/tailors.dart';
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
      connectTimeout: 5000,
      receiveTimeout: 5000,
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



  // Future<T> mApiWrapper<T>() async {
  //   var data = await apiWrapper("products");
  //   if (data != null) {
  //     T products = T.fromJson(data);
  //     Fimber.d("products : " + products.items.map((o) => o.name).toString());
  //     return products;
  //   }
  //   return T;
  // }

  Future apiWrapper(String path,
      {data, Map<String, dynamic> queryParameters, Options options, bool authenticated = false}) async {
        
    if(authenticated){
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
      } else {
        res = await apiClient.post(path,
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
    return apiWrapper("message/generateOtpToLogin",
        data: {"mobile": phoneNo});
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

  Future<Products> getProducts({ String queryString = "" }) async {
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
      Fimber.d("promotions : " + promotions.promotions.map((o) => o.name).toString());
      return promotions;
    }
    return null;
  }

  Future<Subcategories> getSubCategories() async {
    var subCategories = await apiWrapper("categories?context=subCategory");
    if (subCategories != null) {
      Subcategories subcategories = Subcategories.fromJson(subCategories);
      Fimber.d("Subcategories : " + subcategories.categories.map((o) => o.name).toString());
      return subcategories;
    }
    return null;
  }


  Future<Sellers> getSellers() async {
    var sellersData = await apiWrapper("sellers");
    if (sellersData != null) {
      Sellers sellers = Sellers.fromJson(sellersData);
      Fimber.d("Sellers : " + sellers.sellers.map((o) => o.name).toString());
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
    var tailorsData = await apiWrapper("tailors",authenticated: true);
    if (tailorsData != null) {
      Tailors tailors = Tailors.fromJson(tailorsData);
      Fimber.d("Tailors : " + tailors.tailors.map((o) => o.name).toString());
      return tailors;
    }
    return null;
  }
}
