import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
// import 'package:compound/services/analytics_service.dart';
import 'package:compound/services/api/api_service.dart';
// import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'base_model.dart';

class SearchViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  // final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final APIService _apiService = locator<APIService>();
  Future<void> init() async {
    // _apiService.getProducts();
    return;
  }

  searchProducts(String searchKey) async {

    return;
  }

  searchSellers(String searchKey) async {

    return;
  }

  goToProductPage(Product data) {
    _navigationService.navigateTo(ProductIndividualRoute, arguments: data);
    return;
  }
  
}
