import 'package:compound/constants/route_names.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'base_model.dart';

class DynamicContentViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> init({data}) async {

      if (data == null) _navigationService.navigateReplaceTo(HomeViewRoute);
      
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

        default:break;
      }
      _navigationService.navigateReplaceTo(HomeViewRoute);
      return;
  }
}
