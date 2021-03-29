import '../constants/route_names.dart';
import '../locator.dart';
import '../models/productPageArg.dart';
import '../services/navigation_service.dart';
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

  Future showCategory(String filter, String name) async {
    await _navigationService.navigateTo(
      CategoryIndiViewRoute,
      arguments: ProductPageArg(
        queryString: filter,
        subCategory: name,
      ),
    );
  }
}
