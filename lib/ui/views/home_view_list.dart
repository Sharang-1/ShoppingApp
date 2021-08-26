import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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

  final Map<String, Duration> sectionDelay = {
    "SECTION1": Duration(seconds: 0),
    "SECTION2": Duration(seconds: 0),
    "SECTION3": Duration(seconds: 2),
    "SECTION4": Duration(seconds: 6),
    "SECTION5": Duration(seconds: 8),
    "SECTION6": Duration(seconds: 3),
    "SECTION7": Duration(seconds: 6),
    "SECTION8": Duration(seconds: 6),
    "SECTION9": Duration(seconds: 8),
    "SECTION10": Duration(seconds: 6),
    "SECTION11": Duration(seconds: 10),
  };

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
                if ((controller?.topPromotion?.length ?? 0) > 0) ...[
                  PromotionSlider(
                    aspectRatio: 4.0,
                    key: controller.promotionKey,
                    promotions: controller.topPromotion,
                  ),
                  verticalSpaceSmall,
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION1'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionBuilder(
                        key: categoryUniqueKey,
                        context: context,
                        layoutType: LayoutType.CATEGORY_LAYOUT_3,
                        controller: CategoriesGridViewBuilderController(),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_1_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_1_SUBTITLE_EN),
                          viewAll: () => BaseController.category(),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION2'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [1, 2],
                          withProducts: true,
                          random: true,
                          limit: 7,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_2_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_2_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 0) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[0])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION3'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [1, 3],
                          random: true,
                          limit: 12,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_3_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_3_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 1) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[1])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION4'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [2],
                          withProducts: true,
                          random: true,
                          limit: 7,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_4_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_4_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 2) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[2])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION5'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [1],
                          withProducts: true,
                          random: true,
                          limit: 7,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_5_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_5_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 3) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[3]),
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION6'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_6_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_6_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION7'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: sellerUniqueKey ?? UniqueKey(),
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                        fromHome: true,
                        controller: SellersGridViewBuilderController(
                          random: true,
                          subscriptionType: 3,
                          limit: 12,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_7_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_7_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 4) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[4])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION8'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: productUniqueKey ?? UniqueKey(),
                        context: context,
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        filter: ProductFilter(minDiscount: 5),
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_8_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_8_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 5) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[5])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION9'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [1, 2],
                          withProducts: true,
                          random: true,
                          limit: 7,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_9_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_9_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 6) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[6]),
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION10'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: productUniqueKey ?? UniqueKey(),
                        context: context,
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_10_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_10_SUBTITLE_EN),
                          viewAll: () {
                            BaseController.goToProductListPage(ProductPageArg(
                              queryString: '',
                              subCategory: '',
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller?.bottomPromotion?.length ?? 0) > 7) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[7]),
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION11'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: sellerUniqueKey ?? UniqueKey(),
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT,
                        fromHome: true,
                        scrollDirection: Axis.vertical,
                        controller:
                            SellersGridViewBuilderController(random: true),
                        header: SectionHeader(
                          title: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_11_TITLE_EN),
                          subTitle: controller.remoteConfig
                              .getString(HOMESCREEN_SECTION_11_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
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
