import 'base_filter_model.dart';

class WishListFilter implements BaseFilterModel {
  late String _queryString;

  WishListFilter() {
    _queryString = "";
  }

  @override
  String get queryString => _queryString;
}
