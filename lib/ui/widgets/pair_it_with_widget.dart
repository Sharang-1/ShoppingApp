import 'package:flutter/material.dart';

import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/products.dart';
import '../../viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import '../shared/app_colors.dart';
import 'GridListWidget.dart';
import 'ProductTileUI.dart';

class PairItWithWidget extends StatelessWidget {
  final Key productUniqueKey;
  final num deliveryCharges = 35.40;
  final List<String> exceptProductIDs;
  final Function(Product product) onProductClicked;
  const PairItWithWidget(
      {this.productUniqueKey,
      this.onProductClicked,
      this.exceptProductIDs = const []});

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundWhiteCreamColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Pair It With",
                    style: TextStyle(
                        fontSize: 12,
                        color: logoRed,
                        fontWeight: FontWeight.bold),
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
                viewModel: ProductsGridViewBuilderViewModel(
                    randomize: true, limit: 20, exceptProductIDs: exceptProductIDs),
                childAspectRatio: 1.10,
                scrollDirection: Axis.horizontal,
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
                // ),
                // ),
              ),
            ),
          ],
        ),
      );
}
