// import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/productPageArg.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/cart_local_store_service.dart';
import 'package:compound/services/whishlist_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends BaseModel {
  final CartLocalStoreService _cartLocalStoreService = locator<CartLocalStoreService>();
  final WhishListService _whishListService = locator<WhishListService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();

  String name = "";

  // Returns cart count
  Future<List> init(BuildContext context) async {
    final count = await setUpCartListAndGetCount();
    final whishList = await _whishListService.getWhishList();
    final lookups = await _apiService.getLookups();
    return [count, whishList, lookups];
  }

  Future<int> setUpCartListAndGetCount({ bool withNetworkCall = true }) async {
    if(withNetworkCall) {
      final res = await _apiService.getCartProductItemList();
      if (res != null) {
        await _cartLocalStoreService.setCartList(res);
        return res.length;
      }
    } else {
      final count = _cartLocalStoreService.getCartCount();
      if(count != null) {
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
     SharedPreferences prefs = await SharedPreferences.getInstance();
     name = prefs.getString(Name);
     notifyListeners();
  }
}
