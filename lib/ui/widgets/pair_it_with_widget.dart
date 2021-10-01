import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/products.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import 'grid_list_widget.dart';
import 'product_tile_ui.dart';

class PairItWithWidget extends StatelessWidget {
  final Key productUniqueKey;
  final num deliveryCharges = 35.40;
  final List<String> exceptProductIDs;
  final Function(Product product) onProductClicked;
  final Function onEmpty;
  const PairItWithWidget({
    this.productUniqueKey,
    this.onProductClicked,
    this.exceptProductIDs = const [],
    this.onEmpty,
  });

  @override
  Widget build(BuildContext context) => Container(
        color: newBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    PAIR_IT_WITH.tr,
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: titleFontSizeStyle + 2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: GridListWidget<Products, Product>(
                key: productUniqueKey ?? UniqueKey(),
                context: context,
                filter: ProductFilter(
                  subCategories: ['11', '9', '10'],
                ),
                gridCount: 2,
                controller: ProductsGridViewBuilderController(
                    randomize: true,
                    limit: 20,
                    exceptProductIDs: exceptProductIDs),
                onEmptyList: onEmpty,
                childAspectRatio: 1.20,
                scrollDirection: Axis.horizontal,
                emptyListWidget: Container(),
                disablePagination: true,
                tileBuilder: (BuildContext context, productData, index,
                    onUpdate, onDelete) {
                  var product = productData as Product;
                  return GestureDetector(
                    onTap: () => onProductClicked(product),
                    child: ProductTileUI(
                      data: product,
                      onClick: () => onProductClicked(product),
                      onAddToCartClicked: () => onProductClicked(product),
                      index: index,
                      cardPadding: EdgeInsets.all(2.0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
