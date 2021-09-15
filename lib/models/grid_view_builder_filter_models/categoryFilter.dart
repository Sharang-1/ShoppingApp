import 'base_filter_model.dart';

class CategoryFilter implements BaseFilterModel {
  String _queryString;

  CategoryFilter() {
    _queryString = "";
  }

  @override
  String get queryString => _queryString;
}
