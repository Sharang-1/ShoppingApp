import 'categorys.dart';

class ProductPageArg {
  final String? title;
  final String? queryString;
  final String? subCategory;
  final String? sellerPhoto;

  final String? promotionKey;
  final List<int>? demographicIds;

  ProductPageArg({
    this.title,
    this.queryString,
    this.subCategory,
    this.sellerPhoto,
    this.promotionKey,
    this.demographicIds,
  });
}

class PromotionProductsPageArg {
  final String promoTitle;
  PromotionProductsPageArg({required this.promoTitle});
}

class CategoryPageArg {
  final String address;
  final RootCategory subCategory;

  CategoryPageArg({required this.address, required this.subCategory});
}
