import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';

class CartFilter implements BaseFilterModel {
  String _queryString;
  final productId;

  CartFilter({this.productId = ""}) {
    print("Cart Filter for product id " + productId.toString());
    _queryString = "";
    if(productId != null) {
      _queryString += productId.toString();
    }
  }

  @override
  String get queryString => _queryString;
}
