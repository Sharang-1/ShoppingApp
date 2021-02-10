import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/lookups.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
// import 'package:compound/models/user_details.dart';
// import 'package:compound/services/address_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/cart_local_store_service.dart';
import 'package:compound/services/dialog_service.dart';
// import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/whishlist_service.dart';
// import 'package:compound/ui/views/address_input_form_view.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
// import 'package:page_transition/page_transition.dart';
import '../services/api/api_service.dart';
import 'package:compound/services/analytics_service.dart';

import 'base_model.dart';

class ProductIndividualViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final CartLocalStoreService _cartLocalStoreService =
      locator<CartLocalStoreService>();
  final APIService _apiService = locator<APIService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final WhishListService _whishListService = locator<WhishListService>();
  final DialogService _dialogService = locator<DialogService>();
  // final AddressService _addressService = locator<AddressService>();

  Seller selleDetail;
  // UserDetailsContact defaultAddress;
  // bool isProductInWhishlist = false;

  Future<void> init(String sellerId,
      {String productId = "", String productName = ""}) async {
    await _analyticsService.sendAnalyticsEvent(
        eventName: "product_view",
        parameters: <String, dynamic>{
          "product_id": productId,
          "product_name": productName
        });
    selleDetail = await _apiService.getSellerByID(sellerId);
    // var addresses = await _addressService.getAddresses();
    // if (addresses != null && addresses.length != 0) {
    //   defaultAddress = addresses.first;
    // } else {
    //   defaultAddress = null;
    // }
    notifyListeners();
  }

  gotoSellerIndiView() async {
    await goToSellerPage(selleDetail.key);
  }

  // gotoAddView(context) async {
  //   PickResult pickedPlace = await Navigator.push(
  //     context,
  //     PageTransition(
  //       child: AddressInputPage(),
  //       type: PageTransitionType.rightToLeft,
  //     ),
  //   );

  //   if (pickedPlace != null) {
  //     // pickedPlace = (PickResult) pickedPlace;
  //     // print(pickedPlace);
  //     // model.mUserDetails.contact
  //     //     .address = pickedPlace;

  //     UserDetailsContact userAdd = await showModalBottomSheet(
  //         context: context,
  //         builder: (_) => BottomSheetForAddress(
  //               pickedPlace: pickedPlace,
  //             ));
  //     if (userAdd != null) {
  //       if (userAdd.city.toUpperCase() != "AHMEDABAD") {
  //         _dialogService.showNotDeliveringDialog();
  //       } else {
  //         defaultAddress = userAdd;
  //         await _addressService.addAddresses(userAdd);
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }

  Future<List<Lookups>> getLookups() {
    return _apiService.getLookups();
  }

  Future<int> addToCart(Product product, int qty, String size, String color,
      {bool showDialog: true, bool fromBuyNow = false}) async {
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
