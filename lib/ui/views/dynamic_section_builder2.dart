import 'package:compound/ui/widgets/product_tile_ui_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/products.dart';
import '../shared/ui_helpers.dart';
import '../widgets/section_builder.dart';

// ignore: must_be_immutable
class DynamicSectionBuilder2 extends StatelessWidget {
  final SectionHeader? header;
  List<num> products = [];
  DynamicSectionBuilder2({Key? key, this.header, required this.products}) : super(key: key);
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
          // if (header != null)
          //   HomeViewListHeader(
          //     title: header!.title!,
          //     subTitle: header?.subTitle ?? "",
          //     viewAll: header!.viewAll,
          //   ),
          // verticalSpaceTiny,
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
                          height: 150,
                          width: 200,
                          child: ProductTileUI2(
                            data: _product!,
                            cardPadding: EdgeInsets.zero,
                            onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: _product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(_product),
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
                            height: 150,
                            width: 200,
                            child: ProductTileUI2(
                              data: product!,
                              cardPadding: EdgeInsets.zero,
                              onClick: () => BaseController.goToProductPage(product),
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
