import 'package:flutter/material.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/productPageArg.dart';
import '../models/products.dart';
import '../models/promotions.dart';
import '../models/sellers.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/navigation_service.dart';
import '../ui/views/promotion_products_view.dart';
import 'base_model.dart';

class DynamicContentViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> init(BuildContext context, {data}) async {
    print("Dynamic Content ViewModel Data : ${data.toString()}");
    print("Dynamic Content ViewModel Data : ${data["contentType"].toString()}");
    print("Dynamic Content ViewModel Data : ${data["id"].toString()}");

    if (!(await _authenticationService.isUserLoggedIn())) {
      await _navigationService.navigateAndRemoveUntil(LoginViewRoute);
      return;
    }

    if ((data == null)) {
      await _navigationService.navigateAndRemoveUntil(HomeViewRoute);
      return;
    }

    switch (data["contentType"]) {
      case "product":
        if (data["id"] == null) break;
        Product product =
            await _apiService.getProductById(productId: data["id"]);
        if (product == null) break;
        await _navigationService.navigateTo(ProductIndividualRoute,
            arguments: product);
        await _navigationService.navigateReplaceTo(HomeViewRoute);
        return;

      case "sellers":
        if (data["id"] == null) break;
        Seller seller = await _apiService.getSellerByID(data["id"]);
        if (seller == null) break;
        if (seller.subscriptionTypeId == 2) {
          await _navigationService.navigateTo(
            ProductsListRoute,
            arguments: ProductPageArg(
              subCategory: seller.name,
              queryString: "accountKey=${seller.key};",
            ),
          );
        } else {
          await _navigationService.navigateTo(SellerIndiViewRoute,
              arguments: seller);
        }
        await _navigationService.navigateReplaceTo(HomeViewRoute);
        return;

      case "orders":
        await _navigationService.navigateTo(MyOrdersRoute);
        await _navigationService.navigateReplaceTo(HomeViewRoute);
        return;

      case "promotion":
        if (data["id"] == null) break;
        Promotions promotions = await _apiService.getPromotions();
        Promotion promotion = promotions.promotions
            .where((element) => element.key == data["id"])
            .toList()[0];
        if (promotion == null) break;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PromotionProduct(
              promotionId: promotion?.key,
              productIds:
                  promotion.products.map((e) => e.toString()).toList() ?? [],
              promotionTitle: promotion.name,
            ),
          ),
        );
        await _navigationService.navigateReplaceTo(HomeViewRoute);
        return;

      default:
        break;
    }
    await _navigationService.navigateAndRemoveUntil(HomeViewRoute);
    return;
  }
}
