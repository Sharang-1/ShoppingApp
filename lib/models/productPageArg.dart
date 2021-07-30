class ProductPageArg {
  final String queryString;
  final String subCategory;
  final String sellerPhoto;
  final List<String> productList;

  ProductPageArg({
    this.queryString,
    this.subCategory,
    this.sellerPhoto,
    this.productList,
  });
}

class PromotionProductsPageArg {
  final String promoTitle;
  PromotionProductsPageArg({this.promoTitle});
}
