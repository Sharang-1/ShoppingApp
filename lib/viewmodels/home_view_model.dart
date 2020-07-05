// import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/cart_count_service.dart';
import 'package:compound/services/whishlist_service.dart';
// import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends BaseModel {
  final CartCountService _cartCountService = locator<CartCountService>();
  final WhishListService _whishListService = locator<WhishListService>();
  final APIService _apiService = locator<APIService>();

  // Returns cart count
  Future<List> init(BuildContext context) async {
    final whishList = await _whishListService.getWhishList();
    final count = await setUpCartCount();
    return [count, whishList];
  }

  Future<int> setUpCartCount({ bool withNetworkCall = true }) async {
    if(withNetworkCall) {
      final res = await _apiService.getCartCount();
      if (res != null) {
        await _cartCountService.setCartCount(res);
        return res;
      }
    } else {
      final count = _cartCountService.getCartCount();
      if(count != null) {
        return count;
      }
    }
    await _cartCountService.setCartCount(0);
    return 0;
  }
}
