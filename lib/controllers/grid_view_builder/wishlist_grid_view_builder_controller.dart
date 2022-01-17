import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../models/products.dart';
import '../../services/api/api_service.dart';
import '../../services/wishlist_service.dart';
import 'base_grid_view_builder_controller.dart';

class WishListGridViewBuilderController
    extends BaseGridViewBuilderController<Products, Product> {
  final List<String>? productIds;
  final APIService _apiService = locator<APIService>();
  final WishListService _wishListService = locator<WishListService>();

  WishListGridViewBuilderController({this.productIds});

  @override
  Future init() async {
    return null;
  }

  @override
  Future<Products> getData(
      {required BaseFilterModel filterModel,
      required int pageNumber,
      int pageSize = 10}) async {
    List<String>? list =
        this.productIds ?? await _wishListService.getWishList();
    Products? res = await _apiService.getWishlistProducts(list: list);
    if (res == null) {
      res = await _apiService.getWishlistProducts(list: list);
      if (res == null) throw "Could not load";
    }
    res.items = res.items!.where((p) => (p.enabled! && p.available!)).toList();
    return res;
  }
}
