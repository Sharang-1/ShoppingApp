import 'base_filter_model.dart';

class ProductFilter implements BaseFilterModel {
  final String fullText;
  final String accountKey;
  final String categories;
  final List<int> demographicIds;
  final List<String> subCategories;
  final List<String> size;
  final int minPrice;
  final int maxPrice;
  final int minDiscount;
  final String sortField;
  final bool isSortOrderDesc;
  final bool explore;
  final String existingQueryString;

  String _queryString = "";

  ProductFilter({
    this.fullText,
    this.accountKey,
    this.categories,
    this.subCategories,
    this.demographicIds,
    this.size,
    this.minPrice,
    this.maxPrice,
    this.minDiscount,
    this.sortField,
    this.explore,
    this.isSortOrderDesc,
    this.existingQueryString = "",
  }) {
    if (existingQueryString != "") {
      _queryString = existingQueryString;
    }

    if (fullText != null) {
      if (!_queryString.contains("freeText"))
        _queryString += "freeText=$fullText;";
      else
        _queryString = _queryString.replaceFirst(
            RegExp("freeText(.*?);"), "freeText=$fullText;");
    }

    if (accountKey != null) {
      if (!_queryString.contains("accountKey"))
        _queryString += "accountKey=$accountKey;";
      else
        _queryString = _queryString.replaceFirst(
            RegExp("accountKey(.*?);"), "accountKey=$accountKey;");
    }
    if (subCategories != null) {
      if (!_queryString.contains("category"))
        _queryString +=
            subCategories.map((String value) => "category=$value;").join("");
      else {
        _queryString = _queryString.replaceAll(RegExp("category(.*?);"), "");
        _queryString +=
            subCategories.map((String value) => "category=$value;").join("");
      }
    }

    if ((demographicIds?.length ?? 0) > 0) {
      if (!_queryString.contains("demographic"))
        _queryString +=
            demographicIds.map((int value) => "demographic=$value;").join("");
      else {
        _queryString = _queryString.replaceAll(RegExp("demographic(.*?);"), "");
        _queryString +=
            demographicIds.map((int value) => "demographic=$value;").join("");
      }
    }

    if (size != null) {
      if (!_queryString.contains("size"))
        _queryString += size.map((String value) => "size=$size;").join("");
      else {
        _queryString = _queryString.replaceAll(RegExp("size(.*?);"), "");
        _queryString += size.map((String value) => "size=$size;").join("");
      }
    }
    if (minPrice != null) {
      if (!_queryString.contains("minPrice"))
        _queryString += "minPrice=$minPrice;";
      else
        _queryString = _queryString.replaceFirst(
            RegExp("minPrice(.*?);"), "minPrice=$minPrice;");
    }
    if (maxPrice != null) {
      if (!_queryString.contains("maxPrice"))
        _queryString += "maxPrice=$maxPrice;";
      else
        _queryString = _queryString.replaceFirst(
            RegExp("maxPrice(.*?);"), "maxPrice=$maxPrice;");
    }
    if (minDiscount != null) {
      if (!_queryString.contains("minDiscount"))
        _queryString += "minDiscount=$minDiscount;";
      else
        _queryString = _queryString.replaceFirst(
            RegExp("minDiscount(.*?);"), "minDiscount=$minDiscount;");
    }

    if (explore != null) {
      if (!_queryString.contains("explore"))
        _queryString += "explore=true;";
      else
        _queryString =
            _queryString.replaceFirst(RegExp("explore(.*?);"), "explore=true;");
    }

    if (sortField != null) {
      if (!_queryString.contains("sortField"))
        _queryString += "sortField=$sortField;";
      else
        _queryString = _queryString.replaceFirst(
            RegExp("sortField(.*?);"), "sortField=$sortField;");
    }
    if (isSortOrderDesc != null) {
      if (!_queryString.contains("sortOrder"))
        _queryString +=
            "sortField=price;sortOrder=${isSortOrderDesc ? 'desc' : 'asc'};";
      else
        _queryString = _queryString.replaceFirst(RegExp("sortOrder(.*?);"),
            "sortOrder=${isSortOrderDesc ? 'desc' : 'asc'};");
    }

    print("query string for product filter");
    print(_queryString);
  }

  @override
  String get queryString => _queryString;
}
