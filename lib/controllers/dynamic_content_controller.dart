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
  Future<void> init(BuildContext context, {data}) async {
    print("Dynamic Content Data : ${data.toString()}");
    print("Dynamic Content Data : ${data["contentType"].toString()}");
    print("Dynamic Content Data : ${data["id"].toString()}");

    await wait(duration: Duration(milliseconds: 500));

    await NavigationService.offAll(HomeViewRoute, arguments: {
      "dynamicContent": data,
    });
  }

  static Future<void> navigate(BuildContext context, data) async {
    if (data == null) return;
    switch (data["contentType"]) {
      case "product":
        if (data["id"] == null) return;
        Product? product =
            await locator<APIService>().getProductById(productId: data["id"]);
        if (product == null) return;
        await wait();
        await NavigationService.to(ProductIndividualRoute, arguments: product);
        return;

      case "sellers":
      case "seller":
        if (data["id"] == null) return;
        Seller seller = await locator<APIService>().getSellerByID(data["id"]);
        // ignore: unnecessary_null_comparison
        if (seller == null) return;
        await wait();
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
        return;

      case "orders":
        if (!(await locator<AuthenticationService>().isUserLoggedIn())) return;
        await wait();
        await NavigationService.to(MyOrdersRoute);
        return;

      case "promotion":
        if (data["id"] == null) return;
        Promotions promotions = await locator<APIService>().getPromotions();
        Promotion promotion = promotions.promotions!
            .where((element) => element.key == data["id"])
            .toList()[0];
        // ignore: unnecessary_null_comparison
        if (promotion == null) return;
        await wait();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PromotionProduct(
              promotionId: promotion.key!,
              demographicIds: [],
              productIds: promotion.products!.map((e) => e.toString()).toList(),
              promotionTitle: promotion.name!,
            ),
          ),
        );
        return;

      default:
        return;
    }
  }

  static Future<void> wait(
      {Duration duration = const Duration(milliseconds: 500)}) async {
    await Future.delayed(duration);
    return;
  }
}
