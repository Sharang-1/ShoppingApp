import 'dart:convert';

// import 'package:compound/models/cart.dart';
import 'package:compound/app/app.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:http/http.dart' as http;

import '../constants/route_names.dart';
import '../constants/server_urls.dart';
import '../constants/shared_pref.dart';
import '../controllers/cart_count_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../locator.dart';
import '../models/productPageArg.dart';
import '../models/promotions.dart';
import '../models/user_details.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/cart_local_store_service.dart';
import '../services/localization_service.dart';
import '../services/location_service.dart';
import '../services/navigation_service.dart';
import '../services/wishlist_service.dart';
import 'base_controller.dart';
import 'dynamic_content_controller.dart';

class HomeController extends BaseController {
  late RefreshController refreshController;
  final _cartLocalStoreService = locator<CartLocalStoreService>();
  final _wishListService = locator<WishListService>();
  final _apiService = locator<APIService>();
  final _authService = locator<AuthenticationService>();

  final searchController = TextEditingController();
  UniqueKey? key, productKey, sellerKey, categoryKey, promotionKey;
  String cityName = "Add Location";
  String name = "";
  // RemoteConfig? remoteConfig;
  SharedPreferences? prefs;
  UserDetails? details;
  List<Promotion> topPromotion = [], bottomPromotion = [];
  bool isProfileComplete = true;
  bool isLoggedIn = false;
  String? currentLanguage;

  onRefresh({context, args}) async {
    try {
      // if (remoteConfig == null)
      // remoteConfig = _remoteConfigService.remoteConfig;
      setup();
      // await remoteConfig!.fetch();
      // await remoteConfig.activateFetched();
      // await remoteConfig!.activate();
    } catch (e) {
      print(e.toString());
    }

    await updateIsLoggedIn();

    // try {
    //   UserLocation? currentLocation = await locator<LocationService>().getLocation();

    //   if (currentLocation != null) {
    //     List<Placemark> addresses = await placemarkFromCoordinates(
    //       currentLocation.latitude!,
    //       currentLocation.longitude!,
    //     );
    //     // List<Address> addresses =
    //     //     await Geocoder.local.findAddressesFromCoordinates(
    //     //   Coordinates(
    //     //     currentLocation.latitude,
    //     //     currentLocation.longitude,
    //     //   ),
    //     // );
    //     cityName = addresses[0].locality!;
    //     if (cityName.contains("null")) cityName = "Add Location";
    //   }
    // } catch (e) {
    //   print(e.toString());
    // }

    key = UniqueKey();
    productKey = UniqueKey();
    sellerKey = UniqueKey();
    categoryKey = UniqueKey();
    promotionKey = UniqueKey();

    // int? counter;
    // checkCount() async {
    //   final prefs = await SharedPreferences.getInstance();

    //   counter = prefs.getInt('promotion_product_share');
    //   // return counter;
    // }

    List<Promotion> promotions = await getPromotions();
    topPromotion = promotions
        .where((element) => element.position!.toLowerCase() == "top")
        .toList();
    bottomPromotion = promotions
        .where((element) => element.position!.toLowerCase() == "bottom")
        .toList();

    await updateUserDetails();
    update();

    await Future.delayed(Duration(milliseconds: 100));
    refreshController.refreshCompleted(resetFooterState: true);

    if (args != null) {
      try {
        var data = args['dynamicContent'];
        if (data != null) {
          await DynamicContentController.navigate(context, data);
        }
      } catch (e) {
        print("Dynamic Link Error : $e");
      }
    }
  }

  Future<void> updateIsLoggedIn() async {
    isLoggedIn = await _authService.isUserLoggedIn();
    App.isUserLoggedIn = isLoggedIn;
  }

  Future<void> updateUserDetails() async {
    if (isLoggedIn) {
      details = await _apiService.getUserData() ?? UserDetails();
      if ((details?.contact?.address?.isEmpty ?? true) ||
          (details?.contact?.googleAddress?.isEmpty ?? true)) {
        isProfileComplete = false;
      }
    }
  }

  setup() async {
    locator<CartCountController>()
        .setCartCount(await setUpCartListAndGetCount());
    locator<WishListController>()
        .setUpWishList(await _wishListService.getWishList());

    if (prefs == null) prefs = await SharedPreferences.getInstance();
    currentLanguage = prefs!.getString(CurrentLanguage) ?? "";
    currentLanguage = currentLanguage == "" ? 'English' : currentLanguage;
  }

  @override
  void onInit() async {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    key = UniqueKey();
    productKey = UniqueKey();
    sellerKey = UniqueKey();
    categoryKey = UniqueKey();
    promotionKey = UniqueKey();

    // remoteConfig = _remoteConfigService.remoteConfig;

    // setup();

    await updateIsLoggedIn();

    if (isLoggedIn) {
      await updateUserDetails();
      // ? get review of last delivered products
      // final lastDeliveredProduct = await getLastDeliveredProduct();
      // if (lastDeliveredProduct != null)
      //   await DialogService.showCustomDialog(
      //     RatingDialog(
      //       onSubmitted: (val) async {
      //         await postReview(lastDeliveredProduct['id']!, val.rating.toDouble());
      //       },
      //       submitButtonText: "Submit",
      //       image: Image.network(
      //         lastDeliveredProduct["image"]!,
      //         height: 150,
      //         width: 150,
      //         errorBuilder: (context, error, stackTrace) => Image.asset(
      //           'assets/images/product_preloading.png',
      //           height: 150,
      //           width: 150,
      //         ),
      //       ),
      //       title: Text(lastDeliveredProduct["name"] ?? ""),
      //       message: Text("Tap a star to give your review."),
      //       starColor: logoRed,
      //       // positiveComment: "We’re glad you liked it!! 😊",
      //       // negativeComment:
      //       //     "Please reach us out and help us understand your concerns!",
      //       // accentColor: logoRed,
      //       // onSubmitPressed: (int rating) async {
      //       //   await postReview(lastDeliveredProduct['id']!, rating.toDouble());
      //       // },
      //     ),
      //     barrierDismissible: true,
      //   );

      final RateMyApp rateMyApp = RateMyApp(
        preferencesPrefix: 'rateMyApp_',
        minDays: 0,
        minLaunches: 0,
        remindDays: 2,
        remindLaunches: 2,
        googlePlayIdentifier: 'in.host.host_app',
        appStoreIdentifier: '1562083632',
      );

      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          await rateMyApp.init();
          if (prefs == null) prefs = await SharedPreferences.getInstance();
          int launches = prefs!.getInt('rateMyApp_launches') ?? 0;
          bool doNotOpenAgain =
              prefs!.getBool('rateMyApp_doNotOpenAgain') ?? false;

          if (!doNotOpenAgain &&
              (launches > 0) &&
              (launches % 2 == 0) &&
              (launches % 5 == 0)) {
            await rateMyApp.showRateDialog(
              Get.context!,
              title: 'host',
              onDismissed: () async {
                await prefs!.setBool('rateMyApp_doNotOpenAgain', true);
              },
            );
          }
        },
      );

      // APIService().getPromotedProduct();
    }
  }

  bool bottomNavigationOnTap(int i) {
    switch (i) {
      case 0:
        NavigationService.to(CategoriesRoute);
        break;
      case 1:
        if (isLoggedIn)
          NavigationService.to(MyOrdersRoute);
        else
          BaseController.showLoginPopup(
            nextView: MyOrdersRoute,
            shouldNavigateToNextScreen: true,
          );
        break;
      case 2:
        NavigationService.to(hostExploreViewRoute);
        break;
      case 3:
        if (isLoggedIn)
          NavigationService.to(MyAppointmentViewRoute);
        else
          BaseController.showLoginPopup(
            nextView: MyAppointmentViewRoute,
            shouldNavigateToNextScreen: true,
          );
        break;
      case 4:
        if (isLoggedIn)
          // NavigationService.to(MapViewRoute, arguments: sellerKey.toString());
          NavigationService.to(SettingsRoute);
        else
          BaseController.showLoginPopup(
            nextView: MapViewRoute,
            shouldNavigateToNextScreen: true,
          );
        break;
      default:
        break;
    }
    return false;
  }

  Future<void> onCityNameTap() async {
    if (cityName == "Add Location") {
      var location = locator<LocationService>().location;

      PermissionStatus permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if (cityName == "Add Location" &&
              locationData.latitude != null &&
              locationData.longitude != null) {
            // ignore: unused_local_variable
            UserLocation currentLocation = UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            );

            // if (currentLocation != null) {
            // Geocoder.local
            //     .findAddressesFromCoordinates(
            //   Coordinates(
            //     currentLocation.latitude,
            //     currentLocation.longitude,
            //   ),
            // )

            // placemarkFromCoordinates(
            //   currentLocation.latitude!,
            //   currentLocation.longitude!,
            // ).then((addresses) {
            //   cityName = addresses[0].locality!;
            //   if (cityName.contains("null")) cityName = "Add Location";
            //   update();
            // });
            // }
          }
        });
      }
    }
  }

  // Future<Map<String, String>?> getLastDeliveredProduct() async {
  //   ov2.Order lastDeliveredOrder =
  //       (await _apiService.getAllOrders())!.orders!.where((e) => e.status!.id == 7).first;

  //   if (lastDeliveredOrder == null) return {};
  //   if (prefs == null) prefs = await SharedPreferences.getInstance();

  //   String lastStoredOrderKey = prefs!.getString("lastDeliveredOrderKey")!;
  //   if (lastDeliveredOrder.key != null && (lastDeliveredOrder.key == lastStoredOrderKey)) return {};
  //   try {
  //     if (await _apiService.hasReviewed(lastDeliveredOrder.productId!)) return {};
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   await prefs!.setString("lastDeliveredOrderKey", lastDeliveredOrder.key!);
  //   return {
  //     "id": lastDeliveredOrder.productId!,
  //     "name": lastDeliveredOrder.product!.name!,
  //     "image":
  //         '$PRODUCT_PHOTO_BASE_URL/${lastDeliveredOrder.productId}/${lastDeliveredOrder.product!.photo!.photos!.first.name}-small.png',
  //   };
  // }

  Future postReview(String key, double ratings) async {
    try {
      _apiService.postReview(key, ratings, "");
      return;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> setUpCartListAndGetCount({bool withNetworkCall = true}) async {
    if (withNetworkCall) {
      final res = await _apiService.getCartProductItemList();
      print("Response in setUpCartList is $res");
      if (res != null) {
        await _cartLocalStoreService.setCartList(res);
        return res.length;
      }
    } else {
      var count = await _cartLocalStoreService.getCartCount();
      if (count != null) {
        return count;
      }
    }
    await _cartLocalStoreService.setCartList([]);
    return 0;
  }

  Future showProducts(String filter, String name) async {
    await NavigationService.to(
      CategoryIndiViewRoute,
      arguments: ProductPageArg(
        queryString: filter,
        subCategory: name,
      ),
    );
  }

  Future showSellers() async {
    await NavigationService.to(
      SearchViewRoute,
      arguments: true,
    );
  }

  Future<List<Promotion>> getPromotions() async {
    final promotions = await _apiService.getPromotions();
    print("promotions list here");
    return promotions.promotions!;
  }

  Future changeLocale(String lang) async {
    LocalizationService.changeLocale(lang);
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    await prefs!.setString(CurrentLanguage, lang);
    currentLanguage = lang;
  }

  String getCurrentLang() => currentLanguage ?? "English";

  void showTutorial(BuildContext context,
      {GlobalKey? searchKey, GlobalKey? logoKey}) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    if (prefs?.getBool(ShouldShowHomeTutorial) ?? true) {
      late TutorialCoachMark tutorialCoachMark;
      List<TargetFocus> targets = <TargetFocus>[
        TargetFocus(
          identify: "Search Target",
          keyTarget: searchKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: GestureDetector(
                onTap: () {
                  tutorialCoachMark.next();
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "host Search",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Search Designers and their creations",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: "host Explore Target",
          keyTarget: logoKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: GestureDetector(
                onTap: () {
                  tutorialCoachMark.next();
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Explore host",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Explore Best Listings on host.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ];
      tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black45,
        paddingFocus: 5,
        onClickOverlay: (targetFocus) => tutorialCoachMark.next(),
        onClickTarget: (targetFocus) => tutorialCoachMark.next(),
        onSkip: () async => await prefs!.setBool(ShouldShowHomeTutorial, false),
        onFinish: () async =>
            await prefs!.setBool(ShouldShowHomeTutorial, false),
      )..show(context: context);
      try {
        await prefs!.setBool(ShouldShowHomeTutorial, false);
      } catch (e) {}
    }
  }
}

Future getProducts(String promotionKey) async {
  var headersList = {'Accept': '*/*'};
  // if (num == 0){
  //   await getDynamicKeys();
  // }
  var url = Uri.parse('${appVar.currentUrl}promotions/$promotionKey');
  var res = await http.get(url, headers: headersList);

  final resBody = await jsonDecode(res.body);
  var promotion = Promotion.fromJson(resBody);
  if (promotionKey ==
      (releaseMode ? 67409233.toString() : 86798078.toString())) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'promoted_product', promotion.products![0].toString());
    hostConst().promotedProduct = promotion.products?[1];
    print("abcdefg ${promotion.products?[1]}");
  }
  if (res.statusCode >= 200 && res.statusCode < 300) {
    print("$resBody");
  } else {
    print("${res.reasonPhrase}");
  }
  return promotion;
}

Future getSeller(String sellerId) async {
  var headersList = {'Accept': '*/*'};
  var url = Uri.parse('${appVar.currentUrl}sellers/$sellerId');
  var res = await http.get(url, headers: headersList);

  final resBody = await jsonDecode(res.body);
  var seller = Seller.fromJson(resBody);

  url = Uri.parse(
      '${appVar.currentUrl}products;startIndex=0;limit=3;accountKey=$sellerId;seller=true;active=true');
  var resProduct = await http.get(url, headers: headersList);
  final resProductBody = await jsonDecode(resProduct.body);
  seller.products = resProductBody["products"] == null
      ? null
      : List<Product>.from(
          resProductBody["products"].map((x) => Product.fromJson(x)));
  if (res.statusCode >= 200 && res.statusCode < 300) {
    print("$resBody");
  } else {
    print("${res.reasonPhrase}");
  }
  return seller;
}

Future<Product> getProductFromKey(String key) async {
  var headersList = {'Accept': '*/*'};
  var url = Uri.parse('${appVar.currentUrl}products/$key');

  var res = await http.get(url, headers: headersList);

  final resBody = await jsonDecode(res.body);
  var product = Product.fromJson(resBody);

  url = Uri.parse('${appVar.currentUrl}sellers/${product.account?.key}');
  res = await http.get(url, headers: headersList);

  final sellerBody = await jsonDecode(res.body);

  var seller = Seller.fromJson(sellerBody);

  product.seller = seller;

  // if (res.statusCode >= 200 && res.statusCode < 300) {
  //   print(resBody);
  // }
  // else {
  //   print(res.reasonPhrase);
  // }
  return product;
}

Future getDynamicKeys() async {
  var headersList = {'Accept': '*/*'};
  // var url = Uri.parse('https://dev.host.in/api/promotions');
  var url = Uri.parse('${appVar.currentUrl}promotions');

  var res = await http.get(url, headers: headersList);
  List<String> mylist = [];
  appVar.dynamicSectionKeys.clear();
  final resBody = await jsonDecode(res.body);
  for (var each in resBody['promotions']) {
    try {
      if (each['products'].length > 0) if (each['position'] == 'Bottom' &&
          each['enabled']) {
        appVar.dynamicSectionKeys.add(each['key']);
        mylist.add(each['key']);
      }
    } catch (e) {
      continue;
    }
  }
  print("hello ${appVar.dynamicSectionKeys}");
}
