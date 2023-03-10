import 'package:auto_size_text/auto_size_text.dart';
import 'package:compound/ui/views/dynamic_section_builder2.dart';
import 'package:compound/ui/views/dynamic_section_builder3.dart';
import 'package:compound/ui/views/dynamic_section_builder4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app.dart';
import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/sellers_grid_view_builder_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/productPageArg.dart';
import '../../models/products.dart';
import '../../models/promotions.dart';
import '../../models/sellers.dart';
import '../../services/navigation_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/home_view_list_header.dart';
import '../widgets/product_tile_ui.dart';
import '../widgets/product_tile_ui_2.dart';
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
    "SECTION2": Duration(seconds: 1),
    "SECTION3": Duration(seconds: 2),
    "SECTION4": Duration(seconds: 4),
    "SECTION5": Duration(seconds: 4),
    "SECTION6": Duration(seconds: 6),
    "SECTION7": Duration(seconds: 6),
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
    int i = 0;

    return GetBuilder<HomeController>(
        init: widget.controller,
        builder: (controller) {
          return FutureBuilder(
              future: getDynamicKeys(),
              builder: (context, data) {
                // data.connectionState == ConnectionState.done
                //     ? Container(
                if (data.connectionState == ConnectionState.done)
                  return Container(
                    // height: MediaQuery.of(context).size.height,
                    // padding: EdgeInsets.fromLTRB(screenPadding - 15, 5, screenPadding - 15, 5),
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(counter.toString()),
                          // Text(DzorConst().promotedProduct.toString()),
                          if ((controller.topPromotion.length) > 0) ...[
                            HomeViewListHeader(
                                title: "Featured Home Grown Brands!"),
                            // title: controller.remoteConfig!
                            //     .getString(TOP_PROMOTION_TITLE_EN),
                            verticalSpaceTiny,
                            PromotionSlider(
                              aspectRatio: 4.0,
                              key: controller.promotionKey,
                              promotions: controller.topPromotion,
                            ),
                            // SectionDivider(),
                            verticalSpaceSmall,
                          ],
                          // Container(
                          //     color: Colors.white,
                          //     child: Image.asset(
                          //       'assets/images/delivery_upi.png',
                          //       fit: BoxFit.fill,
                          //     )),
                          // verticalSpaceSmall,

                          FutureSectionBuilder(
                            duration: sectionDelay['SECTION1']!,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SectionDivider(),
                                SectionBuilder(
                                  key: widget.productUniqueKey ?? UniqueKey(),
                                  context: context,
                                  layoutType: LayoutType.PRODUCT_LAYOUT_4,
                                  filter: ProductFilter(explore: true),
                                  onEmptyList: () {},
                                  controller: ProductsGridViewBuilderController(
                                    randomize: true,
                                    limit: 10,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  header: SectionHeader(
                                    title: "Amazing Products for you",
                                    subTitle: "Scroll right to see more",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SectionDivider(),
                          if (appVar.dynamicSectionKeys.length > i &&
                              appVar.dynamicSectionKeys[i] != "67409233" &&
                              appVar.dynamicSectionKeys[i] != "77816306")
                            FutureBuilder(
                                future:
                                    getProducts(appVar.dynamicSectionKeys[i++]),
                                builder: (context, data) {
                                  if (data.connectionState ==
                                      ConnectionState.active) {
                                    return Container(
                                      height: 200,
                                    );
                                  }

                                  if (data.hasData)
                                    return Container(
                                      height: 260,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: 5,
                                            left: -80,
                                            child: Container(
                                              height: 240,
                                              width: Get.width * 0.7,
                                              child: Image.asset(
                                                "assets/images/bg-1.jpg",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 60,
                                            right: -80,
                                            child: Container(
                                              height: 200,
                                              width: Get.width * 0.7,
                                              child: Image.asset(
                                                "assets/images/bg-1.jpg",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 255,
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      curve15),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 2)
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Editor's Pick",
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    letterSpacing: 0.4,
                                                    fontSize:
                                                        titleFontSizeStyle - 2,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  "${(data.data as Promotion).name}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    // color: Colors.black45,
                                                    color: Colors.grey[800],

                                                    // letterSpacing: 0.4,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    BaseController
                                                        .goToProductListPage(
                                                            ProductPageArg(
                                                      promotionKey: (data.data
                                                              as Promotion)
                                                          .key,
                                                      subCategory: 'Designer',
                                                      queryString: "",
                                                      title: (data.data
                                                              as Promotion)
                                                          .name,
                                                      sellerPhoto: "",
                                                    ));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "View All",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          // letterSpacing: 0.4,
                                                          fontSize:
                                                              titleFontSizeStyle -
                                                                  2,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      horizontalSpaceTiny,
                                                      Icon(
                                                        Icons.arrow_forward,
                                                        size: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            // alignment: Alignment.bottomCenter,
                                            bottom: 40,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: DynamicSectionBuilder2(
                                                header: SectionHeader(
                                                  title:
                                                      (data.data as Promotion)
                                                          .name,
                                                  subTitle: "",
                                                  viewAll: () {
                                                    BaseController
                                                        .goToProductListPage(
                                                            ProductPageArg(
                                                      promotionKey: (data.data
                                                              as Promotion)
                                                          .key,
                                                      subCategory: 'Designer',
                                                      queryString: "",
                                                      title: (data.data
                                                              as Promotion)
                                                          .name,
                                                      sellerPhoto: "",
                                                    ));
                                                  },
                                                ),
                                                products:
                                                    (data.data as Promotion)
                                                            .products ??
                                                        [],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  return Container();
                                }),

                          if (appVar.dynamicSectionKeys.length > i &&
                              appVar.dynamicSectionKeys[i] != "67409233" &&
                              appVar.dynamicSectionKeys[i] != "77816306")
                            Column(
                              children: [
                                SectionDivider(),
                                FutureBuilder(
                                    future: getProducts(
                                        appVar.dynamicSectionKeys[i++]),
                                    builder: (context, data) {
                                      if (data.connectionState ==
                                          ConnectionState.active) {
                                        return ShimmerWidget(
                                            type: LayoutType.PRODUCT_LAYOUT_2);
                                      }
                                      if (data.hasData)
                                        return Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: DynamicSectionBuilder3(
                                            header: SectionHeader(
                                              title:
                                                  (data.data as Promotion).name,
                                              subTitle: "",
                                              viewAll: () {
                                                BaseController
                                                    .goToProductListPage(
                                                        ProductPageArg(
                                                  title:
                                                      (data.data as Promotion)
                                                          .name,
                                                  promotionKey:
                                                      (data.data as Promotion)
                                                          .key,
                                                  subCategory: 'Designer',
                                                  queryString: "",
                                                  sellerPhoto: "",
                                                ));
                                              },
                                            ),
                                            products: (data.data as Promotion)
                                                    .products ??
                                                [],
                                          ),
                                        );
                                      return Container();
                                    }),
                              ],
                            ),
                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION1']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         key: widget.productUniqueKey ?? UniqueKey(),
                          //         context: context,
                          //         onEmptyList: () {},
                          //         layoutType: LayoutType.PRODUCT_LAYOUT_2,
                          //         filter: ProductFilter(
                          //           subCategories: [
                          //             '21'
                          //           ],
                          //         ),
                          //         controller: ProductsGridViewBuilderController(
                          //           randomize: true,
                          //           limit: 10,
                          //         ),
                          //         scrollDirection: Axis.horizontal,
                          //         header: SectionHeader(
                          //           title: "Unique Home Decor",
                          //           subTitle: "",
                          //           viewAll: () {
                          //             BaseController.goToProductListPage(ProductPageArg(
                          //               queryString:
                          //               'category=21;',
                          //               subCategory: '21',
                          //             ));
                          //           },
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // if ((controller.bottomPromotion.length) > 0) ...[
                          //   SectionDivider(),
                          //   // Text("HI"),
                          //   BottomPromotion(promotion: controller.bottomPromotion[0])
                          // ],
                          if (appVar.dynamicSectionKeys.length > i &&
                              appVar.dynamicSectionKeys[i] != "67409233" &&
                              appVar.dynamicSectionKeys[i] != "77816306")
                            FutureBuilder(
                                future:
                                    getProducts(appVar.dynamicSectionKeys[i++]),
                                builder: (context, data) {
                                  if (data.connectionState ==
                                      ConnectionState.active) {
                                    return ShimmerWidget(
                                        type: LayoutType.PRODUCT_LAYOUT_2);
                                  }

                                  if (data.hasData)
                                    return Column(children: [
                                      SectionDivider(),
                                      DynamicSectionBuilder(
                                        header: SectionHeader(
                                          title: (data.data as Promotion).name,
                                          subTitle: "",
                                          viewAll: () {
                                            BaseController.goToProductListPage(
                                                ProductPageArg(
                                              title:
                                                  (data.data as Promotion).name,
                                              promotionKey:
                                                  (data.data as Promotion).key,
                                              subCategory: 'Designer',
                                              queryString: "",
                                              sellerPhoto: "",
                                            ));
                                          },
                                        ),
                                        products:
                                            (data.data as Promotion).products ??
                                                [],
                                      ),
                                    ]);
                                  return Container();
                                }),
                          FutureBuilder(
                              future: getProducts((releaseMode
                                  ? 67409233.toString()
                                  : 39241274.toString())),
                              builder: (context, data) {
                                if (data.connectionState ==
                                    ConnectionState.active) {
                                  return ShimmerWidget(
                                      type: LayoutType.PRODUCT_LAYOUT_2);
                                }

                                if (data.hasData)
                                  return Container(
                                    width: Get.width,
                                    child: Column(
                                      children: [
                                        SectionDivider(),
                                        DynamicSectionBuilder4(
                                          header: SectionHeader(
                                            title:
                                                (data.data as Promotion).name,
                                            subTitle: "",
                                            viewAll: () {
                                              BaseController
                                                  .goToProductListPage(
                                                      ProductPageArg(
                                                promotionKey:
                                                    (data.data as Promotion)
                                                        .key,
                                                title: (data.data as Promotion)
                                                    .name,
                                                subCategory: 'Designer',
                                                queryString: "",
                                                sellerPhoto: "",
                                              ));
                                            },
                                          ),
                                          products: (data.data as Promotion)
                                                  .products ??
                                              [],
                                        ),
                                        // SectionDivider(),
                                      ],
                                    ),
                                  );
                                return Container();
                              }),
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
                                    title: "Best deals all day long",
                                    subTitle: "Scroll right to see more",
                                    // title: controller.remoteConfig!
                                    //     .getString(HOMESCREEN_SECTION_2_TITLE_EN),
                                    // subTitle: controller.remoteConfig!
                                    //     .getString(HOMESCREEN_SECTION_2_SUBTITLE_EN),
                                    viewAll: () {
                                      BaseController.goToProductListPage(
                                          ProductPageArg(
                                        title: "Best deals all day long",
                                        queryString: 'minDiscount=5;',
                                        subCategory: '',
                                      ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FutureBuilder(
                              future: getProducts((releaseMode
                                  ? 77816306.toString()
                                  : 86798079.toString())),
                              builder: (context, data) {
                                if (data.connectionState ==
                                    ConnectionState.active) {
                                  return Container(
                                    height: 200,
                                  );
                                }
                                if (data.hasData &&
                                    (data.data as Promotion).enabled == true)
                                  return FutureBuilder(
                                      future: getSeller(
                                          (data.data as Promotion).filter ??
                                              ""),
                                      builder: (context, data) {
                                        if (data.connectionState ==
                                            ConnectionState.active) {
                                          return Container(
                                            height: 200,
                                          );
                                        }
                                        if (data.hasData)
                                          return Container(
                                            height: 260,
                                            width: double.infinity,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  bottom: 5,
                                                  left: -80,
                                                  child: Container(
                                                    height: 240,
                                                    width: Get.width * 0.7,
                                                    child: Image.asset(
                                                      "assets/images/bg-2.jpeg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 60,
                                                  right: -80,
                                                  child: Container(
                                                    height: 200,
                                                    width: Get.width * 0.7,
                                                    child: Image.asset(
                                                      "assets/images/bg-2.jpeg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 255,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            curve15),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 2)
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Creator in Spotlight",
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          letterSpacing: 0.4,
                                                          fontSize:
                                                              titleFontSizeStyle -
                                                                  2,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade100),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  blurRadius: 5,
                                                                ),
                                                              ],
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    30),
                                                              ),
                                                            ),
                                                            child:
                                                                Image.network(
                                                              "$SELLER_PROFILE_PHOTO_BASE_URL/${(data.data as Seller).key}/profile/${(data.data as Seller).photo?.name}",
                                                              fit: BoxFit.cover,
                                                              height: 35,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Column(
                                                            children: [
                                                              AutoSizeText(
                                                                "${(data.data as Seller).name}",
                                                                maxLines: 1,
                                                                style:
                                                                    TextStyle(
                                                                  // color: Colors.black45,
                                                                  color: Colors
                                                                          .grey[
                                                                      800],

                                                                  // letterSpacing: 0.4,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              AutoSizeText(
                                                                "${(data.data as Seller).bio}",
                                                                maxLines: 1,
                                                                style:
                                                                    TextStyle(
                                                                  // color: Colors.black45,
                                                                  color: Colors
                                                                          .grey[
                                                                      800],

                                                                  // letterSpacing: 0.4,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          NavigationService.to(
                                                            ProductsListRoute,
                                                            arguments:
                                                                ProductPageArg(
                                                              subCategory: (data
                                                                          .data
                                                                      as Seller)
                                                                  .name,
                                                              queryString:
                                                                  "accountKey=${(data.data as Seller).key};",
                                                              sellerPhoto:
                                                                  "$SELLER_PHOTO_BASE_URL/${(data.data as Seller).key}",
                                                            ),
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "View All",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                // letterSpacing: 0.4,
                                                                fontSize:
                                                                    titleFontSizeStyle -
                                                                        2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            horizontalSpaceTiny,
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              size: 12,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 30,
                                                  child: Container(
                                                    height: 150,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.96,
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: (data.data
                                                                as Seller)
                                                            .products
                                                            ?.length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return Container(
                                                            height: 100,
                                                            width: 200,
                                                            child:
                                                                ProductTileUI2(
                                                              data: (data.data
                                                                      as Seller)
                                                                  .products![i],
                                                              cardPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              onClick: () => BaseController
                                                                  .goToProductPage(
                                                                      (data.data
                                                                              as Seller)
                                                                          .products![i]),
                                                              index: i,
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        return Container();
                                      });
                                return Container();
                              }),
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
                                      title: "BEST CREATORS AROUND YOU",
                                      subTitle: " "
                                      // title: controller.remoteConfig!
                                      //     .getString(HOMESCREEN_SECTION_3_TITLE_EN),
                                      // subTitle: controller.remoteConfig!
                                      //     .getString(HOMESCREEN_SECTION_3_SUBTITLE_EN),
                                      ),
                                ),
                              ],
                            ),
                          ),

                          if (appVar.dynamicSectionKeys.length > i &&
                              appVar.dynamicSectionKeys[i] != "67409233" &&
                              appVar.dynamicSectionKeys[i] != "77816306")
                            Column(
                              children: [
                                // SectionDivider(),
                                FutureBuilder(
                                    future: getProducts(
                                        appVar.dynamicSectionKeys[i++]),
                                    builder: (context, data) {
                                      if (data.connectionState ==
                                          ConnectionState.active) {
                                        return ShimmerWidget(
                                            type: LayoutType.PRODUCT_LAYOUT_2);
                                      }

                                      if (data.hasData)
                                        return Column(children: [
                                          SectionDivider(),
                                          Container(
                                            height: 260,
                                            width: double.infinity,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  bottom: 5,
                                                  left: -80,
                                                  child: Container(
                                                    // margin: EdgeInsets.symmetric(horizontal: 5),
                                                    // color: logoRed,
                                                    height: 240,
                                                    width: Get.width * 0.7,

                                                    child: Image.asset(
                                                      "assets/images/bg-1.jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 60,
                                                  right: -80,
                                                  child: Container(
                                                    // margin: EdgeInsets.symmetric(horizontal: 5),
                                                    // color: logoRed,
                                                    height: 200,
                                                    width: Get.width * 0.7,

                                                    child: Image.asset(
                                                      "assets/images/bg-1.jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 255,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            curve15),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 2)
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Editor's Pick",
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          letterSpacing: 0.4,
                                                          fontSize:
                                                              titleFontSizeStyle -
                                                                  2,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        "${(data.data as Promotion).name}",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          // color: Colors.black45,
                                                          color:
                                                              Colors.grey[800],

                                                          // letterSpacing: 0.4,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          BaseController
                                                              .goToProductListPage(
                                                                  ProductPageArg(
                                                            promotionKey: (data
                                                                        .data
                                                                    as Promotion)
                                                                .key,
                                                            subCategory:
                                                                'Designer',
                                                            queryString: "",
                                                            title: (data.data
                                                                    as Promotion)
                                                                .name,
                                                            sellerPhoto: "",
                                                          ));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "View All",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                // letterSpacing: 0.4,
                                                                fontSize:
                                                                    titleFontSizeStyle -
                                                                        2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            horizontalSpaceTiny,
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              size: 12,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  // alignment: Alignment.bottomCenter,
                                                  bottom: 40,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    child:
                                                        DynamicSectionBuilder2(
                                                      header: SectionHeader(
                                                        title: (data.data
                                                                as Promotion)
                                                            .name,
                                                        subTitle: "",
                                                        viewAll: () {
                                                          BaseController
                                                              .goToProductListPage(
                                                                  ProductPageArg(
                                                            promotionKey: (data
                                                                        .data
                                                                    as Promotion)
                                                                .key,
                                                            subCategory:
                                                                'Designer',
                                                            queryString: "",
                                                            title: (data.data
                                                                    as Promotion)
                                                                .name,
                                                            sellerPhoto: "",
                                                          ));
                                                        },
                                                      ),
                                                      products: (data.data
                                                                  as Promotion)
                                                              .products ??
                                                          [],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]);
                                      return Container();
                                    }),
                              ],
                            ),
                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION3']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       // SectionDivider(),
                          //       SectionBuilder(
                          //         key: widget.productUniqueKey ?? UniqueKey(),
                          //         context: context,
                          //         onEmptyList: () {},
                          //         layoutType: LayoutType.PRODUCT_LAYOUT_2,
                          //         filter: ProductFilter(
                          //           subCategories: [
                          //             '9'
                          //           ],
                          //         ),
                          //         controller: ProductsGridViewBuilderController(
                          //           randomize: true,
                          //           limit: 10,
                          //         ),
                          //         scrollDirection: Axis.horizontal,
                          //         header: SectionHeader(
                          //           title: "SHOP AMAZING HANDMADE BAGS",
                          //           // title: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_6_TITLE_EN),
                          //           subTitle: "",
                          //           viewAll: () {
                          //             BaseController.goToProductListPage(ProductPageArg(
                          //               queryString:
                          //               'category=9;',
                          //               subCategory: '',
                          //             ));
                          //           },
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          FutureSectionBuilder(
                            duration: sectionDelay['SECTION4']!,
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
                                    title: "SHOP CREATOR COLLECTION BELOW ₹999",
                                    subTitle: "",
                                    // title: controller.remoteConfig!
                                    //     .getString(HOMESCREEN_SECTION_1_TITLE_EN),
                                    // subTitle: controller.remoteConfig!
                                    //     .getString(HOMESCREEN_SECTION_1_SUBTITLE_EN),
                                    viewAll: () {
                                      BaseController.goToProductListPage(
                                          ProductPageArg(
                                        title:
                                            "SHOP CREATOR COLLECTION BELOW ₹999",
                                        queryString: 'maxPrice=750;',
                                        subCategory: '',
                                      ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION5']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         key: widget.sellerUniqueKey ?? UniqueKey(),
                          //         context: context,
                          //         layoutType: LayoutType.Creator_ID_3_LAYOUT,
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
                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION6']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         key: widget.productUniqueKey ?? UniqueKey(),
                          //         context: context,
                          //         layoutType: LayoutType.PRODUCT_LAYOUT_2,
                          //         onEmptyList: () {},
                          //         filter: ProductFilter(
                          //           subCategories: [
                          //             '1',
                          //           ],
                          //         ),
                          //         controller: ProductsGridViewBuilderController(
                          //           randomize: true,
                          //           limit: 10,
                          //         ),
                          //         scrollDirection: Axis.horizontal,
                          //         header: SectionHeader(
                          //           title: "Hello World",
                          //           subTitle: "Hello World",
                          //           // title: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_6_TITLE_EN),
                          //           // subTitle: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_6_SUBTITLE_EN),
                          //           viewAll: () {
                          //             BaseController.goToProductListPage(ProductPageArg(
                          //               queryString: 'category=1;',
                          //               subCategory: '',
                          //             ));
                          //           },
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          if (appVar.dynamicSectionKeys.length > i &&
                              appVar.dynamicSectionKeys[i] != "67409233" &&
                              appVar.dynamicSectionKeys[i] != "77816306")
                            FutureBuilder(
                                future:
                                    getProducts(appVar.dynamicSectionKeys[i++]),
                                builder: (context, data) {
                                  if (data.connectionState ==
                                      ConnectionState.active) {
                                    return ShimmerWidget(
                                        type: LayoutType.PRODUCT_LAYOUT_2);
                                  }

                                  if (data.hasData)
                                    return Column(children: [
                                      SectionDivider(),
                                      DynamicSectionBuilder3(
                                        header: SectionHeader(
                                          title: (data.data as Promotion).name,
                                          subTitle: "",
                                          viewAll: () {
                                            BaseController.goToProductListPage(
                                                ProductPageArg(
                                              title:
                                                  (data.data as Promotion).name,
                                              promotionKey:
                                                  (data.data as Promotion).key,
                                              subCategory: 'Designer',
                                              queryString: "",
                                              sellerPhoto: "",
                                            ));
                                          },
                                        ),
                                        products:
                                            (data.data as Promotion).products ??
                                                [],
                                      ),
                                    ]);
                                  return Container();
                                }),
                          if (appVar.dynamicSectionKeys.length > i &&
                              appVar.dynamicSectionKeys[i] != "67409233" &&
                              appVar.dynamicSectionKeys[i] != "77816306")
                            FutureBuilder(
                                future:
                                    getProducts(appVar.dynamicSectionKeys[i++]),
                                builder: (context, data) {
                                  if (data.connectionState ==
                                      ConnectionState.active) {
                                    return ShimmerWidget(
                                        type: LayoutType.PRODUCT_LAYOUT_2);
                                  }

                                  if (data.hasData)
                                    return Column(
                                      children: [
                                        SectionDivider(),
                                        DynamicSectionBuilder(
                                          header: SectionHeader(
                                            title:
                                                (data.data as Promotion).name,
                                            subTitle: "",
                                            viewAll: () {
                                              BaseController
                                                  .goToProductListPage(
                                                      ProductPageArg(
                                                title: (data.data as Promotion)
                                                    .name,
                                                promotionKey:
                                                    (data.data as Promotion)
                                                        .key,
                                                subCategory: 'Designer',
                                                queryString: "",
                                                sellerPhoto: "",
                                              ));
                                            },
                                          ),
                                          products: (data.data as Promotion)
                                                  .products ??
                                              [],
                                        ),
                                      ],
                                    );
                                  return Container();
                                }),
                          if (appVar.dynamicSectionKeys.length > i &&
                              appVar.dynamicSectionKeys[i] != "67409233" &&
                              appVar.dynamicSectionKeys[i] != "77816306")
                            FutureBuilder(
                                future:
                                    getProducts(appVar.dynamicSectionKeys[i++]),
                                builder: (context, data) {
                                  if (data.connectionState ==
                                      ConnectionState.active) {
                                    return ShimmerWidget(
                                        type: LayoutType.PRODUCT_LAYOUT_2);
                                  }

                                  if (data.hasData)
                                    return Column(
                                      children: [
                                        SectionDivider(),
                                        DynamicSectionBuilder(
                                          header: SectionHeader(
                                            title:
                                                (data.data as Promotion).name,
                                            subTitle: "",
                                            viewAll: () {
                                              BaseController
                                                  .goToProductListPage(
                                                      ProductPageArg(
                                                title: (data.data as Promotion)
                                                    .name,
                                                promotionKey:
                                                    (data.data as Promotion)
                                                        .key,
                                                subCategory: 'Designer',
                                                queryString: "",
                                                sellerPhoto: "",
                                              ));
                                            },
                                          ),
                                          products: (data.data as Promotion)
                                                  .products ??
                                              [],
                                        ),
                                      ],
                                    );
                                  return Container();
                                }),
                          if (appVar.dynamicSectionKeys.length > i &&
                              appVar.dynamicSectionKeys[i] != "67409233" &&
                              appVar.dynamicSectionKeys[i] != "77816306")
                            FutureBuilder(
                                future:
                                    getProducts(appVar.dynamicSectionKeys[i++]),
                                builder: (context, data) {
                                  if (data.connectionState ==
                                      ConnectionState.active) {
                                    return ShimmerWidget(
                                        type: LayoutType.PRODUCT_LAYOUT_2);
                                  }

                                  if (data.hasData)
                                    return Column(
                                      children: [
                                        SectionDivider(),
                                        DynamicSectionBuilder(
                                          header: SectionHeader(
                                            title:
                                                (data.data as Promotion).name,
                                            subTitle: "",
                                            viewAll: () {
                                              BaseController
                                                  .goToProductListPage(
                                                      ProductPageArg(
                                                title: (data.data as Promotion)
                                                    .name,
                                                promotionKey:
                                                    (data.data as Promotion)
                                                        .key,
                                                subCategory: 'Designer',
                                                queryString: "",
                                                sellerPhoto: "",
                                              ));
                                            },
                                          ),
                                          products: (data.data as Promotion)
                                                  .products ??
                                              [],
                                        ),
                                      ],
                                    );
                                  return Container();
                                }),
                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION7']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         context: context,
                          //         layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                          //         onEmptyList: () {},
                          //         controller: SellersGridViewBuilderController(
                          //           removeId: '',
                          //           subscriptionTypes: [2],
                          //           random: true,
                          //           limit: 12,
                          //         ),
                          //         scrollDirection: Axis.horizontal,
                          //         header: SectionHeader(
                          //           title: "GREAT LABELS IN YOUR CITY!",
                          //           subTitle: ""
                          //           // title: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_7_TITLE_EN),
                          //           // subTitle: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_7_SUBTITLE_EN),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION8']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         key: widget.productUniqueKey ?? UniqueKey(),
                          //         context: context,
                          //         layoutType: LayoutType.PRODUCT_LAYOUT_2,
                          //         onEmptyList: () {},
                          //         filter: ProductFilter(
                          //           subCategories: [
                          //             '1',
                          //             '2',
                          //             '3',
                          //             '4',
                          //             '5',
                          //             '6',
                          //             '7',
                          //             '8',
                          //             '12'
                          //           ],
                          //           maxPrice: 1500,
                          //         ),
                          //         controller: ProductsGridViewBuilderController(
                          //           randomize: true,
                          //           limit: 10,
                          //         ),
                          //         scrollDirection: Axis.horizontal,
                          //         header: SectionHeader(
                          //           title: "Hello World",
                          //           subTitle: "Hello World"
                          //           // title: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_8_TITLE_EN),
                          //           // subTitle: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_8_SUBTITLE_EN),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION9']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         context: context,
                          //         layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                          //         onEmptyList: () {},
                          //         controller: SellersGridViewBuilderController(
                          //           subscriptionTypes: [2],
                          //           withProducts: true,
                          //           random: true,
                          //           limit: 7,
                          //         ),
                          //         scrollDirection: Axis.horizontal,
                          //         header: SectionHeader(
                          //           title: "Hello World",
                          //           subTitle: "Hello World"
                          //           // title: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_9_TITLE_EN),
                          //           // subTitle: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_9_SUBTITLE_EN),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION10']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         key: widget.categoryUniqueKey,
                          //         context: context,
                          //         layoutType: LayoutType.CATEGORY_LAYOUT_3,
                          //         onEmptyList: () {},
                          //         controller: CategoriesGridViewBuilderController(),
                          //         scrollDirection: Axis.horizontal,
                          //         header: SectionHeader(
                          //           title: controller.remoteConfig!
                          //               .getString(HOMESCREEN_SECTION_10_TITLE_EN),
                          //           subTitle: controller.remoteConfig!
                          //               .getString(HOMESCREEN_SECTION_10_SUBTITLE_EN),
                          //           viewAll: () => BaseController.category(),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

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
                                    removeId: '',
                                    subscriptionTypes: [1, 2],
                                    withProducts: true,
                                    random: true,
                                    limit: 7,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  header: SectionHeader(
                                      title: "EXPLORE BOUTIQUES", subTitle: " "
                                      // title: controller.remoteConfig!
                                      //     .getString(HOMESCREEN_SECTION_11_TITLE_EN),
                                      // subTitle: controller.remoteConfig!
                                      //     .getString(HOMESCREEN_SECTION_11_SUBTITLE_EN),
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION12']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         context: context,
                          //         layoutType: LayoutType.DESIGNER_ID_1_2_LAYOUT,
                          //         onEmptyList: () {},
                          //         controller: SellersGridViewBuilderController(
                          //           subscriptionTypes: [1, 2],
                          //           withProducts: true,
                          //           random: true,
                          //           boutiquesOnly: true,
                          //           limit: 7,
                          //         ),
                          //         scrollDirection: Axis.horizontal,
                          //         header: SectionHeader(
                          //           title: "Hello World",
                          //           subTitle: "Hello World"
                          //           // title: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_12_TITLE_EN),
                          //           // subTitle: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_12_SUBTITLE_EN),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

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
                                    title: "Explore Creator collection",
                                    subTitle: "",
                                    // title: controller.remoteConfig!
                                    //     .getString(HOMESCREEN_SECTION_13_TITLE_EN),
                                    // subTitle: controller.remoteConfig!
                                    //     .getString(HOMESCREEN_SECTION_13_SUBTITLE_EN),
                                    viewAll: () {
                                      BaseController.goToProductListPage(
                                          ProductPageArg(
                                        title: "Explore Creator collection",
                                        queryString: '',
                                        subCategory: '',
                                      ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ! this is causing unusual ui bugs

                          // FutureSectionBuilder(
                          //   duration: sectionDelay['SECTION14']!,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SectionDivider(),
                          //       SectionBuilder(
                          //         key: widget.sellerUniqueKey ?? UniqueKey(),
                          //         context: context,
                          //         onEmptyList: () {},
                          //         layoutType: LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT,
                          //         fromHome: true,
                          //         scrollDirection: Axis.vertical,
                          //         controller:
                          //             SellersGridViewBuilderController(random: true),
                          //         header: SectionHeader(
                          //           title: "Discover Designers",
                          //           subTitle: ""
                          //           // title: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_14_TITLE_EN),
                          //           // subTitle: controller.remoteConfig!
                          //           //     .getString(HOMESCREEN_SECTION_14_SUBTITLE_EN),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: TextButton(
                                        onPressed: () {
                                          controller.showSellers();
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: logoRed,
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                      Image.asset(
                                        "assets/images/logo.png",
                                        // "assets/svg/dzor_logo.svg",
                                        color: Colors.grey[800],
                                        height: 35,
                                        width: 35,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                    ),
                  );
                // )
                // : CircularProgressIndicator();
                return Container();
              });
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

// ignore: must_be_immutable
class DynamicSectionBuilder extends StatelessWidget {
  final SectionHeader? header;
  List<num> products = [];
  DynamicSectionBuilder({Key? key, this.header, required this.products})
      : super(key: key);
  int i = 0;

  @override
  Widget build(BuildContext context) {
    products.shuffle();
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 2),
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          verticalSpaceTiny,
          if (header != null)
            HomeViewListHeader(
              title: header!.title!,
              subTitle: header?.subTitle ?? "",
              viewAll: header!.viewAll,
            ),
          verticalSpaceTiny,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FutureBuilder<Product>(
                    future: getProductFromKey(products[i++].toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var _product = snapshot.data;
                        return Container(
                          height: 270,
                          width: 200,
                          child: ProductTileUI(
                            data: _product!,
                            cardPadding: EdgeInsets.zero,
                            onClick: () =>
                                BaseController.goToProductPage(_product),
                            index: i,
                          ),
                        );
                      }
                      return Container();
                    }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(_product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
                if (i < products.length)
                  FutureBuilder<Product>(
                      future: getProductFromKey(products[i++].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var product = snapshot.data;
                          return Container(
                            height: 270,
                            width: 200,
                            child: ProductTileUI(
                              data: product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () =>
                                  BaseController.goToProductPage(product),
                              index: i,
                            ),
                          );
                        }
                        return Container();
                      }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
