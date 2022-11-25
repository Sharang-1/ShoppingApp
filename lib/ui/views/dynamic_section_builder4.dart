import 'package:compound/ui/widgets/product_tile_ui_2.dart';
import 'package:compound/ui/widgets/product_tile_ui_4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/products.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/home_view_list_header.dart';
import '../widgets/product_tile_ui.dart';
import '../widgets/section_builder.dart';

// ignore: must_be_immutable
class DynamicSectionBuilder4 extends StatelessWidget {
  final SectionHeader? header;
  List<num> products = [];
  DynamicSectionBuilder4({Key? key, this.header, required this.products}) : super(key: key);
  int i = 0;

  @override
  Widget build(BuildContext context) {
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
        FutureBuilder<Product>(
            future: getProductFromKey(products[i++].toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var _product = snapshot.data;
                return Container(
                  height: 150,
                  width: 200,
                  child: ProductTileUI4(
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
        GestureDetector(
          onTap: () => header!.viewAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "View All  ->",
              style: TextStyle(
                color: Colors.black,
                // letterSpacing: 0.4,
                fontSize: titleFontSizeStyle - 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
