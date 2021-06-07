import 'dart:async';
import 'dart:io';

import 'package:compound/models/queue.dart';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/server_urls.dart';
import '../../constants/shared_pref.dart' as SharedPrefConstants;
import '../../locator.dart';
import '../../models/Appointments.dart';
import '../../models/TimeSlots.dart';
import '../../models/appUpdate.dart';
import '../../models/app_info.dart';
import '../../models/calculatedPrice.dart';
import '../../models/cart.dart' as CartModule;
import '../../models/categorys.dart';
import '../../models/lookups.dart';
import '../../models/order.dart' as OrderModule;
import '../../models/orders.dart';
import '../../models/payment_options.dart';
import '../../models/products.dart';
import '../../models/promoCode.dart';
import '../../models/promotions.dart';
import '../../models/reviews.dart';
import '../../models/sellerProfile.dart';
import '../../models/sellers.dart';
import '../../models/service_availability.dart';
import '../../models/tailors.dart';
import '../../models/user_details.dart';
import '../dialog_service.dart';
import '../error_handling_service.dart';
import 'AppInterceptor.dart';
import 'CustomLogInterceptor.dart';
import 'performance_interceptor.dart';

class APIService {
  final apiClient = Dio(BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: 15000,
      receiveTimeout: 15000,
      validateStatus: (status) {
        return status < 500;
      }

      // 200  response code ... you are good
      // 400 response code ... means validation error... like in valid data
      // 401 .. 403 ... issue with login... you will get error message
      ));

  final appointmentClient = Dio(BaseOptions(
      baseUrl: APPOINTMENT_URL,
      connectTimeout: 15000,
      receiveTimeout: 15000,
      validateStatus: (status) {
        return status < 500;
      }));

  // final excludeToken = Options(headers: {"excludeToken": true});
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  APIService() {
    apiClient
      ..interceptors.addAll([
        AppInterceptors(),
        RetryInterceptor(
          dio: apiClient,
          options: RetryOptions(
            retryInterval: Duration(milliseconds: 500),
            retries: 3,
          ),
        ),
        CustomLogInterceptor(),
        if (kReleaseMode) PerformanceInterceptor()
      ]);
    appointmentClient
      ..interceptors.addAll([
        AppInterceptors(),
        CustomLogInterceptor(),
        if (kReleaseMode) PerformanceInterceptor()
      ]);
  }
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
      print("Fetched Raw Response From API");
      Map resJSON = res.data;
      print("Response converted to json");

      if (resJSON.containsKey("error") == true) {
        throw Exception(resJSON["error"]);
      }

      return resJSON;
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        _errorHandlingService.showError(Errors.PoorConnection);
      }
    } catch (e, stacktrace) {
      // if(!((e.toString().startsWith("Exception: Seller profile photo for")))){
      Fimber.e("Api Service error", ex: e, stacktrace: stacktrace);
      //   GetModule.Get.snackbar(
      //   "Error",
      //   e.toString(),
      //   snackPosition: GetModule.SnackPosition.BOTTOM,
      //   isDismissible: true,
      //   snackStyle: GetModule.SnackStyle.FLOATING,
      //   margin: EdgeInsets.only(
      //     bottom: 20,
      //     left: 10,
      //     right: 10,
      //   ),
      //  );
      // }
    }
  }

  Future sendOTP({@required String phoneNo}) {
    return apiWrapper("message/generateOtpToLogin", data: {"mobile": phoneNo});
  }

  Future verifyOTP(
      {@required String phoneNo, @required String otp, @required String fcm}) {
    return apiWrapper(
      "message/verifyOtpToLogin",
      data: {"mobile": phoneNo},
      queryParameters: {"otp": otp, "device": fcm},
    );
  }

  Future<List<Lookups>> getLookups() async {
    var lookupRes = await apiClient.get("options");
    var lookupData = lookupRes.data;
    if (lookupData != null) {
      List<Lookups> lookups =
          lookupData.map<Lookups>((e) => Lookups.fromJson(e)).toList();
      print(lookups);
      return lookups;
    }

    return null;
  }

  Future<AppInfo> getAppInfo() async {
    AppInfo appInfo;
    var json = await apiWrapper("app/info");
    if (json != null) appInfo = AppInfo.fromJson(json);
    return appInfo;
  }

  Future<Reviews> getReviews(String key, {bool isSellerReview = false}) async {
    String query =
        isSellerReview ? "sellers/$key/reviews" : "products/$key/reviews";
    var mReviewsData = await apiWrapper(query);
    if (mReviewsData != null) {
      Reviews mReviews = Reviews.fromJson(mReviewsData);
      return mReviews;
    }
    return null;
  }

  Future postReview(String key, double ratings, String description,
      {bool isSellerReview = false}) {
    String query =
        isSellerReview ? "sellers/$key/reviews" : "products/$key/reviews";

    return apiWrapper(query,
        data: {"rating": ratings, "description": description});
  }

  Future<bool> hasReviewed(String productKey, {bool isSeller = false}) async {
    UserDetails ud = await getUserData();
    Reviews reviews = await getReviews(productKey, isSellerReview: isSeller);
    reviews.items =
        reviews.items.where((element) => element.userId == ud.key).toList();
    return reviews.items.isNotEmpty;
  }

  Future<Products> getProducts(
      {String queryString = "", bool explore = false}) async {
    var productData = await apiWrapper(
        "products;${queryString}seller=true;active=true" +
            (explore ? ";explore=true" : ""));
    if (productData != null) {
      Products products = Products.fromJson(productData);
      Fimber.d("products : " + products.items.map((o) => o.name).toString());
      return products;
    }
    return null;
  }

  Future<bool> hasProducts({String sellerKey, String category}) async {
    Products products;
    if (sellerKey != null)
      products = await getProducts(queryString: 'accountKey=$sellerKey;');
    else if (category != null)
      products = await getProducts(queryString: 'category=$category;');

    products.items =
        products.items.where((p) => (p.enabled && p.available)).toList();
    return products.items.isNotEmpty;
  }

  Future<Product> getProductById(
      {@required String productId, bool withCoupons = false}) async {
    if (productId == null) return null;
    var productData = withCoupons
        ? await apiWrapper(
            "products/$productId;seller=true;active=true;promocode=true")
        : await apiWrapper("products/$productId;seller=true;active=true");
    if (productData == null) return null;
    Product product = Product.fromJson(productData);
    return product;
  }

  Future<Products> getWishlistProducts({
    List<String> list,
  }) async {
    final futureList = list.map<Future<Product>>((id) async {
      final productData =
          await apiWrapper("products/$id;seller=true;active=true");
      if (productData != null) {
        Product singleProduct = Product.fromJson(productData);
        return singleProduct;
      }
      return null;
    });

    final resolvedList = await Future.wait(futureList);
    final filteredList =
        resolvedList.where((element) => element != null).toList();

    Products data = Products(
      records: filteredList.length,
      startIndex: 0,
      limit: filteredList.length,
      items: filteredList,
    );

    return data;
  }

  Future<Promotions> getPromotions() async {
    var promotionsData = await apiWrapper("promotions;active=true");
    if (promotionsData != null) {
      try {
        Promotions promotions = Promotions.fromJson(promotionsData);
        Fimber.d("promotions : " +
            promotions.promotions.map((o) => o.name).toString());
        return promotions;
      } catch (e) {
        print(e);
        Fimber.e("TestError");
        Fimber.e(e);
        return null;
      }
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
    var sellersData = await apiWrapper("sellers;$queryString;active=true");
    if (sellersData != null) {
      Sellers sellers = Sellers.fromJson(sellersData);
      Fimber.d("Sellers : " + sellers.items.map((o) => o.name).toString());
      return sellers;
    }
    return null;
  }

  Future<Seller> getSellerByID(String id) async {
    var sellersData = await apiWrapper("sellers/$id;rating=true");
    if (sellersData != null) {
      Seller seller = Seller.fromJson(sellersData);
      Fimber.d("Seller : " + seller.name);
      return seller;
    }
    return null;
  }

  Future<SellerProfile> getSellerProfile(String id) async {
    var sellerProfileData = await apiWrapper("sellers/$id/profile");
    if (sellerProfileData != null) {
      SellerProfile sellerProfile = SellerProfile.fromMap(sellerProfileData);
      Fimber.d(
          "Sellers : " + sellerProfile.photos.map((o) => o.name).toString());
      return sellerProfile;
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

  Future<CartModule.Cart> getCart({String queryString = ""}) async {
    var cartData = await apiWrapper("carts/my?context=productDetails",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}));
    if (cartData != null) {
      try {
        CartModule.Cart cart = CartModule.Cart.fromJson(cartData);
        Fimber.d("Cart : " + cart.items.map((o) => o.productId).toString());
        return cart;
      } catch (err) {
        print(err);
        return null;
      }
    }
    return null;
  }

  Future<List<String>> getCartProductItemList() async {
    var cartData = await apiWrapper("carts/my?context=productDetails",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}));
    if (cartData != null) {
      try {
        CartModule.Cart cart = CartModule.Cart.fromJson(cartData);
        Fimber.d("Cart : " + cart.items.map((o) => o.productId).toString());
        final list = cart.items.map((e) => e.productId.toString()).toList();
        return list;
      } catch (err) {
        print("Error in api_service.dart > getCartProductItemList");
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
        return calPrice;
      } catch (err) {
        print("Calculated Price Error : ${err.toString()}");
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
        return promoCode;
      } catch (err) {
        return null;
      }
    }
    return null;
  }

  Future<ServiceAvailability> checkPincode(
      {@required String productId, @required String pincode}) async {
    final json = await apiWrapper(
      "products/$productId/pincode",
      queryParameters: {
        "pincode": pincode,
      },
      authenticated: true,
      options: Options(headers: {'excludeToken': false}, method: "GET"),
    );

    if (json == null || json['serviceAvailable'] == null) return null;

    final serviceAvailability = ServiceAvailability.fromJson(json);
    return serviceAvailability;
  }

  Future<OrderModule.Order> createOrder(
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
      "orders​/?context=productDetails",
      authenticated: true,
      options: Options(headers: {'excludeToken': false}, method: "POST"),
      data: {
        "billingAddress": billingAddress,
        "productId": productId,
        if (promoCode.isNotEmpty) "promocode": promoCode,
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
        Queue queue = Queue.fromJson(orderData);
        String queueId = queue.queueId;
        while ((queue.status == "QUEUE") || (queue.status == "PROCESS")) {
          queue = Queue.fromJson(await apiWrapper(
              "orders​/queue/$queueId/status",
              authenticated: true));
        }
        OrderModule.Order order = OrderModule.Order.fromJson(await apiWrapper(
            "orders/${queue.orderId};product=true",
            authenticated: true));
        Fimber.d("Order : " + order.key);
        return order;
      } catch (err) {
        Fimber.e(err.toString());
        return null;
      }
    }

    return null;
  }

  Future<Orders> getAllOrders() async {
    var ordersData =
        await apiWrapper("orders;product=true", authenticated: true);
    if (ordersData != null) {
      Orders orders = Orders.fromJson(ordersData);
      orders.orders.sort((a, b) {
        DateTime aDateTime = DateTime.parse(
            "${a.created.substring(6, 10)}${a.created.substring(3, 5)}${a.created.substring(0, 2)}");
        DateTime bDateTime = DateTime.parse(
            "${b.created.substring(6, 10)}${b.created.substring(3, 5)}${b.created.substring(0, 2)}");
        return bDateTime.compareTo(aDateTime);
      });
      return orders;
    }
    return null;
  }

  Future<OrderModule.Order> verifyPayment(
      {String orderId,
      String paymentId,
      String signature,
      String msg,
      bool success = true}) async {
    var json = await apiWrapper("orders/$orderId/payment",
        authenticated: true,
        options: Options(headers: {'excludeToken': false}, method: "post"),
        data: {
          if (paymentId != null) "paymentId": paymentId,
          if (signature != null) "signature": signature,
          "message": msg,
          "status": success ? "succeed" : "failed",
        });

    if (json != null) {
      try {
        Queue queue = Queue.fromJson(json);
        String queueId = queue.queueId;
        while ((queue.status == "QUEUE") || (queue.status == "PROCESS")) {
          queue = Queue.fromJson(await apiWrapper(
              "orders​/payment/queue/$queueId/status",
              authenticated: true));
        }
        OrderModule.Order order = OrderModule.Order.fromJson(await apiWrapper(
            "orders/${queue.orderId};product=true",
            authenticated: true));
        Fimber.d("Order : " + order.key);
        return order;
      } catch (err) {
        Fimber.e(err.toString());
        return null;
      }
    }
    print("Razor Success: ${json.toString()}");
    return null;
  }

  Future<UserDetails> getUserData() async {
    var userData = await apiWrapper("users/me", authenticated: true);
    if (userData != null) {
      return UserDetails.fromJson(userData);
    }
    return null;
  }

  Future<String> updateUserName([String name]) async {
    if (name == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      name = prefs.getString(SharedPrefConstants.Name);
    }
    UserDetails user = await getUserData();
    user.name = name;
    await updateUserData(user, onlyName: true);
    return name;
  }

  Future<UserDetails> updateUserData(UserDetails mUserDetails,
      {bool onlyName = false}) async {
    var userData = await apiWrapper("users/" + mUserDetails.key,
        authenticated: true,
        data: onlyName
            ? {
                "name": mUserDetails.name,
              }
            : userDetailsToJson(mUserDetails),
        options: Options(headers: {'excludeToken': false}, method: "put"));
    if (userData != null) {
      return UserDetails.fromJson(userData);
    }
    return null;
  }

  Future<List<PaymentOption>> getPaymentOptions() async {
    var mPaymentOptionsData = await apiWrapper("payments/options");
    if (mPaymentOptionsData != null) {
      return paymentOptionsFromJson(mPaymentOptionsData);
    }
    return null;
  }

  Future<Appointments> getUserAppointments() async {
    var res = await appointmentClient.get("");
    Appointments data;
    try {
      if (res.data != null) data = Appointments.fromJson(res.data);
    } catch (e) {
      String error = res.data["error"];
      Fimber.e(error);
    }
    return data;
  }

  Future<String> cancelAppointment(String id, String msg) async {
    var res = await appointmentClient.post("$id/action", data: {
      "action": "0",
      "status": 2,
      "customerMessage": msg,
    });
    if (res.statusCode != HttpStatus.ok) {
      return res.data;
    }
    return null;
  }

  Future<TimeSlots> getAvaliableTimeSlots(String sellerId) async {
    var res = await appointmentClient.get("availableSlot?sellerId=$sellerId");
    try {
      if (res.data != null) return TimeSlots.fromJson(res.data);
    } catch (e) {
      DialogService.showDialog(description: res.data["error"], title: "Note");
    }
    return null;
  }

  Future<String> bookAppointment(String sellerId, String timeSlotStart,
      String timeSlotEnd, String customerMessage) async {
    var res = await appointmentClient.post("", data: {
      "sellerId": sellerId,
      "timeSlotStart": timeSlotStart,
      "timeSlotEnd": timeSlotEnd,
      "customerMessage": customerMessage
    });
    if (res.statusCode != HttpStatus.ok) {
      return res.data["error"];
    }
    return null;
  }

  Future<AppUpdate> getAppUpdate() async {
    var res = await apiClient.get("release/app");
    if (res.data != null) return AppUpdate.fromJson(res.data);
    return null;
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
