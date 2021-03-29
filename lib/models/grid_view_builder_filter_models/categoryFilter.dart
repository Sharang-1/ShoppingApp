import 'base_filter_model.dart';

class CategoryFilter implements BaseFilterModel {
  String _queryString;

  CategoryFilter() {
    _queryString = "";
  }

  @override
  String get queryString => _queryString;
}

/// Library Name: Filter based GridView Builder
///
/// - GridViewBuilder (UI)
/// - GridViewBuilder_View_Model
///   - For network request
///   - For parsing response and converting in ResponseModel
/// - FilterModel   - getQueryString
/// - ResponseModel - fromJSON, toJSON
/// - TileDataModel - fromJSON, toJSON
/// -
