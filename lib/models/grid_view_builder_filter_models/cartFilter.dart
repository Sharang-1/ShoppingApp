import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';

class CartFilter implements BaseFilterModel {
  String _queryString;

  CartFilter() {
    _queryString = "";
  }

  @override
  String get queryString => _queryString;
}
