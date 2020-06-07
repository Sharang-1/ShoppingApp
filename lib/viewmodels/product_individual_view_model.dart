import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/dialog_service.dart';

import 'base_model.dart';

class ProductIndividualViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final APIService _apiService = locator<APIService>();

  Future<void> init() async {
    return;
  }

  Future<bool> addToCart(Product product, int qty, String size, String color) async {
    print("Cart added");
    print(product.key);
    final res = await _apiService.addToCart(product.key, qty, size, color);
    if(res != null) {
      _dialogService.showDialog(
        title: "Product added to cart",
        description:  "You can check it in cart"
      );
      return true;
    }
    return false;
  }
}
