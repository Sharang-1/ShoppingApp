class ProductPageArg {
  final String queryString;
  final String subCategory;
  final String sellerPhoto;

  ProductPageArg({
    this.queryString,
    this.subCategory,
    this.sellerPhoto
  });
}

class PromotionProductsPageArg {
  final String promoTitle;
  PromotionProductsPageArg({this.promoTitle});
}
