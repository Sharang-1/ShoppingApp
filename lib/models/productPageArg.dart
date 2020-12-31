class ProductPageArg {
  final String queryString;
  final String subCategory;

  ProductPageArg({
    this.queryString,
    this.subCategory,
  });
}

class PromotionProductsPageArg {
  final String promoTitle;
  PromotionProductsPageArg({this.promoTitle});
}
