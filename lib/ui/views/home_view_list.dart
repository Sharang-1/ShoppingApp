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
                      child: Image.asset(
                      "assets/images/loading_img.gif",
                      height: 50,
                      width: 50,
                    ),
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
                            demographicIds: controller
                                .bottomPromotion[0]?.demographics
                                ?.map((e) => e?.id)
                                ?.toList(),
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
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                  controller:
                      SellersGridViewBuilderController(subscriptionType: 3),
                  scrollDirection: Axis.horizontal,
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
                        new MaterialPageRoute(
                          builder: (context) => PromotionProduct(
                            promotionId: controller.bottomPromotion[1]?.key,
                            productIds: productIds ?? [],
                            promotionTitle: promoTitle,
                            demographicIds: controller
                                .bottomPromotion[1]?.demographics
                                ?.map((e) => e?.id)
                                ?.toList(),
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
                              controller.bottomPromotion[1]?.banner != null
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
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                  controller: SellersGridViewBuilderController(
                    subscriptionTypes: [2],
                    withProducts: true,
                  ),
                  scrollDirection: Axis.horizontal,
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
                            demographicIds: controller
                                .bottomPromotion[2]?.demographics
                                ?.map((e) => e?.id)
                                ?.toList(),
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
                              controller.bottomPromotion[2]?.banner != null
                                  ? "$PROMOTION_PHOTO_BASE_URL/${controller.bottomPromotion[2]?.key}"
                                  : "https://templates.designwizard.com/663467c0-7840-11e7-81f8-bf6782823ae8.jpg",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SectionDivider(),
                SectionBuilder(
                  context: context,
                  layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                  controller: SellersGridViewBuilderController(
                    subscriptionTypes: [1],
                    withProducts: true,
                  ),
                  scrollDirection: Axis.horizontal,
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
                            demographicIds: controller
                                .bottomPromotion[3]?.demographics
                                ?.map((e) => e?.id)
                                ?.toList(),
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
                              controller.bottomPromotion[3]?.banner != null
                                  ? "$PROMOTION_PHOTO_BASE_URL/${controller.bottomPromotion[3]?.key}"
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
                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                  filter: ProductFilter(
                    subCategories: [
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '12'
                    ],
                    maxPrice: 750,
                  ),
                  controller: ProductsGridViewBuilderController(
                    randomize: true,
                    limit: 10,
                  ),
                  scrollDirection: Axis.horizontal,
                  header: SectionHeader(
                    title: "Below ₹999",
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
                    random: true,
                    subscriptionType: 3,
                  ),
                  scrollDirection: Axis.horizontal,
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 4)
                  SectionDivider(),
                if ((controller?.bottomPromotion?.length ?? 0) > 4)
                  GestureDetector(
                    onTap: () {
                      var promoTitle = controller.bottomPromotion[4]?.name;
                      List<String> productIds = controller
                          .bottomPromotion[4]?.products
                          ?.map((e) => e.toString())
                          ?.toList();
                      print(productIds);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => PromotionProduct(
                            promotionId: controller.bottomPromotion[4]?.key,
                            productIds: productIds ?? [],
                            promotionTitle: promoTitle,
                            demographicIds: controller
                                .bottomPromotion[4]?.demographics
                                ?.map((e) => e?.id)
                                ?.toList(),
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
                              controller.bottomPromotion[4]?.banner != null
                                  ? "$PROMOTION_PHOTO_BASE_URL/${controller.bottomPromotion[4]?.key}"
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
                if ((controller?.bottomPromotion?.length ?? 0) > 5)
                  SectionDivider(),
                if ((controller?.bottomPromotion?.length ?? 0) > 5)
                  GestureDetector(
                    onTap: () {
                      var promoTitle = controller.bottomPromotion[5]?.name;
                      List<String> productIds = controller
                          .bottomPromotion[5]?.products
                          ?.map((e) => e.toString())
                          ?.toList();
                      print(productIds);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => PromotionProduct(
                            promotionId: controller.bottomPromotion[5]?.key,
                            productIds: productIds ?? [],
                            promotionTitle: promoTitle,
                            demographicIds: controller
                                .bottomPromotion[5]?.demographics
                                ?.map((e) => e?.id)
                                ?.toList(),
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
                              controller.bottomPromotion[5]?.banner != null
                                  ? "$PROMOTION_PHOTO_BASE_URL/${controller.bottomPromotion[5]?.key}"
                                  : "https://templates.designwizard.com/663467c0-7840-11e7-81f8-bf6782823ae8.jpg",
                            ),
                          ),
                        ),
                      ),
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
                if ((controller?.bottomPromotion?.length ?? 0) > 6)
                  SectionDivider(),
                if ((controller?.bottomPromotion?.length ?? 0) > 6)
                  GestureDetector(
                    onTap: () {
                      var promoTitle = controller.bottomPromotion[6]?.name;
                      List<String> productIds = controller
                          .bottomPromotion[6]?.products
                          ?.map((e) => e.toString())
                          ?.toList();
                      print(productIds);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => PromotionProduct(
                            promotionId: controller.bottomPromotion[6]?.key,
                            productIds: productIds ?? [],
                            promotionTitle: promoTitle,
                            demographicIds: controller
                                .bottomPromotion[6]?.demographics
                                ?.map((e) => e?.id)
                                ?.toList(),
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
                              controller.bottomPromotion[6]?.banner != null
                                  ? "$PROMOTION_PHOTO_BASE_URL/${controller.bottomPromotion[6]?.key}"
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.grey[300],
        thickness: 5,
      ),
    );
  }
}
