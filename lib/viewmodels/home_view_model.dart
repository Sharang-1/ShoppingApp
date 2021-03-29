// import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/orders.dart';
import 'package:compound/models/productPageArg.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/models/user_details.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/cart_local_store_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/whishlist_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends BaseModel {
  final CartLocalStoreService _cartLocalStoreService =
      locator<CartLocalStoreService>();
  final WhishListService _whishListService = locator<WhishListService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();
  SharedPreferences prefs;
  UserDetails details;
  String name = "";

  // Returns cart count
  Future<List> init(BuildContext context) async {
    final count = await setUpCartListAndGetCount();
    final whishList = await _whishListService.getWhishList();
    final lookups = await _apiService.getLookups();
    return [count, whishList, lookups];
  }

  Future<Map<String, String>> getLastDeliveredProduct() async {
    Order lastDeliveredOrder = (await _apiService.getAllOrders())
        .orders
        .where((e) => e.status.id == 7)
        .first;

    if (lastDeliveredOrder == null) return null;
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    String lastStoredOrderKey = prefs.getString("lastDeliveredOrderKey");
    if (lastDeliveredOrder.key != null && (lastDeliveredOrder.key == lastStoredOrderKey)) return null;
    try {
      details = await _apiService.getUserData();
      if (await _apiService.hasReviewed(
          lastDeliveredOrder.productId, details.key)) return null;
    } catch (e) {
      print(e.toString());
    }
    await prefs.setString("lastDeliveredOrderKey", lastDeliveredOrder.key);
    return {
      "id": lastDeliveredOrder.productId,
      "name": lastDeliveredOrder.product.name,
      "image":
          '$PRODUCT_PHOTO_BASE_URL/${lastDeliveredOrder.productId}/${lastDeliveredOrder.product.photo.photos.first.name}',
    };
  }

  Future postReview(String key, double ratings) async {
    try{
      _apiService.postReview(key, ratings, "");
      return; 
    }catch(e){
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
    await _navigationService.navigateTo(
      CategoryIndiViewRoute,
      arguments: ProductPageArg(
        queryString: filter,
        subCategory: name,
      ),
    );
  }

  Future showSellers() async {
    await _navigationService.navigateTo(
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
    notifyListeners();
  }
}
