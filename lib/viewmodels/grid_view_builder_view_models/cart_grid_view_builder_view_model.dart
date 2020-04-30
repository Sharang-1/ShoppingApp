import 'package:compound/locator.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/base_grid_view_builder_view_model.dart';
// import 'package:compound/constants/route_names.dart';
// import 'package:compound/constants/shared_pref.dart';
// import 'package:compound/locator.dart';
// import 'package:compound/models/post.dart';
// import 'package:compound/services/dialog_service.dart';
// import 'package:compound/services/navigation_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CartGridViewBuilderViewModel extends BaseGridViewBuilderViewModel<Cart> {
  final APIService _apiService = locator<APIService>();

  @override
  Future init() {
    return null;
  }

  @override
  Future<Cart> getData(
      {BaseFilterModel filterModel, int pageNumber, int pageSize = 10}) async {
    String _queryString =
        "startIndex=${pageSize * (pageNumber - 1)};limit=$pageSize;" +
            filterModel.queryString;
    Cart res = await _apiService.getCart(queryString: _queryString);
    print("FRom lit ------------------------------>>>>>>>>");
    print(res);
    if (res == null) throw "Error occured";
    return res;
  }
}
