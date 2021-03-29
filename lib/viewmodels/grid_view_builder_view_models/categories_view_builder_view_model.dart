import '../../locator.dart';
import '../../models/categorys.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../services/api/api_service.dart';
import 'base_grid_view_builder_view_model.dart';
// import 'package:compound/constants/route_names.dart';
// import 'package:compound/constants/shared_pref.dart';
// import 'package:compound/locator.dart';
// import 'package:compound/models/post.dart';
// import 'package:compound/services/dialog_service.dart';
// import 'package:compound/services/navigation_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CategoriesGridViewBuilderViewModel
    extends BaseGridViewBuilderViewModel<Categorys, Category> {
  final bool popularCategories;
  final APIService _apiService = locator<APIService>();

  CategoriesGridViewBuilderViewModel({this.popularCategories = false});

  @override
  Future init() {
    return null;
  }

  @override
  Future<Categorys> getData(
      {BaseFilterModel filterModel, int pageNumber, int pageSize = 10}) async {
    String _queryString =
        "startIndex=${pageSize * (pageNumber - 1)};limit=$pageSize;" +
            filterModel.queryString;
    Categorys res =
        await _apiService.getCategory(queryString: _queryString);
    if (res == null) throw "Error occured";

    res.items = res.items.where((element) => element.name.trim().toLowerCase() != "n/a").toList();
    res.items.shuffle();

    if(this.popularCategories) {
      res.items = res.items.take(4).toList();
    }
    return res;
  }
}
