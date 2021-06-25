import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/categories_view_builder_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/sellers_grid_view_builder_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/productPageArg.dart';
import '../../services/remote_config_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/promotion_slider.dart';
import '../widgets/section_builder.dart';
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
                    aspectRatio: 4.0,
                    key: controller.promotionKey,
                    promotions: controller.topPromotion,
                  ),
                verticalSpaceSmall,
                SectionBuilder(
                  key: categoryUniqueKey,
                  context: context,
                  layoutType: LayoutType.CATEGORY_LAYOUT_3,
                  controller: CategoriesGridViewBuilderController(),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller.remoteConfig
                        .getString(HOMESCREEN_CATEGORY_SECTION_1_TITLE_EN),
                    subTitle: controller.remoteConfig
                        .getString(HOMESCREEN_CATEGORY_SECTION_1_SUBTITLE_EN),
                    viewAll: () => BaseController.category(),
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                  controller: SellersGridViewBuilderController(
                    subscriptionTypes: [1, 2],
                    withProducts: true,
                  ),
                  scrollDirection: Axis.horizontal,
                ),
                SectionDivider(),
                SectionBuilder(
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                  controller:
                      SellersGridViewBuilderController(subscriptionType: 3),
                  scrollDirection: Axis.horizontal,
                ),
                SectionDivider(),
                SectionBuilder(
                  key: productUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  filter: ProductFilter(subCategories: ['1']),
                  controller: ProductsGridViewBuilderController(
                      randomize: true, limit: 10),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_1_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_1_SUBTITLE_EN) ??
                        '',
                    // viewAll: () => BaseController.goToProductListPage(
                    //   ProductPageArg(
                    //     queryString: 'category=1;',
                    //     subCategory: '',
                    //   ),
                    // ),
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  key: sellerUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                  fromHome: true,
                  controller: SellersGridViewBuilderController(
                    profileOnly: true,
                    random: true,
                    boutiquesOnly: true,
                  ),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_DESIGNER_SECTION_1_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_DESIGNER_SECTION_1_SUBTITLE_EN) ??
                        '',
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
                SectionBuilder(
                  key: productUniqueKey ?? UniqueKey(),
                  context: context,
                  filter: ProductFilter(maxPrice: 1750),
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  controller: ProductsGridViewBuilderController(limit: 10),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_2_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_2_SUBTITLE_EN) ??
                        '',
                    // viewAll: () => BaseController.goToProductListPage(
                    //   ProductPageArg(
                    //     queryString: '',
                    //     subCategory: '',
                    //   ),
                    // ),
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  key: sellerUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                  scrollDirection: Axis.horizontal,
                  fromHome: true,
                  toProduct: true,
                  controller: SellersGridViewBuilderController(
                    sellerDeliveringToYou: true,
                    random: true,
                    sellerWithNoProducts: false,
                  ),
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_DESIGNER_SECTION_2_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_DESIGNER_SECTION_2_SUBTITLE_EN) ??
                        '',
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  key: productUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  filter: ProductFilter(minDiscount: 5),
                  controller:
                      ProductsGridViewBuilderController(randomize: true),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_3_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_3_SUBTITLE_EN) ??
                        '',
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
                SectionBuilder(
                  key: productUniqueKey ?? UniqueKey(),
                  context: context,
                  filter: ProductFilter(subCategories: ['9'], maxPrice: 600),
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  scrollDirection: Axis.horizontal,
                  controller:
                      ProductsGridViewBuilderController(randomize: true),
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_4_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_4_SUBTITLE_EN) ??
                        '',
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  key: categoryUniqueKey ?? UniqueKey(),
                  context: context,
                  gridCount: 2,
                  scrollDirection: Axis.vertical,
                  layoutType: LayoutType.CATEGORY_LAYOUT_2,
                  controller: CategoriesGridViewBuilderController(
                    popularCategories: true,
                  ),
                  header: SectionHeader(
                    title: 'Categories people are searching for 😊',
                    subTitle: 'Explore the categories people are looking at',
                    viewAll: BaseController.category,
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  key: productUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  filter: ProductFilter(maxPrice: 450),
                  controller: ProductsGridViewBuilderController(
                      randomize: true, sameDayDelivery: true),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_5_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_5_SUBTITLE_EN) ??
                        '',
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
                SectionBuilder(
                  key: productUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  controller:
                      ProductsGridViewBuilderController(randomize: true),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_6_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_6_SUBTITLE_EN) ??
                        '',
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  key: sellerUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                  scrollDirection: Axis.horizontal,
                  fromHome: true,
                  toProduct: true,
                  controller: SellersGridViewBuilderController(
                    sellerDeliveringToYou: true,
                    topSellers: true,
                    sellerWithNoProducts: false,
                  ),
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_DESIGNER_SECTION_3_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_DESIGNER_SECTION_3_SUBTITLE_EN) ??
                        '',
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  key: productUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  controller: ProductsGridViewBuilderController(
                      randomize: true, limit: 10),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_7_TITLE_EN) ??
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
                SectionBuilder(
                  key: productUniqueKey ?? UniqueKey(),
                  context: context,
                  filter: ProductFilter(subCategories: ['11']),
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  controller:
                      ProductsGridViewBuilderController(randomize: true),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_8_TITLE_EN) ??
                        '',
                    subTitle: controller?.remoteConfig?.getString(
                            HOMESCREEN_PRODUCT_SECTION_8_SUBTITLE_EN) ??
                        '',
                  ),
                ),
                SectionDivider(),
                SectionBuilder(
                  key: sellerUniqueKey ?? UniqueKey(),
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT,
                  fromHome: true,
                  scrollDirection: Axis.vertical,
                  controller: SellersGridViewBuilderController(random: true),
                  header: SectionHeader(
                      title: controller?.remoteConfig?.getString(
                              HOMESCREEN_DESIGNER_SECTION_4_TITLE_EN) ??
                          '',
                      subTitle: controller?.remoteConfig?.getString(
                              HOMESCREEN_DESIGNER_SECTION_4_SUBTITLE_EN) ??
                          ''),
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
    return verticalSpaceSmall;
    // ignore: dead_code
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
