import 'package:compound/constants/route_names.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/authentication_service.dart';
import 'base_model.dart';
import 'package:flutter/material.dart';
import 'package:compound/ui/views/promotion_products_view.dart';

class DynamicContentViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> init(BuildContext context, {data}) async {

      if(!(await _authenticationService.isUserLoggedIn())){
        _navigationService.navigateReplaceTo(LoginViewRoute);
        return;
      }
      
      if ((data == null)) {
        _navigationService.navigateReplaceTo(HomeViewRoute);
        return;
      }

      switch (data["contentType"]) {

        case "product":
        if(data["id"] == null) break;
          Product product =
              await _apiService.getProductById(productId: data["id"]);
          if(product == null) break;
          _navigationService.navigateReplaceTo(ProductIndividualRoute,
              arguments: product);
          return;

        case "seller":
          if(data["id"] == null) break;
            Seller seller =
                await _apiService.getSellerByID(data["id"]);
            if(seller == null) break;
            _navigationService.navigateReplaceTo(SellerIndiViewRoute,
                arguments: seller);
            return;
        
        case "orders":
          _navigationService.navigateReplaceTo(MyOrdersRoute);
          return;
        
        case "promotion":
          if(data["id"] == null) break;
            Promotions promotions = await _apiService.getPromotions();
            Promotion promotion = promotions.promotions.where((element) => element.key == data["id"]).toList()[0];
            if(promotion == null) break;
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                builder: (context) => PromotionProduct(
                  promotionId: promotion?.key,
                  productIds: promotion.products.map((e) => e.toString()).toList() ?? [],
                  promotionTitle: promotion.name,
                ),
              ),
            );
            return;

        default:break;
      }
      _navigationService.navigateReplaceTo(HomeViewRoute);
      return;
  }
}
