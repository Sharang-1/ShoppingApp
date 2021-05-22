import 'package:fimber/fimber.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/lookups.dart';
import '../models/products.dart';
import '../models/reviews.dart';
import '../models/sellers.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/cart_local_store_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../services/wishlist_service.dart';
import 'base_controller.dart';

class ProductController extends BaseController {
  final CartLocalStoreService _cartLocalStoreService = locator<CartLocalStoreService>();
  final APIService _apiService = locator<APIService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final WishListService _wishListService = locator<WishListService>();

  Seller sellerDetail;
  Reviews reviews;

  String sellerId;
  String productId = "";
  String productName = "";

  ProductController(this.sellerId,
      {this.productId = "", this.productName = ""});

  void init() async {
    await _analyticsService.sendAnalyticsEvent(
        eventName: "product_view",
        parameters: <String, dynamic>{
          "product_id": productId,
          "product_name": productName
        });
    sellerDetail = await _apiService.getSellerByID(sellerId);
    reviews = await _apiService.getReviews(productId, isSellerReview: false);
    update();
  }

  gotoSellerIndiView() async {
    await BaseController.goToSellerPage(sellerDetail.key);
  }

  Future<List<Lookups>> getLookups() {
    return _apiService.getLookups();
  }

  Future<int> addToCart(Product product, int qty, String size, String color,
      {bool showDialog: true,
      bool fromBuyNow = false,
      bool fromCart = false,
      Function onProductAdded}) async {
    print("Cart added");
    print(product.key);

    if (!fromBuyNow)
      await _analyticsService.sendAnalyticsEvent(
          eventName: "add_to_cart",
          parameters: <String, dynamic>{
            "product_id": product.key,
            "product_name": product.name
          });

    final res = await _apiService.addToCart(product.key, qty, size, color);
    if (res != null) {
      final localStoreResult =
          await _cartLocalStoreService.addToCartLocalStore(product.key);
      if (localStoreResult == -1) {
        if (fromCart) {
          if (onProductAdded != null) onProductAdded();
          return -1;
        }
        if (showDialog) {
          await BaseController.vibrate(duration: 100);
          await DialogService.showDialog(
            title: "Added to Bag",
            description: "The item has been added to your Bag.",
          );
        }
        return -1;
      } else {
        if (fromCart) {
          if (onProductAdded != null) onProductAdded();
          return 1;
        }
        if (showDialog) {
          await BaseController.vibrate(duration: 100);
          await DialogService.showDialog(
            title: "Added to Bag",
            description: "The item has been added to your Bag.",
          );
        }
      }
      return 1;
    }
    return 0;
  }

  Future<Product> refreshProduct(String productId) async {
    return await _apiService.getProductById(productId: productId);
  }

  Future<bool> buyNow(
      Product product, int qty, String size, String color) async {
    await _analyticsService
        .sendAnalyticsEvent(eventName: "buy_now", parameters: <String, dynamic>{
      "product_id": product.key,
      "product_name": product.name,
      "quantity": qty,
    });

    var res = await addToCart(product, qty, size, color,
        showDialog: false, fromBuyNow: true);
    if (res != null) {
      return true;
    }
    return false;
  }

  Future<dynamic> buyNowView(String productId) async {
    return await NavigationService.to(CartViewRoute,
        arguments: productId);
  }

  Future<bool> addToWishList(String id) async {
    return await _wishListService.addWishList(id);
  }

  Future<bool> removeFromWishList(String id) async {
    return await _wishListService.removeWishList(id);
  }

  Future<void> shareProductEvent(
      {String productId = '', String productName = ''}) async {
    try {
      await _analyticsService.sendAnalyticsEvent(
          eventName: "product_shared",
          parameters: <String, dynamic>{
            "product_id": productId,
            "product_name": productName,
          });
    } catch (e) {}
  }

  Future getProducts() async {
    setBusy(true);
    Products result = await _apiService.getProducts();
    setBusy(false);
    if (result != null) {
      Fimber.d(result.items.toString());
    }
  }
}