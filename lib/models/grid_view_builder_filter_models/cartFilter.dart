import 'base_filter_model.dart';

class CartFilter implements BaseFilterModel {
  late String _queryString;
  final String? productId;

  CartFilter({this.productId = ""}) {
    print("Cart Filter for product id " + productId.toString());
    _queryString = "";
    if (productId != null) {
      _queryString += productId.toString();
    }
  }

  @override
  String get queryString => _queryString;
}
