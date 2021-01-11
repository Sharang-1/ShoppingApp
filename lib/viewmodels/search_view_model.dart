import 'base_model.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/models/productPageArg.dart';


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
