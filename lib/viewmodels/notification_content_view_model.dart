import 'package:compound/constants/route_names.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/utils/notification_type.dart';
import 'base_model.dart';

class NotificationContentViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> init({data}) async {
    Future.delayed(Duration(seconds: 1), () async {
      if (data == null) _navigationService.navigateReplaceTo(HomeViewRoute);
      NotificationType nType = data?.nType;
      
      switch (nType) {

        case NotificationType.product:
        if(data.productId == null) break;
          Product product =
              await _apiService.getProductById(productId: data?.productId);
          if(product == null) break;
          _navigationService.navigateReplaceTo(ProductIndividualRoute,
              arguments: product);
          return;

        case NotificationType.seller:
          if(data.sellerId == null) break;
            Seller seller =
                await _apiService.getSellerByID(data?.sellerId);
            if(seller == null) break;
            _navigationService.navigateReplaceTo(SellerIndiViewRoute,
                arguments: seller);
            return;

        default:break;
      }
      _navigationService.navigateReplaceTo(HomeViewRoute);
      return;
    });
  }
}
