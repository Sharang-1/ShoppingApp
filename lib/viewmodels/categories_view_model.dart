import '../constants/route_names.dart';
import '../locator.dart';
import '../models/productPageArg.dart';
import '../services/analytics_service.dart';
import '../services/navigation_service.dart';
import 'base_model.dart';

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
