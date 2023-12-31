import '../../locator.dart';
import '../../models/categorys.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../services/api/api_service.dart';
import 'base_grid_view_builder_controller.dart';

class CategoriesGridViewBuilderController
    extends BaseGridViewBuilderController<Categorys, Category> {
  final bool popularCategories;
  final APIService _apiService = locator<APIService>();

  CategoriesGridViewBuilderController({this.popularCategories = false});

  @override
  Future init() async {
    return null;
  }

  @override
  Future<Categorys> getData(
      {required BaseFilterModel filterModel,
      required int pageNumber,
      int pageSize = 10}) async {
    String _queryString =
        "startIndex=${pageSize * (pageNumber - 1)};limit=$pageSize;" +
            filterModel.queryString;
    Categorys res = await _apiService.getCategory(queryString: _queryString);
    if (res.items == null) {
      res = await _apiService.getCategory(queryString: _queryString);
      if (res.items == null) throw "Could not load";
    }

    res.items = res.items!.where((element) => element.forApp!).toList();
    res.items!.shuffle();

    if (this.popularCategories) {
      res.items = res.items!.take(4).toList();
    }

    return res;
  }
}
