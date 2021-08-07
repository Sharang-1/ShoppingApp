import 'package:flutter/material.dart';

import '../constants/route_names.dart';
import '../constants/server_urls.dart';
import '../locator.dart';
import '../models/productPageArg.dart';
import '../models/products.dart';
import '../models/promotions.dart';
import '../models/sellers.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/navigation_service.dart';
import '../ui/views/promotion_products_view.dart';
import 'base_controller.dart';

class DynamicContentController extends BaseController {
  final APIService _apiService = locator<APIService>();

  Future<void> init(BuildContext context, {data}) async {
    print("Dynamic Content ViewModel Data : ${data.toString()}");
    print("Dynamic Content ViewModel Data : ${data["contentType"].toString()}");
    print("Dynamic Content ViewModel Data : ${data["id"].toString()}");

    // if (!(await locator<AuthenticationService>().isUserLoggedIn())) {
    //   await NavigationService.offAll(LoginViewRoute);
    //   return;
    // }

    if ((data == null)) {
      await NavigationService.offAll(HomeViewRoute);
      return;
    }

    switch (data["contentType"]) {
      case "product":
        if (data["id"] == null) break;
        Product product =
            await _apiService.getProductById(productId: data["id"]);
        if (product == null) break;
        await NavigationService.to(ProductIndividualRoute, arguments: product);
        await Future.delayed(Duration(milliseconds: 500));
        await NavigationService.offAll(HomeViewRoute);
        return;

      case "sellers":
      case "seller":
        if (data["id"] == null) break;
        Seller seller = await _apiService.getSellerByID(data["id"]);
        if (seller == null) break;
        if (seller.subscriptionTypeId == 2) {
          await NavigationService.to(
            ProductsListRoute,
            arguments: ProductPageArg(
              subCategory: seller.name,
              queryString: "accountKey=${seller.key};",
              sellerPhoto: "$SELLER_PHOTO_BASE_URL/${seller.key}",
            ),
          );
        } else {
          await NavigationService.to(SellerIndiViewRoute, arguments: seller);
        }
        await Future.delayed(Duration(milliseconds: 500));
        await NavigationService.offAll(HomeViewRoute);
        return;

      case "orders":
        if (!(await locator<AuthenticationService>().isUserLoggedIn())) {
          await NavigationService.offAll(LoginViewRoute);
          return;
        }
        await NavigationService.to(MyOrdersRoute);
        await Future.delayed(Duration(milliseconds: 500));
        await NavigationService.offAll(HomeViewRoute);
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
        await Future.delayed(Duration(milliseconds: 500));
        await NavigationService.offAll(HomeViewRoute);
        return;

      default:
        break;
    }
    await NavigationService.offAll(HomeViewRoute);
    return;
  }
}
