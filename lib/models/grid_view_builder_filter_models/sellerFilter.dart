import 'base_filter_model.dart';

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
