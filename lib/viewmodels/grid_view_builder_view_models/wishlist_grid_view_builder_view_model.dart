import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../models/products.dart';
import '../../services/api/api_service.dart';
import '../../services/whishlist_service.dart';
import 'base_grid_view_builder_view_model.dart';

class WhishListGridViewBuilderViewModel
    extends BaseGridViewBuilderViewModel<Products, Product> {
  final List<String> productIds;
  final APIService _apiService = locator<APIService>();
  final WhishListService _whishListService = locator<WhishListService>();

  WhishListGridViewBuilderViewModel({this.productIds});

  @override
  Future init() {
    return null;
  }

  @override
  Future<Products> getData(
      {BaseFilterModel filterModel, int pageNumber, int pageSize = 10}) async {
    List<String> list = this.productIds ?? await _whishListService.getWhishList();
    Products res = await _apiService.getWhishlistProducts(list: list);
    if(res == null) throw "Could not load";
    return res;
  }
}
