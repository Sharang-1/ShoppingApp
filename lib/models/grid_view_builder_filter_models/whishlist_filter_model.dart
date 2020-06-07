import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';

class WhishListFilter implements BaseFilterModel {
  String _queryString;

  WhishListFilter() {
    _queryString = "";
  }

  @override
  String get queryString => _queryString;
}