import '../../locator.dart';
import '../../models/cart.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../services/api/api_service.dart';
import 'base_grid_view_builder_controller.dart';

class CartGridViewBuilderController
    extends BaseGridViewBuilderController<Cart, Item> {
  final APIService _apiService = locator<APIService>();

  @override
  Future<void> init() async {
    return;
  }

  @override
  Future<Cart> getData(
      {required BaseFilterModel filterModel,
      required int pageNumber,
      int pageSize = 10}) async {
    String _queryString =
        "startIndex=${pageSize * (pageNumber - 1)};limit=$pageSize;";
    Cart? res = await _apiService.getCart(queryString: _queryString);
    if (filterModel.queryString != "") {
      print("Cart Query String ======== " + filterModel.queryString);
      var items = res!.items;
      var filteredItems = items!
          .where((element) =>
              element.productId.toString() == filterModel.queryString)
          .toList();
      res.items = filteredItems;
      print(res);
      // ignore: unnecessary_null_comparison
      if (res == null) throw "Could not load";
      return res;
    }
    print("FRom lit ------------------------------>>>>>>>>");
    print(res);
    if (res == null) throw "Could not load";
    return res;
  }

  @override
  Future<bool> deleteData(Item item) async {
    print("Delete ID::::::::::::: " + item.productId.toString());
    final res = await _apiService.removeFromCart(item.productId as int? ?? 0);
    if (res != null) {
      return true;
    }
    return false;
  }
}
