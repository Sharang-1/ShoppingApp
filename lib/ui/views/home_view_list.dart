import '../widgets/home_view_list_header.dart';
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
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/promotion_slider.dart';
import '../widgets/section_builder.dart';
import '../widgets/shimmer/shimmer_widget.dart';

class HomeViewList extends StatefulWidget {
  final HomeController? controller;
  final productUniqueKey;
  final sellerUniqueKey;
  final categoryUniqueKey;

  HomeViewList(
      {Key? key,
      this.controller,
      this.productUniqueKey,
      this.sellerUniqueKey,
      this.categoryUniqueKey})
      : super(key: key);

  @override
  _HomeViewListState createState() => _HomeViewListState();
}

class _HomeViewListState extends State<HomeViewList> {
  final Map<String, Duration> sectionDelay = {
    "SECTION1": Duration(seconds: 0),
    "SECTION2": Duration(seconds: 2),
    "SECTION3": Duration(seconds: 4),
    "SECTION4": Duration(seconds: 5),
    "SECTION5": Duration(seconds: 6),
    "SECTION6": Duration(seconds: 7),
    "SECTION7": Duration(seconds: 8),
    "SECTION8": Duration(seconds: 8),
    "SECTION9": Duration(seconds: 8),
    "SECTION10": Duration(seconds: 8),
    "SECTION11": Duration(seconds: 10),
    "SECTION12": Duration(seconds: 10),
    "SECTION13": Duration(seconds: 10),
    "SECTION14": Duration(seconds: 10),
    "LAST_SECTION": Duration(seconds: 10),
  };

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: widget.controller,
        builder: (controller) {
          return Container(
            padding: EdgeInsets.fromLTRB(
                screenPadding - 15, 5, screenPadding - 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if ((controller.topPromotion.length) == 0)
                  Container(
                    height: 200,
                    child: ShimmerWidget(),
                    // Center(
                    //   child: Image.asset(
                    //     "assets/images/loading_img.gif",
                    //     height: 50,
                    //     width: 50,
                    //   ),
                    // ),
                  ),
                if ((controller.topPromotion.length) > 0) ...[
                  HomeViewListHeader(
                      title: controller.remoteConfig!
                          .getString(TOP_PROMOTION_TITLE_EN)),
                  verticalSpaceTiny,
                  PromotionSlider(
                    aspectRatio: 4.0,
                    key: controller.promotionKey,
                    promotions: controller.topPromotion,
                  ),
                  // SectionDivider(),
                  verticalSpaceSmall,
                ],
                Container(
                  color: Colors.white,
                  child: Image.asset(
                    'assets/images/delivery_upi.png',
                    fit: BoxFit.fill,
                  )
                ),
                verticalSpaceSmall,

                // SectionDivider(),
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION1']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SectionDivider(),
                      SectionBuilder(
                        key: widget.productUniqueKey ?? UniqueKey(),
                        context: context,
                        onEmptyList: () {},
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        filter: ProductFilter(
                          subCategories: [
                            '9',
                            '11',
                            '15',
                          ],
                        ),
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_4_TITLE_EN),
                          subTitle: "",
                          viewAll: () {
                            BaseController.goToProductListPage(ProductPageArg(
                              queryString:
                                  'category=9;category=11;category=15;',
                              subCategory: '',
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                FutureSectionBuilder(
                  duration: sectionDelay['SECTION1']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: widget.productUniqueKey ?? UniqueKey(),
                        context: context,
                        onEmptyList: () {},
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        filter: ProductFilter(
                          subCategories: [
                            '21'
                          ],
                        ),
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: "Unique Home Decor",
                          subTitle: "",
                          viewAll: () {
                            BaseController.goToProductListPage(ProductPageArg(
                              queryString:
                              'category=21;',
                              subCategory: '21',
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller.bottomPromotion.length) > 0) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[0])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION2']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: widget.productUniqueKey ?? UniqueKey(),
                        context: context,
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        filter: ProductFilter(minDiscount: 5),
                        onEmptyList: () {},
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_2_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_2_SUBTITLE_EN),
                          viewAll: () {
                            BaseController.goToProductListPage(ProductPageArg(
                              queryString: 'minDiscount=5;',
                              subCategory: '',
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION3']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                        onEmptyList: () {},
                        controller: SellersGridViewBuilderController(
                          removeId: '',
                          subscriptionTypes: [1, 2],
                          withProducts: true,
                          random: true,
                          limit: 7,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_3_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_3_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                SectionDivider(),
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION3']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SectionDivider(),
                      SectionBuilder(
                        key: widget.productUniqueKey ?? UniqueKey(),
                        context: context,
                        onEmptyList: () {},
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        filter: ProductFilter(
                          subCategories: [
                            '10'
                          ],
                        ),
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: "UNIQUE DESIGNER FOOT WEARS",
                          // title: controller.remoteConfig!
                          //     .getString(HOMESCREEN_SECTION_6_TITLE_EN),
                          subTitle: "",
                          viewAll: () {
                            BaseController.goToProductListPage(ProductPageArg(
                              queryString:
                              'category=10;',
                              subCategory: '',
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SectionDivider(),

                FutureSectionBuilder(
                  duration: sectionDelay['SECTION4']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SectionDivider(),
                      SectionBuilder(
                        key: widget.productUniqueKey ?? UniqueKey(),
                        context: context,
                        onEmptyList: () {},
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        filter: ProductFilter(
                          // subCategories: [
                          //   '1',
                          //   '2',
                          //   '3',
                          //   '4',
                          //   '5',
                          //   '6',
                          //   '7',
                          //   '8',
                          //   '12'
                          // ],
                          maxPrice: 750,
                        ),
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_1_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_1_SUBTITLE_EN),
                          viewAll: () {
                            BaseController.goToProductListPage(ProductPageArg(
                              queryString: 'maxPrice=750;',
                              subCategory: '',
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller.bottomPromotion.length) > 1) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[1])
                ],
                // FutureSectionBuilder(
                //   duration: sectionDelay['SECTION5']!,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SectionDivider(),
                //       SectionBuilder(
                //         key: widget.sellerUniqueKey ?? UniqueKey(),
                //         context: context,
                //         layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                //         fromHome: true,
                //         onEmptyList: () {},
                //         controller: SellersGridViewBuilderController(
                //           random: true,
                //           subscriptionType: 3,
                //           boutiquesOnly: true,
                //           limit: 12,
                //         ),
                //         scrollDirection: Axis.horizontal,
                //         header: SectionHeader(
                //           title: controller.remoteConfig!
                //               .getString(HOMESCREEN_SECTION_5_TITLE_EN),
                //           subTitle: controller.remoteConfig!
                //               .getString(HOMESCREEN_SECTION_5_SUBTITLE_EN),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION6']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: widget.productUniqueKey ?? UniqueKey(),
                        context: context,
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        onEmptyList: () {},
                        filter: ProductFilter(
                          subCategories: [
                            '1',
                          ],
                        ),
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_6_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_6_SUBTITLE_EN),
                          viewAll: () {
                            BaseController.goToProductListPage(ProductPageArg(
                              queryString: 'category=1;',
                              subCategory: '',
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller.bottomPromotion.length) > 2) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[2])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION7']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                        onEmptyList: () {},
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [1, 3],
                          random: true,
                          limit: 12,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_7_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_7_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION8']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: widget.productUniqueKey ?? UniqueKey(),
                        context: context,
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        onEmptyList: () {},
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
                          maxPrice: 1500,
                        ),
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_8_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_8_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION9']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                        onEmptyList: () {},
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [2],
                          withProducts: true,
                          random: true,
                          limit: 7,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_9_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_9_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller.bottomPromotion.length) > 3) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[3]),
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION10']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: widget.categoryUniqueKey,
                        context: context,
                        layoutType: LayoutType.CATEGORY_LAYOUT_3,
                        onEmptyList: () {},
                        controller: CategoriesGridViewBuilderController(),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_10_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_10_SUBTITLE_EN),
                          viewAll: () => BaseController.category(),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller.bottomPromotion.length) > 4) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[4])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION11']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                        onEmptyList: () {},
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [1],
                          withProducts: true,
                          random: true,
                          limit: 7,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_11_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_11_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller.bottomPromotion.length) > 5) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[5])
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION12']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        context: context,
                        layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                        onEmptyList: () {},
                        controller: SellersGridViewBuilderController(
                          subscriptionTypes: [1, 2],
                          withProducts: true,
                          random: true,
                          boutiquesOnly: true,
                          limit: 7,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_12_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_12_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((controller.bottomPromotion.length) > 6) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[6]),
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION13']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: widget.productUniqueKey ?? UniqueKey(),
                        context: context,
                        onEmptyList: () {},
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        controller: ProductsGridViewBuilderController(
                          randomize: true,
                          limit: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_13_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_13_SUBTITLE_EN),
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
                if ((controller.bottomPromotion.length) > 7) ...[
                  SectionDivider(),
                  BottomPromotion(promotion: controller.bottomPromotion[7]),
                ],
                FutureSectionBuilder(
                  duration: sectionDelay['SECTION14']!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionDivider(),
                      SectionBuilder(
                        key: widget.sellerUniqueKey ?? UniqueKey(),
                        context: context,
                        onEmptyList: () {},
                        layoutType: LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT,
                        fromHome: true,
                        scrollDirection: Axis.vertical,
                        controller:
                            SellersGridViewBuilderController(random: true),
                        header: SectionHeader(
                          title: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_14_TITLE_EN),
                          subTitle: controller.remoteConfig!
                              .getString(HOMESCREEN_SECTION_14_SUBTITLE_EN),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureSectionBuilder(
                  duration: sectionDelay["LAST_SECTION"]!,
                  child: Column(
                    children: [
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
                                HOMESCREEN_SEARCH_DESIGNERS.tr,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "Made with Love in Ahmedabad!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
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
