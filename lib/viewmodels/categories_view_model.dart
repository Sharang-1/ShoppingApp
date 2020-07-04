import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/productPageArg.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class CategoriesViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future init() {
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
