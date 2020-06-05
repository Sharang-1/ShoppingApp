import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/navigation_service.dart';

import 'base_model.dart';

class SearchViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> init() async {
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

  Future<void> cart() async {
    await _navigationService.navigateTo(CartViewRoute);
  }
  
}
