import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/coupon.dart';
import '../models/lookups.dart';
import '../models/products.dart';
import '../models/reviews.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/cart_local_store_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../services/wishlist_service.dart';
import '../utils/lang/translation_keys.dart';
import 'base_controller.dart';
import 'home_controller.dart';
import 'wishlist_controller.dart';

class ProductController extends BaseController {
  final CartLocalStoreService _cartLocalStoreService =
      locator<CartLocalStoreService>();
  final APIService _apiService = locator<APIService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final WishListService _wishListService = locator<WishListService>();

  Product? productData;
  Reviews? reviews;

  String? sellerId;
  String productId = "";
  String productName = "";

  List<Coupon> coupons = [];
  bool isWishlistIconFilled = false;

  ProductController(this.sellerId,
      {this.productId = "", this.productName = ""});

  void init() async {
    isWishlistIconFilled =
        locator<WishListController>().list.indexOf(productId) != -1;
    productData = await refreshProduct(productId);
    reviews = await _apiService.getReviews(productId, isSellerReview: false);
    update();

    await _analyticsService.sendAnalyticsEvent(
        eventName: "product_view",
        parameters: <String, dynamic>{
          "product_id": productData?.key,
          "product_name": productData?.name,
          "category_id": productData?.category?.id?.toString(),
          "category_name": productData?.category?.name,
          "user_id": locator<HomeController>().details!.key,
          "user_name": locator<HomeController>().details!.name,
        });
  }

  Future<List<Lookups>> getLookups() {
    return _apiService.getLookups();
  }

  Future<int> addToCart(Product product, int qty,BuildContext context, String size, String color,
      {bool showDialog: true,
      bool fromBuyNow = false,
      bool fromCart = false,

      Function? onProductAdded}) async {
    print("Cart added");
    print(product.key);

    if (!fromBuyNow)
      await _analyticsService.sendAnalyticsEvent(
          eventName: "add_to_cart",
          parameters: <String, dynamic>{
            "product_id": product.key,
            "product_name": product.name,
            "category_id": product.category?.id?.toString(),
            "category_name": product.category?.name,
            "user_id": locator<HomeController>().details!.key,
            "user_name": locator<HomeController>().details!.name,
          });

    final res =
        await _apiService.addToCart(product.key ?? "", qty, size, color);
    if (res != null) {
      await BaseController.vibrate(duration: 10);

      final localStoreResult =
          await _cartLocalStoreService.addToCartLocalStore(product.key!);
      if (localStoreResult == -1) {
        if (fromCart) {
          if (onProductAdded != null) onProductAdded();
          return -1;
        }
        if (showDialog) {
          SnackBarService.showTopSnackBar(context, PRODUCTSCREEN_ADDED_TO_BAG_DESCRIPTION.tr);
        }
        return -1;
      } else {
        if (fromCart) {
          if (onProductAdded != null) onProductAdded();
          return 1;
        }
        if (showDialog) {
          SnackBarService.showTopSnackBar(context, PRODUCTSCREEN_ADDED_TO_BAG_DESCRIPTION.tr);
          // await DialogService.showDialog(
          //   title: PRODUCTSCREEN_ADDED_TO_BAG_TITLE.tr,
          //   description: PRODUCTSCREEN_ADDED_TO_BAG_DESCRIPTION.tr,
          // );
          // await BaseController.showSizePopup();
        }
      }
      return 1;
    }
    return 0;
  }

  Future<Product?> refreshProduct(String productId) async {
    productData = await _apiService.getProductById(
      productId: productId,
      withCoupons: true,
    );
    if (productData != null) return productData!;
    return null;
  }

  Future<bool> buyNow(
      Product product, int qty, context,  String size, String color) async {
    await _analyticsService
        .sendAnalyticsEvent(eventName: "buy_now", parameters: <String, dynamic>{
      "product_id": product.key,
      "product_name": product.name,
      "category_id": product.category?.id?.toString(),
      "category_name": product.category?.name,
      "quantity": qty.toString(),
      "user_id": locator<HomeController>().details!.key,
      "user_name": locator<HomeController>().details!.name,
    });

    var res = await addToCart(product, qty,context, size, color,
        showDialog: false, fromBuyNow: true, onProductAdded: () {});
    if (res != null) {
      return true;
    }
    return false;
  }

  Future<dynamic> buyNowView(String productId) async {
    return await NavigationService.to(CartViewRoute, arguments: productId);
  }

  Future onWishlistBtnClicked(String id) async {
    if (locator<WishListController>().list.indexOf(id) != -1) {
      await _wishListService.removeWishList(id);
      locator<WishListController>().removeFromWishList(id);
      isWishlistIconFilled = false;
      update();
    } else {
      await _wishListService.addWishList(id);
      locator<WishListController>().addToWishList(id);
      isWishlistIconFilled = true;
      update();
      Get.snackbar(
        PRODUCTSCREEN_ADDED_TO_WISHLIST.tr,
        '',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> shareProductEvent(
      {String productId = '', String productName = ''}) async {
    try {
      await _analyticsService.sendAnalyticsEvent(
          eventName: "product_shared",
          parameters: <String, dynamic>{
            "product_id": productId,
            "product_name": productName,
            "category_id": productData?.category?.id?.toString(),
            "category_name": productData?.category?.name,
            "user_id": locator<HomeController>().details!.key,
            "user_name": locator<HomeController>().details!.name,
          });
    } catch (e) {}
  }

  Future getProducts() async {
    setBusy(true);
    Products? result = await _apiService.getProducts();
    setBusy(false);
    if (result != null) {
      Fimber.d(result.items.toString());
    }
  }
}
