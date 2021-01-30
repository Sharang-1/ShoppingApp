import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';

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
      return;
    }

    if (fullText != null) _queryString += "freeText=$fullText;";
    // if (categories != null) _queryString += "categories=$categories;";
    if (accountKey != null) _queryString += "accountKey=$accountKey";
    if (subCategories != null)
      _queryString +=
          subCategories.map((String value) => "category=$value;").join("");
    if (size != null)
      _queryString += size.map((String value) => "size=$size;").join("");
    if (minPrice != null) _queryString += "minPrice=$minPrice;";
    if (maxPrice != null) _queryString += "maxPrice=$maxPrice;";
    if (minDiscount != null) _queryString += "minDiscount=$minDiscount;";
    if (sortField != null) _queryString += "sortField=$sortField;";
    if (isSortOrderDesc != null)
      _queryString += "sortField=price;sortOrder=${isSortOrderDesc ? 'desc' : 'asc'};";

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
