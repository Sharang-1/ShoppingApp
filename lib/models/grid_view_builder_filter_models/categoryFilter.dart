import 'base_filter_model.dart';

class CategoryFilter implements BaseFilterModel {
  late String _queryString;

  CategoryFilter() {
    _queryString = "";
  }

  @override
  String get queryString => _queryString;
}
