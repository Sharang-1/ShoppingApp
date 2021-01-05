import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/lookups.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/services/address_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/cart_local_store_service.dart';
import 'package:compound/services/dialog_service.dart';
// import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/whishlist_service.dart';
import 'package:compound/ui/views/address_input_form_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../services/api/api_service.dart';

import 'base_model.dart';

class ProductIndividualViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final CartLocalStoreService _cartLocalStoreService =
      locator<CartLocalStoreService>();
  final APIService _apiService = locator<APIService>();
  final WhishListService _whishListService = locator<WhishListService>();
  final DialogService _dialogService = locator<DialogService>();
  final AddressService _addressService = locator<AddressService>();

  Seller selleDetail;
  String defaultAddress;
  // bool isProductInWhishlist = false;

  Future<void> init(String sellerId) async {
    selleDetail = await _apiService.getSellerByID(sellerId);
    var addresses = await _addressService.getAddresses();
    print("address");
    print(addresses);
    if(addresses != null && addresses.length != 0) {
      defaultAddress = addresses.first;
    } else {
      defaultAddress = "";
    }
    notifyListeners();
  }

  gotoSellerIndiView() {
    _navigationService.navigateTo(SellerIndiViewRoute, arguments: selleDetail);
  }

  gotoAddView(context) async {
    var pickedPlace = await Navigator.push(
        context,
        PageTransition(
          child: AddressInputPage(),
          type: PageTransitionType.rightToLeft,
        ));
    defaultAddress = pickedPlace;
    notifyListeners();
  }

  Future<List<Lookups>> getLookups() {
    return _apiService.getLookups();
  }

  Future<int> addToCart(Product product, int qty, String size, String color,
      {bool showDialog: true}) async {
    print("Cart added");
    print(product.key);
    final res = await _apiService.addToCart(product.key, qty, size, color);
    if (res != null) {
      final localStoreResult =
          await _cartLocalStoreService.addToCartLocalStore(product.key);
      if (localStoreResult == -1) {
        if (showDialog) {
          await _dialogService.showDialog(
            title: "Success",
            description: "Product in Cart Updated Successfully",
          );
        }
        return -1;
      } else {
        if (showDialog) {
          await _dialogService.showDialog(
            title: "Success",
            description: "Product Added Successfully",
          );
        }
      }
      return 1;
    }
    return 0;
  }

  Future<bool> buyNow(
      Product product, int qty, String size, String color) async {
    var res = await addToCart(product, qty, size, color, showDialog: false);
    if (res != null) {
      return true;
    }
    return false;
  }

  Future<dynamic> buyNowView(String productId) async {
    return await _navigationService.navigateTo(CartViewRoute,
        arguments: productId);
  }

  Future<bool> addToWhishList(String id) async {
    return await _whishListService.addWhishList(id);
  }

  Future<bool> removeFromWhishList(String id) async {
    return await _whishListService.removeWhishList(id);
  }
}
