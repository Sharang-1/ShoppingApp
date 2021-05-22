import '../constants/route_names.dart';
import '../locator.dart';
import '../models/productPageArg.dart';
import '../services/analytics_service.dart';
import '../services/navigation_service.dart';
import 'base_controller.dart';

class CategoriesController extends BaseController {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future init({String subCategory = ''}) async {
    try {
      await _analyticsService.sendAnalyticsEvent(
          eventName: "category_view",
          parameters: <String, dynamic>{
            "category_name": subCategory,
          });
    } catch (e) {}
    return null;
  }

  static Future showProducts(String filter, String name) async {
    await NavigationService.to(
      CategoryIndiViewRoute,
      arguments: ProductPageArg(
        queryString: filter,
        subCategory: name,
      ),
    );
  }
}
