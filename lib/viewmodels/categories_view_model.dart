import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/productPageArg.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/analytics_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class CategoriesViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future init({String subCategory = ''}) async {
    try{
       await _analyticsService.sendAnalyticsEvent(eventName: "category_view", parameters: <String, dynamic>{
      "subCategory": subCategory,
    });
    }catch(e){}
    return null;
  }

  Future showProducts(String filter, String name) async {
    await _navigationService.navigateTo(
      CategoryIndiViewRoute,
      arguments: ProductPageArg(
        queryString: filter,
        subCategory: name,
      ),
    );
  }
}
