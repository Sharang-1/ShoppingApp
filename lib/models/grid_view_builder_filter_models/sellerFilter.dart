import 'base_filter_model.dart';

class SellerFilter implements BaseFilterModel {
  late final String name;

  late String _queryString;

  SellerFilter({
    required this.name,
  }) {
    _queryString = "";
    if (name != null) _queryString += "name=$name;";
  }

  @override
  String get queryString => _queryString;
}
