import 'base_filter_model.dart';

class ProductFilter implements BaseFilterModel {
  final String fullText;
  final String accountKey;
  final String categories;
  final List<String> subCategories;
  final List<String> size;
  final int minPrice;
  final int maxPrice;
  final int minDiscount;
  final String sortField;
  final bool isSortOrderDesc;
  final String existingQueryString;

  String _queryString = "";

  ProductFilter({
    this.fullText,
    this.accountKey,
    this.categories,
    this.subCategories,
    this.size,
    this.minPrice,
    this.maxPrice,
    this.minDiscount,
    this.sortField,
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
    // if (categories != null) _queryString += "categories=$categories;";
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

/// Library Name: Filter based GridView Builder
///
/// - GridViewBuilder (UI)
/// - GridViewBuilder_View_Model
///   - For network request
///   - For parsing response and converting in ResponseModel
/// - FilterModel   - getQueryString
/// - ResponseModel - fromJSON, toJSON
/// - TileDataModel - fromJSON, toJSON
/// -
