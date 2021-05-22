import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/categories_view_builder_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/sellers_grid_view_builder_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/categorys.dart';
import '../../models/grid_view_builder_filter_models/categoryFilter.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/grid_view_builder_filter_models/sellerFilter.dart';
import '../../models/productPageArg.dart';
import '../../models/products.dart';
import '../../models/sellers.dart';
import '../../services/remote_config_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/GridListWidget.dart';
import '../widgets/categoryTileUI.dart';
import '../widgets/home_view_list_header.dart';
import '../widgets/promotion_slider.dart';
import '../widgets/sellerTileUi.dart';
import '../widgets/top_picks_deals_card.dart';
import 'promotion_products_view.dart';

class HomeViewList extends StatelessWidget {
  final HomeController controller;
  final productUniqueKey;
  final sellerUniqueKey;
  final categoryUniqueKey;

  HomeViewList(
      {Key key,
      this.controller,
      this.productUniqueKey,
      this.sellerUniqueKey,
      this.categoryUniqueKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: controller,
        builder: (controller) {
          return Container(
            padding: EdgeInsets.fromLTRB(
                screenPadding - 15, 5, screenPadding - 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if ((controller?.topPromotion?.length ?? 0) == 0)
                  Container(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if ((controller?.topPromotion?.length ?? 0) > 0)
                  PromotionSlider(
                    key: controller.promotionKey,
                    promotions: controller.topPromotion,
                  ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_PRODUCT_SECTION_1_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_PRODUCT_SECTION_1_SUBTITLE_EN) ??
                      '',
                  viewAll: () => BaseController.goToProductListPage(
                    ProductPageArg(
                      queryString: 'category=1;',
                      subCategory: '',
                    ),
                  ),
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 240,
                  child: GridListWidget<Products, Product>(
                    key: productUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: ProductFilter(subCategories: ['1']),
                    gridCount: 2,
                    controller: ProductsGridViewBuilderController(
                        randomize: true, limit: 10),
                    childAspectRatio: 1.35,
                    scrollDirection: Axis.horizontal,
                    disablePagination: true,
                    tileBuilder: (BuildContext context, productData, index,
                        onUpdate, onDelete) {
                      var product = productData as Product;
                      return GestureDetector(
                        onTap: () =>
                            BaseController.goToProductPage(productData),
                        child: TopPicksAndDealsCard(
                          data: {
                            "key": product?.key ?? "Test",
                            "name": product?.name ?? "Test",
                            "actualCost": (product.cost.cost +
                                    product.cost.convenienceCharges.cost +
                                    product.cost.gstCharges.cost +
                                    controller.deliveryCharges)
                                .round(),
                            "price": (product.cost.costToCustomer +
                                        controller.deliveryCharges)
                                    .round() ??
                                0,
                            "discount":
                                product?.cost?.productDiscount?.rate ?? 0,
                            "photo": product?.photo?.photos?.first?.name,
                            "sellerName": product?.seller?.name ?? "",
                            "isDiscountAvailable": product?.discount != null &&
                                    product.discount != 0
                                ? "true"
                                : null,
                          },
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_DESIGNER_SECTION_1_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_DESIGNER_SECTION_1_SUBTITLE_EN) ??
                      '',
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 220,
                  child: GridListWidget<Sellers, Seller>(
                    key: sellerUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: SellerFilter(),
                    gridCount: 1,
                    childAspectRatio: 0.60,
                    controller: SellersGridViewBuilderController(
                        profileOnly: true, random: true, boutiquesOnly: true),
                    disablePagination: true,
                    scrollDirection: Axis.horizontal,
                    emptyListWidget: Container(),
                    tileBuilder: (BuildContext context, data, index, onDelete,
                        onUpdate) {
                      return GestureDetector(
                        onTap: () => {},
                        child: SellerTileUi(
                          data: data,
                          fromHome: true,
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                  title: 'Shop By Category 🛍️',
                  subTitle: 'Shop designer wear by specific categories',
                  viewAll: () => BaseController.category(),
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 140,
                  child: GridListWidget<Categorys, Category>(
                    key: categoryUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: CategoryFilter(),
                    gridCount: 1,
                    childAspectRatio: 0.5,
                    controller: CategoriesGridViewBuilderController(),
                    disablePagination: true,
                    scrollDirection: Axis.horizontal,
                    emptyListWidget: Container(),
                    tileBuilder: (BuildContext context, data, index, onDelete,
                        onUpdate) {
                      return GestureDetector(
                        onTap: () => controller.showProducts(
                          data.filter,
                          data.name,
                        ),
                        child: CategoryTileUI(
                          data: data,
                        ),
                      );
                    },
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 0)
                  SectionDivider(),
                if ((controller?.bottomPromotion?.length ?? 0) > 0)
                  GestureDetector(
                    onTap: () {
                      var promoTitle = controller.bottomPromotion[0]?.name;
                      List<String> productIds = controller
                          .bottomPromotion[0]?.products
                          ?.map((e) => e.toString())
                          ?.toList();
                      print(productIds);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => PromotionProduct(
                            promotionId: controller.bottomPromotion[0]?.key,
                            productIds: productIds ?? [],
                            promotionTitle: promoTitle,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.width) / 1.6,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(curve15),
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              controller.bottomPromotion[0]?.banner != null
                                  ? "$PROMOTION_PHOTO_BASE_URL/${controller.bottomPromotion[0]?.key}"
                                  : "https://templates.designwizard.com/663467c0-7840-11e7-81f8-bf6782823ae8.jpg",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_PRODUCT_SECTION_2_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_PRODUCT_SECTION_2_SUBTITLE_EN) ??
                      '',
                  viewAll: () => BaseController.goToProductListPage(
                    ProductPageArg(
                      queryString: '',
                      subCategory: '',
                    ),
                  ),
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 240,
                  child: GridListWidget<Products, Product>(
                    key: productUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: ProductFilter(maxPrice: 1750),
                    gridCount: 2,
                    controller: ProductsGridViewBuilderController(limit: 10),
                    childAspectRatio: 1.35,
                    scrollDirection: Axis.horizontal,
                    disablePagination: true,
                    tileBuilder: (BuildContext context, productData, index,
                        onUpdate, onDelete) {
                      var product = productData as Product;
                      return GestureDetector(
                        onTap: () =>
                            BaseController.goToProductPage(productData),
                        child: TopPicksAndDealsCard(
                          data: {
                            "key": product?.key ?? "Test",
                            "name": product?.name ?? "Test",
                            "actualCost": (product.cost.cost +
                                    product.cost.convenienceCharges.cost +
                                    product.cost.gstCharges.cost +
                                    controller.deliveryCharges)
                                .round(),
                            "price": (product.cost.costToCustomer +
                                        controller.deliveryCharges)
                                    .round() ??
                                0,
                            "discount":
                                product?.cost?.productDiscount?.rate ?? 0,
                            "photo": product?.photo?.photos?.first?.name,
                            "sellerName": product?.seller?.name ?? "",
                            "isDiscountAvailable": product?.discount != null &&
                                    product.discount != 0
                                ? "true"
                                : null,
                          },
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_DESIGNER_SECTION_2_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_DESIGNER_SECTION_2_SUBTITLE_EN) ??
                      '',
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 220,
                  child: GridListWidget<Sellers, Seller>(
                    key: sellerUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: new SellerFilter(),
                    gridCount: 1,
                    childAspectRatio: 0.60,
                    controller: SellersGridViewBuilderController(
                      sellerDeliveringToYou: true,
                      random: true,
                      sellerWithNoProducts: false,
                    ),
                    disablePagination: true,
                    scrollDirection: Axis.horizontal,
                    emptyListWidget: Container(),
                    tileBuilder: (BuildContext context, data, index, onDelete,
                        onUpdate) {
                      return GestureDetector(
                        onTap: () => {},
                        child: SellerTileUi(
                          data: data,
                          fromHome: true,
                          toProduct: true,
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_PRODUCT_SECTION_3_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_PRODUCT_SECTION_3_SUBTITLE_EN) ??
                      '',
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 240,
                  child: GridListWidget<Products, Product>(
                    key: productUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: ProductFilter(minDiscount: 5),
                    gridCount: 2,
                    emptyListWidget: Container(),
                    controller:
                        ProductsGridViewBuilderController(randomize: true),
                    childAspectRatio: 1.35,
                    scrollDirection: Axis.horizontal,
                    disablePagination: true,
                    tileBuilder: (BuildContext context, productData, index,
                        onUpdate, onDelete) {
                      var product = productData as Product;
                      return GestureDetector(
                        onTap: () =>
                            BaseController.goToProductPage(productData),
                        child: TopPicksAndDealsCard(
                          data: {
                            "key": product?.key ?? "Test",
                            "name": product?.name ?? "Test",
                            "actualCost": (product.cost.cost +
                                    product.cost.convenienceCharges.cost +
                                    product.cost.gstCharges.cost +
                                    controller.deliveryCharges)
                                .round(),
                            "price": (product.cost.costToCustomer +
                                        controller.deliveryCharges)
                                    .round() ??
                                0,
                            "discount":
                                product?.cost?.productDiscount?.rate ?? 0,
                            "photo": product?.photo?.photos?.first?.name,
                            "sellerName": product?.seller?.name ?? "",
                            "isDiscountAvailable": product?.discount != null &&
                                    product.discount != 0
                                ? "true"
                                : null,
                          },
                        ),
                      );
                    },
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 1)
                  SectionDivider(),
                if ((controller?.bottomPromotion?.length ?? 0) > 1)
                  GestureDetector(
                    onTap: () {
                      var promoTitle = controller.bottomPromotion[1]?.name;
                      List<String> productIds = controller
                          .bottomPromotion[1]?.products
                          ?.map((e) => e.toString())
                          ?.toList();
                      print(productIds);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PromotionProduct(
                            promotionId: controller.bottomPromotion[1]?.key,
                            productIds: productIds ?? [],
                            promotionTitle: promoTitle,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.width) / 1.6,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(curve15),
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              controller.bottomPromotion[0]?.banner != null
                                  ? "$PROMOTION_PHOTO_BASE_URL/${controller.bottomPromotion[1]?.key}"
                                  : "https://templates.designwizard.com/663467c0-7840-11e7-81f8-bf6782823ae8.jpg",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_PRODUCT_SECTION_4_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_PRODUCT_SECTION_4_SUBTITLE_EN) ??
                      '',
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 240,
                  child: GridListWidget<Products, Product>(
                    key: productUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: ProductFilter(subCategories: ['9'], maxPrice: 600),
                    gridCount: 2,
                    emptyListWidget: Container(),
                    controller:
                        ProductsGridViewBuilderController(randomize: true),
                    childAspectRatio: 1.35,
                    scrollDirection: Axis.horizontal,
                    disablePagination: true,
                    tileBuilder: (BuildContext context, productData, index,
                        onUpdate, onDelete) {
                      var product = productData as Product;
                      return GestureDetector(
                        onTap: () =>
                            BaseController.goToProductPage(productData),
                        child: TopPicksAndDealsCard(
                          data: {
                            "key": product?.key ?? "Test",
                            "name": product?.name ?? "Test",
                            "actualCost": (product.cost.cost +
                                    product.cost.convenienceCharges.cost +
                                    product.cost.gstCharges.cost +
                                    controller.deliveryCharges)
                                .round(),
                            "price": (product.cost.costToCustomer +
                                        controller.deliveryCharges)
                                    .round() ??
                                0,
                            "discount":
                                product?.cost?.productDiscount?.rate ?? 0,
                            "photo": product?.photo?.photos?.first?.name,
                            "sellerName": product?.seller?.name ?? "",
                            "isDiscountAvailable": product?.discount != null &&
                                    product.discount != 0
                                ? "true"
                                : null,
                          },
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                  title: 'Categories people are searching for 😊',
                  subTitle: 'Explore the categories people are looking at',
                  viewAll: BaseController.category,
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 200,
                  child: GridListWidget<Categorys, Category>(
                    key: categoryUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: CategoryFilter(),
                    gridCount: 2,
                    childAspectRatio: 2,
                    controller: CategoriesGridViewBuilderController(
                        popularCategories: true),
                    disablePagination: true,
                    scrollDirection: Axis.vertical,
                    emptyListWidget: Container(),
                    tileBuilder: (BuildContext context, data, index, onDelete,
                        onUpdate) {
                      return GestureDetector(
                        onTap: () => controller.showProducts(
                          data.filter,
                          data.name,
                        ),
                        child: CategoryTileUI(
                          data: data,
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_PRODUCT_SECTION_5_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_PRODUCT_SECTION_5_SUBTITLE_EN) ??
                      '',
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 240,
                  child: GridListWidget<Products, Product>(
                    key: productUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: ProductFilter(maxPrice: 450),
                    gridCount: 2,
                    controller: ProductsGridViewBuilderController(
                        randomize: true, sameDayDelivery: true),
                    childAspectRatio: 1.35,
                    scrollDirection: Axis.horizontal,
                    disablePagination: true,
                    tileBuilder: (BuildContext context, productData, index,
                        onUpdate, onDelete) {
                      var product = productData as Product;
                      return GestureDetector(
                        onTap: () =>
                            BaseController.goToProductPage(productData),
                        child: TopPicksAndDealsCard(
                          data: {
                            "key": product?.key ?? "Test",
                            "name": product?.name ?? "Test",
                            "actualCost": (product.cost.cost +
                                    product.cost.convenienceCharges.cost +
                                    product.cost.gstCharges.cost +
                                    controller.deliveryCharges)
                                .round(),
                            "price": (product.cost.costToCustomer +
                                        controller.deliveryCharges)
                                    .round() ??
                                0,
                            "discount":
                                product?.cost?.productDiscount?.rate ?? 0,
                            "photo": product?.photo?.photos?.first?.name,
                            "sellerName": product?.seller?.name ?? "",
                            "isDiscountAvailable": product?.discount != null &&
                                    product.discount != 0
                                ? "true"
                                : null,
                          },
                        ),
                      );
                    },
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 2)
                  SectionDivider(),
                if ((controller?.bottomPromotion?.length ?? 0) > 2)
                  GestureDetector(
                    onTap: () {
                      var promoTitle = controller.bottomPromotion[2]?.name;
                      List<String> productIds = controller
                          .bottomPromotion[2]?.products
                          ?.map((e) => e.toString())
                          ?.toList();
                      print(productIds);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => PromotionProduct(
                            promotionId: controller.bottomPromotion[2]?.key,
                            productIds: productIds ?? [],
                            promotionTitle: promoTitle,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.width) / 1.6,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(curve15),
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              controller.bottomPromotion[0]?.banner != null
                                  ? "assets/preloading1.png"
                                  : "assets/preloading1.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_PRODUCT_SECTION_6_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_PRODUCT_SECTION_6_SUBTITLE_EN) ??
                      '',
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 240,
                  child: GridListWidget<Products, Product>(
                    key: productUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: ProductFilter(),
                    gridCount: 2,
                    controller:
                        ProductsGridViewBuilderController(randomize: true),
                    childAspectRatio: 1.35,
                    scrollDirection: Axis.horizontal,
                    disablePagination: true,
                    tileBuilder: (BuildContext context, productData, index,
                        onUpdate, onDelete) {
                      var product = productData as Product;
                      return GestureDetector(
                        onTap: () =>
                            BaseController.goToProductPage(productData),
                        child: TopPicksAndDealsCard(
                          data: {
                            "key": product?.key ?? "Test",
                            "name": product?.name ?? "Test",
                            "actualCost": (product.cost.cost +
                                    product.cost.convenienceCharges.cost +
                                    product.cost.gstCharges.cost +
                                    controller.deliveryCharges)
                                .round(),
                            "price": (product.cost.costToCustomer +
                                        controller.deliveryCharges)
                                    .round() ??
                                0,
                            "discount":
                                product?.cost?.productDiscount?.rate ?? 0,
                            "photo": product?.photo?.photos?.first?.name,
                            "sellerName": product?.seller?.name ?? "",
                            "isDiscountAvailable":
                                product?.cost?.productDiscount?.rate != null &&
                                        product?.cost?.productDiscount?.rate !=
                                            0
                                    ? "true"
                                    : null,
                          },
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_DESIGNER_SECTION_3_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_DESIGNER_SECTION_3_SUBTITLE_EN) ??
                      '',
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 220,
                  child: GridListWidget<Sellers, Seller>(
                    key: sellerUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: SellerFilter(),
                    gridCount: 1,
                    childAspectRatio: 0.60,
                    controller: SellersGridViewBuilderController(
                      sellerDeliveringToYou: true,
                      topSellers: true,
                      sellerWithNoProducts: false,
                    ),
                    disablePagination: true,
                    scrollDirection: Axis.horizontal,
                    emptyListWidget: Container(),
                    tileBuilder: (BuildContext context, data, index, onDelete,
                        onUpdate) {
                      return GestureDetector(
                        onTap: () => {},
                        child: SellerTileUi(
                          data: data,
                          fromHome: true,
                          toProduct: true,
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_PRODUCT_SECTION_7_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_PRODUCT_SECTION_7_SUBTITLE_EN) ??
                      '',
                  viewAll: () {
                    BaseController.goToProductListPage(ProductPageArg(
                      queryString: '',
                      subCategory: '',
                    ));
                  },
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 240,
                  child: GridListWidget<Products, Product>(
                    key: productUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: ProductFilter(),
                    gridCount: 2,
                    controller: ProductsGridViewBuilderController(
                        randomize: true, limit: 10),
                    childAspectRatio: 1.35,
                    scrollDirection: Axis.horizontal,
                    disablePagination: true,
                    tileBuilder: (BuildContext context, productData, index,
                        onUpdate, onDelete) {
                      var product = productData as Product;
                      return GestureDetector(
                        onTap: () =>
                            BaseController.goToProductPage(productData),
                        child: TopPicksAndDealsCard(
                          data: {
                            "key": product?.key ?? "Test",
                            "name": product?.name ?? "Test",
                            "actualCost": (product.cost.cost +
                                    product.cost.convenienceCharges.cost +
                                    product.cost.gstCharges.cost +
                                    controller.deliveryCharges)
                                .round(),
                            "price": (product.cost.costToCustomer +
                                        controller.deliveryCharges)
                                    .round() ??
                                0,
                            "discount":
                                product?.cost?.productDiscount?.rate ?? 0,
                            "photo": product?.photo?.photos?.first?.name,
                            "sellerName": product?.seller?.name ?? "",
                            "isDiscountAvailable": product?.discount != null &&
                                    product.discount != 0
                                ? "true"
                                : null,
                          },
                        ),
                      );
                    },
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 3)
                  SectionDivider(),
                if ((controller?.bottomPromotion?.length ?? 0) > 3)
                  GestureDetector(
                    onTap: () {
                      var promoTitle = controller.bottomPromotion[3]?.name;
                      List<String> productIds = controller
                          .bottomPromotion[3]?.products
                          ?.map((e) => e.toString())
                          ?.toList();
                      print(productIds);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => PromotionProduct(
                            promotionId: controller.bottomPromotion[3]?.key,
                            productIds: productIds ?? [],
                            promotionTitle: promoTitle,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.width) / 1.6,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(curve15),
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              controller.bottomPromotion[0]?.banner != null
                                  ? "assets/preloading1.png"
                                  : "assets/preloading1.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SectionDivider(),
                HomeViewListHeader(
                  title: controller?.remoteConfig
                          ?.getString(HOMESCREEN_PRODUCT_SECTION_8_TITLE_EN) ??
                      '',
                  subTitle: controller?.remoteConfig?.getString(
                          HOMESCREEN_PRODUCT_SECTION_8_SUBTITLE_EN) ??
                      '',
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 240,
                  child: GridListWidget<Products, Product>(
                    key: productUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: ProductFilter(subCategories: ['11']),
                    gridCount: 2,
                    controller:
                        ProductsGridViewBuilderController(randomize: true),
                    childAspectRatio: 1.35,
                    scrollDirection: Axis.horizontal,
                    disablePagination: true,
                    emptyListWidget: Container(),
                    tileBuilder: (BuildContext context, productData, index,
                        onUpdate, onDelete) {
                      var product = productData as Product;
                      return GestureDetector(
                        onTap: () =>
                            BaseController.goToProductPage(productData),
                        child: TopPicksAndDealsCard(
                          data: {
                            "key": product?.key ?? "Test",
                            "name": product?.name ?? "Test",
                            "actualCost": (product.cost.cost +
                                    product.cost.convenienceCharges.cost +
                                    product.cost.gstCharges.cost +
                                    controller.deliveryCharges)
                                .round(),
                            "price": (product.cost.costToCustomer +
                                        controller.deliveryCharges)
                                    .round() ??
                                0,
                            "discount":
                                product?.cost?.productDiscount?.rate ?? 0,
                            "photo": product?.photo?.photos?.first?.name,
                            "sellerName": product?.seller?.name ?? "",
                            "isDiscountAvailable":
                                product?.cost?.productDiscount?.rate != null &&
                                        product?.cost?.productDiscount?.rate !=
                                            0
                                    ? "true"
                                    : null,
                          },
                        ),
                      );
                    },
                  ),
                ),
                SectionDivider(),
                HomeViewListHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_DESIGNER_SECTION_4_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_DESIGNER_SECTION_4_SUBTITLE_EN) ??
                        ''),
                verticalSpaceSmall,
                SizedBox(
                  // height: 300,
                  child: GridListWidget<Sellers, Seller>(
                    key: sellerUniqueKey ?? UniqueKey(),
                    context: context,
                    filter: new SellerFilter(),
                    gridCount: 1,
                    childAspectRatio: 1.80,
                    controller: SellersGridViewBuilderController(random: true),
                    disablePagination: true,
                    scrollDirection: Axis.vertical,
                    emptyListWidget: Container(),
                    tileBuilder: (BuildContext context, data, index, onDelete,
                        onUpdate) {
                      return GestureDetector(
                        onTap: () => {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SellerTileUi(
                            data: data,
                            fromHome: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextButton(
                        onPressed: () {
                          controller.showSellers();
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: darkRedSmooth,
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(curve30),
                          ),
                        ),
                        child: Text(
                          "Search Designers",
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  height: 80,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenPadding, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/svg/dzor_logo.svg",
                        color: Colors.grey[800],
                        height: 35,
                        width: 35,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Made with Love in Ahmedabad!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        height: 4.0,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
