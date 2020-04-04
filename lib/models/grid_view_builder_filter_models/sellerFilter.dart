import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';

class SellerFilter implements BaseFilterModel {
  final String name;

  String _queryString;

  SellerFilter({
    this.name,
  }) {
    _queryString = "";
    if (name != null) _queryString += "name=$name;";
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
