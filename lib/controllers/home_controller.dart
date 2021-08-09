import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../constants/route_names.dart';
import '../constants/server_urls.dart';
import '../constants/shared_pref.dart';
import '../controllers/cart_count_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../locator.dart';
import '../models/orders.dart';
import '../models/productPageArg.dart';
import '../models/promotions.dart';
import '../models/user_details.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/cart_local_store_service.dart';
import '../services/dialog_service.dart';
import '../services/location_service.dart';
import '../services/navigation_service.dart';
import '../services/remote_config_service.dart';
import '../services/wishlist_service.dart';
import '../ui/shared/app_colors.dart';
import 'base_controller.dart';

class HomeController extends BaseController {
  final searchController = TextEditingController();
  UniqueKey key = UniqueKey();
  UniqueKey productKey = UniqueKey();
  UniqueKey sellerKey = UniqueKey();
  UniqueKey categoryKey = UniqueKey();
  UniqueKey promotionKey = UniqueKey();
  String cityName = "Add Location";

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final CartLocalStoreService _cartLocalStoreService =
      locator<CartLocalStoreService>();
  final WishListService _wishListService = locator<WishListService>();
  final APIService _apiService = locator<APIService>();
  final AuthenticationService _authService = locator<AuthenticationService>();
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();

  RemoteConfig remoteConfig;
  SharedPreferences prefs;
  UserDetails details;
  bool isProfileComplete = true;
  String name = "";
  List<Promotion> topPromotion;
  List<Promotion> bottomPromotion;
  bool isLoggedIn = false;

  void onRefresh() async {
    try {
      setup();
      await remoteConfig.fetch();
      await remoteConfig.activateFetched();
    } catch (e) {
      print(e.toString());
    }

    await updateIsLoggedIn();

    try {
      UserLocation currentLocation =
          await locator<LocationService>().getLocation();

      if (currentLocation != null) {
        List<Address> addresses =
            await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(
            currentLocation.latitude,
            currentLocation.longitude,
          ),
        );
        cityName = addresses[0].locality;
      }
    } catch (e) {
      print(e.toString());
    }

    key = UniqueKey();
    productKey = UniqueKey();
    sellerKey = UniqueKey();
    categoryKey = UniqueKey();
    promotionKey = UniqueKey();

    List<Promotion> promotions = await getPromotions();
    topPromotion = promotions
        .where((element) => element.position.toLowerCase() == "top")
        .toList();
    bottomPromotion = promotions
        .where((element) => element.position.toLowerCase() == "bottom")
        .toList();

    print("Top Promotions : ${topPromotion.length}");
    print("Bottom Promotions : ${bottomPromotion.length}");

    await Future.delayed(Duration(milliseconds: 100));
    refreshController.refreshCompleted(resetFooterState: true);
    update();

    await updateUserDetails();
  }

  Future<void> updateIsLoggedIn() async {
    isLoggedIn = await _authService.isUserLoggedIn();
  }

  Future<void> updateUserDetails() async {
    if (isLoggedIn) {
      details = await _apiService.getUserData();
      if ((details?.contact?.address?.isEmpty ?? true) ||
          (details?.contact?.googleAddress?.isEmpty ?? true)) {
        isProfileComplete = false;
      }
      update();
    }
  }

  setup() async {
    locator<CartCountController>()
        .setCartCount(await setUpCartListAndGetCount());
    locator<WishListController>()
        .setUpWishList(await _wishListService.getWishList());
    // locator<LookupController>().setUpLookups(await _apiService.getLookups());
  }

  @override
  void onInit() async {
    super.onInit();
    remoteConfig = _remoteConfigService.remoteConfig;
    setup();

    List<Promotion> promotions = await getPromotions();
    topPromotion = promotions
        .where((element) => element.position.toLowerCase() == "top")
        .toList();
    bottomPromotion = promotions
        .where((element) => element.position.toLowerCase() == "bottom")
        .toList();

    isLoggedIn = await _authService.isUserLoggedIn();

    update();

    final lastDeliveredProduct = await getLastDeliveredProduct();
    if (lastDeliveredProduct != null)
      await DialogService.showCustomDialog(
        RatingDialog(
          icon: Image.network(
            lastDeliveredProduct["image"],
            height: 150,
            width: 150,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/product_preloading.png',
              height: 150,
              width: 150,
            ),
          ),
          title: lastDeliveredProduct["name"],
          description: "Tap a star to give your review.",
          submitButton: "Submit",
          positiveComment: "We’re glad you liked it!! 😊",
          negativeComment:
              "Please reach us out and help us understand your concerns!",
          accentColor: logoRed,
          onSubmitPressed: (int rating) async {
            print("onSubmitPressed: rating = $rating");
            await postReview(lastDeliveredProduct['id'], rating.toDouble());
          },
        ),
        barrierDismissible: true,
      );

    final RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 0,
      remindDays: 2,
      remindLaunches: 2,
      googlePlayIdentifier: 'in.dzor.dzor_app',
      appStoreIdentifier: '1562083632',
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await rateMyApp.init();
        if (prefs == null) prefs = await SharedPreferences.getInstance();
        int launches = prefs.getInt('rateMyApp_launches') ?? 0;
        bool doNotOpenAgain =
            prefs.getBool('rateMyApp_doNotOpenAgain') ?? false;

        if (!doNotOpenAgain &&
            (launches > 0) &&
            (launches % 2 == 0) &&
            (launches % 5 == 0)) {
          await rateMyApp.showRateDialog(
            Get.context, title: 'Dzor',
            // message: '',
            onDismissed: () async {
              await prefs.setBool('rateMyApp_doNotOpenAgain', true);
            },
          );
        }
      },
    );
  }

  bool bottomNavigationOnTap(int i) {
    switch (i) {
      case 0:
        NavigationService.to(CategoriesRoute);
        break;
      case 1:
        if (isLoggedIn)
          NavigationService.to(MyAppointmentViewRoute);
        else
          BaseController.showLoginPopup(
            nextView: MyAppointmentViewRoute,
            shouldNavigateToNextScreen: true,
          );
        break;
      case 2:
        NavigationService.to(DzorExploreViewRoute);
        break;
      case 3:
        if (isLoggedIn)
          NavigationService.to(MyOrdersRoute);
        else
          BaseController.showLoginPopup(
            nextView: MyOrdersRoute,
            shouldNavigateToNextScreen: true,
          );
        break;
      case 4:
        if (isLoggedIn)
          NavigationService.to(MapViewRoute);
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
      if (permissionStatus == PermissionStatus.GRANTED) {
        location.onLocationChanged().listen((locationData) {
          if (cityName == "Add Location" && locationData != null) {
            UserLocation currentLocation = UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            );

            if (currentLocation != null) {
              Geocoder.local
                  .findAddressesFromCoordinates(
                Coordinates(
                  currentLocation.latitude,
                  currentLocation.longitude,
                ),
              )
                  .then((addresses) {
                cityName = addresses[0].locality;
                update();
              });
            }
          }
        });
      }
    }
  }

  Future<Map<String, String>> getLastDeliveredProduct() async {
    Order lastDeliveredOrder = (await _apiService.getAllOrders())
        .orders
        .where((e) => e.status.id == 7)
        .first;

    if (lastDeliveredOrder == null) return null;
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    String lastStoredOrderKey = prefs.getString("lastDeliveredOrderKey");
    if (lastDeliveredOrder.key != null &&
        (lastDeliveredOrder.key == lastStoredOrderKey)) return null;
    try {
      if (await _apiService.hasReviewed(lastDeliveredOrder.productId))
        return null;
    } catch (e) {
      print(e.toString());
    }
    await prefs.setString("lastDeliveredOrderKey", lastDeliveredOrder.key);
    return {
      "id": lastDeliveredOrder.productId,
      "name": lastDeliveredOrder.product.name,
      "image":
          '$PRODUCT_PHOTO_BASE_URL/${lastDeliveredOrder.productId}/${lastDeliveredOrder.product.photo.photos.first.name}-small.png',
    };
  }

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
      if (res != null) {
        await _cartLocalStoreService.setCartList(res);
        return res.length;
      }
    } else {
      final count = _cartLocalStoreService.getCartCount();
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
    print("list of promotions");
    print(promotions.promotions.map((e) => e.name).join(";"));
    return promotions.promotions;
  }

  Future setName() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    name = prefs.getString(Name);
    update();
  }

  void showTutorial(BuildContext context,
      {GlobalKey searchKey, GlobalKey logoKey}) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    if (prefs?.getBool(ShouldShowHomeTutorial) ?? true) {
      TutorialCoachMark tutorialCoachMark;
      List<TargetFocus> targets = <TargetFocus>[
        TargetFocus(
          identify: "Search Target",
          keyTarget: searchKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: GestureDetector(
                onTap: () => tutorialCoachMark.next(),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Dzor Search",
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
          identify: "Dzor Explore Target",
          keyTarget: logoKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: GestureDetector(
                onTap: () => tutorialCoachMark.next(),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Explore Dzor",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Explore Best Listings on Dzor.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 300.0),
                      //   child: Center(
                      //     child: Image.asset(
                      //       'assets/images/swipe_up.png',
                      //       height: 250,
                      //       width: 200,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        //Cart Target

        // TargetFocus(
        //   identify: "Cart Target",
        //   keyTarget: cartKey,
        //   contents: [
        //     TargetContent(
        //       align: ContentAlign.bottom,
        //       child: Container(
        //         child: Text(
        //           "Cart",
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               color: Colors.white,
        //               fontSize: 20.0),
        //         ),
        //       ),
        //     ),
        // ],
        // ),
      ];
      tutorialCoachMark = TutorialCoachMark(
        context,
        targets: targets,
        colorShadow: Colors.black45,
        paddingFocus: 5,
        onClickOverlay: (targetFocus) => tutorialCoachMark.next(),
        onClickTarget: (targetFocus) => tutorialCoachMark.next(),
        onSkip: () async => await prefs?.setBool(ShouldShowHomeTutorial, false),
        onFinish: () async =>
            await prefs?.setBool(ShouldShowHomeTutorial, false),
      )..show();
    }
  }
}
