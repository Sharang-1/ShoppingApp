import 'package:compound/locator.dart';
import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/whishlist_service.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/base_grid_view_builder_view_model.dart';

class WhishListGridViewBuilderViewModel
    extends BaseGridViewBuilderViewModel<Products, Product> {
  final APIService _apiService = locator<APIService>();
  final WhishListService _whishListService = locator<WhishListService>();

  @override
  Future init() {
    return null;
  }

  @override
  Future<Products> getData(
      {BaseFilterModel filterModel, int pageNumber, int pageSize = 10}) async {
    List<String> list = await _whishListService.getWhishList();
    Products res = await _apiService.getWhishlistProducts(list: list);
    if(res == null) throw "Error occured";
    return res;
  }
}
