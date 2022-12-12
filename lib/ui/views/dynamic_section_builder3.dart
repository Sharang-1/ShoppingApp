import 'package:compound/ui/widgets/product_tile_ui_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/products.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/section_builder.dart';

// ignore: must_be_immutable
class DynamicSectionBuilder3 extends StatelessWidget {
  final SectionHeader? header;
  List<num> products = [];
  DynamicSectionBuilder3({Key? key, this.header, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = 0;
    products.shuffle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              header!.title!,
              style: TextStyle(
                // color: Colors.black45,
                color: Colors.grey[800],

                // letterSpacing: 0.4,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        verticalSpaceTiny,
        Container(
          // height: 280,
          // alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              // gridDelegate: SliverGridDelegate(),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FutureBuilder<Product>(
                          future: getProductFromKey(products[i++].toString()),
                          builder: (context, snapshot) {
                            // print("products here ${products}");
                            if (snapshot.hasData) {
                              var _product = snapshot.data;
                              return Container(
                                height: Get.width * 0.32,
                                width: Get.width * 0.49,
                                child: ProductTileUI2(
                                  data: _product!,
                                  cardPadding: EdgeInsets.zero,
                                  onClick: () => BaseController.goToProductPage(_product),
                                  index: i,
                                ),
                              );
                            }
                            // return Container();
                            return SizedBox.shrink();
                            // return Container(color: Colors.red, width: 50, height: 50);
                          }),
                      if (i < products.length)
                        FutureBuilder<Product>(
                            future: getProductFromKey(products[i++].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var _product = snapshot.data;
                                return Container(
                                  height: Get.width * 0.32,
                                  width: Get.width * 0.49,
                                  child: ProductTileUI2(
                                    data: _product!,
                                    cardPadding: EdgeInsets.zero,
                                    onClick: () => BaseController.goToProductPage(_product),
                                    index: i,
                                  ),
                                );
                              }
                              // return Container();
                              // return Container(color: Colors.red, width: 50, height: 50);
                              return SizedBox.shrink();
                            }),
                      if (i < products.length)
                        FutureBuilder<Product>(
                            future: getProductFromKey(products[i++].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var _product = snapshot.data;
                                return Container(
                                  height: Get.width * 0.32,
                                  width: Get.width * 0.49,
                                  child: ProductTileUI2(
                                    data: _product!,
                                    cardPadding: EdgeInsets.zero,
                                    onClick: () => BaseController.goToProductPage(_product),
                                    index: i,
                                  ),
                                );
                              }
                              // return Container();
                              // return Container(color: Colors.red, width: 50, height: 50);
                              return SizedBox.shrink();
                            }),
                      if (i < products.length)
                        FutureBuilder<Product>(
                            future: getProductFromKey(products[i++].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var _product = snapshot.data;
                                return Container(
                                  height: Get.width * 0.32,
                                  width: Get.width * 0.49,
                                  child: ProductTileUI2(
                                    data: _product!,
                                    cardPadding: EdgeInsets.zero,
                                    onClick: () => BaseController.goToProductPage(_product),
                                    index: i,
                                  ),
                                );
                              }
                              // return Container(color: Colors.red, width: 50, height: 50);
                              return SizedBox.shrink();
                            }),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FutureBuilder<Product>(
                          future: getProductFromKey(products[i++].toString()),
                          builder: (context, snapshot) {
                            // print("products here ${products}");
                            if (snapshot.hasData) {
                              var _product = snapshot.data;
                              return Container(
                                height: Get.width * 0.32,
                                width: Get.width * 0.49,
                                child: ProductTileUI2(
                                  data: _product!,
                                  cardPadding: EdgeInsets.zero,
                                  onClick: () => BaseController.goToProductPage(_product),
                                  index: i,
                                ),
                              );
                            }
                            // return Container();
                            return SizedBox.shrink();
                            // return Container(color: Colors.red, width: 50, height: 50);
                          }),
                      if (i < products.length)
                        FutureBuilder<Product>(
                            future: getProductFromKey(products[i++].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var _product = snapshot.data;
                                return Container(
                                  height: Get.width * 0.32,
                                  width: Get.width * 0.49,
                                  child: ProductTileUI2(
                                    data: _product!,
                                    cardPadding: EdgeInsets.zero,
                                    onClick: () => BaseController.goToProductPage(_product),
                                    index: i,
                                  ),
                                );
                              }
                              // return Container();
                              // return Container(color: Colors.red, width: 50, height: 50);
                              return SizedBox.shrink();
                            }),
                      if (i < products.length)
                        FutureBuilder<Product>(
                            future: getProductFromKey(products[i++].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var _product = snapshot.data;
                                return Container(
                                  height: Get.width * 0.32,
                                  width: Get.width * 0.49,
                                  child: ProductTileUI2(
                                    data: _product!,
                                    cardPadding: EdgeInsets.zero,
                                    onClick: () => BaseController.goToProductPage(_product),
                                    index: i,
                                  ),
                                );
                              }
                              // return Container();
                              // return Container(color: Colors.red, width: 50, height: 50);
                              return SizedBox.shrink();
                            }),
                      if (i < products.length)
                        FutureBuilder<Product>(
                            future: getProductFromKey(products[i++].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var _product = snapshot.data;
                                return Container(
                                  height: Get.width * 0.32,
                                  width: Get.width * 0.49,
                                  child: ProductTileUI2(
                                    data: _product!,
                                    cardPadding: EdgeInsets.zero,
                                    onClick: () => BaseController.goToProductPage(_product),
                                    index: i,
                                  ),
                                );
                              }
                              // return Container(color: Colors.red, width: 50, height: 50);
                              return SizedBox.shrink();
                            }),
                    ],
                  ),
                )
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var _product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: Get.width*0.49,
                //             child: ProductTileUI2(
                //               data: _product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(_product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         // return Container();
                //       return SizedBox.shrink();

                //       }),
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var _product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: 200,
                //             child: ProductTileUI2(
                //               data: _product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(_product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         // return Container();
                //       return SizedBox.shrink();

                //       }),
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var _product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: 200,
                //             child: ProductTileUI2(
                //               data: _product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(_product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         return Container();
                //       }),
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var _product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: 200,
                //             child: ProductTileUI2(
                //               data: _product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(_product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         return Container();
                //       }),
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var _product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: 200,
                //             child: ProductTileUI2(
                //               data: _product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(_product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         return Container();
                //       }),
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var _product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: 200,
                //             child: ProductTileUI2(
                //               data: _product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(_product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         return Container();
                //       }),
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var _product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: 200,
                //             child: ProductTileUI2(
                //               data: _product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(_product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         return Container();
                //       }),
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var _product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: 200,
                //             child: ProductTileUI2(
                //               data: _product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(_product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         return Container();
                //       }),
                // if (i < products.length)
                //   FutureBuilder<Product>(
                //       future: getProductFromKey(products[i++].toString()),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           var product = snapshot.data;
                //           return Container(
                //             height: 150,
                //             width: 200,
                //             child: ProductTileUI2(
                //               data: product!,
                //               cardPadding: EdgeInsets.zero,
                //               onClick: () => BaseController.goToProductPage(product),
                //               index: i,
                //             ),
                //           );
                //         }
                //         return Container();
                //       }),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            header!.viewAll!();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  "View All",
                  style: TextStyle(
                    color: Colors.black,
                    // letterSpacing: 0.4,
                    fontSize: titleFontSizeStyle - 2,
                    fontWeight: FontWeight.w600,
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
        ),
      ],
    );
  }
}
