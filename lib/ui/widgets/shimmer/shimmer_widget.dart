import 'package:compound/ui/widgets/shimmer/designer_shimmer.dart';
import 'package:compound/ui/widgets/shimmer/explore_product_shimmer.dart';
import 'package:compound/ui/widgets/shimmer/my_orders_shimmer.dart';
import 'package:compound/ui/widgets/shimmer/view_cart_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/app_colors.dart';
import '../section_builder.dart';
import 'product_shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final LayoutType? type;
  final Axis scrollDirection;
  final double childAspectRatio;
  final int gridCount;
  final Widget defaultShimmerWidget = Shimmer.fromColors(
    child: Container(
      width: 2000,
      height: 2000,
      color: Colors.white,
    ),
    baseColor: shimmerBaseColor,
    highlightColor: shimmerHighlightColor,
  );

  ShimmerWidget({
    Key? key,
    this.type,
    this.scrollDirection = Axis.horizontal,
    this.childAspectRatio = 1.0,
    this.gridCount = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      type == null ? defaultShimmerWidget : getShimmerWidget();

  Widget getShimmerWidget() {
    return GridView.count(
      crossAxisCount: gridCount,
      scrollDirection: scrollDirection,
      childAspectRatio: childAspectRatio,
      children: getChildren(),
    );
  }

  List<Widget> getChildren() {
    switch (type) {
      case LayoutType.PRODUCT_LAYOUT_1:
      case LayoutType.PRODUCT_LAYOUT_2:
        return List.generate(8, (index) => ProductShimmer());
      case LayoutType.PRODUCT_LAYOUT_3:
        return List.generate(8, (index) => ExploreProductShimmer());
      case LayoutType.DESIGNER_ID_1_2_LAYOUT:
        return List.generate(3, (index) => DesignerShimmer());
      case LayoutType.VIEW_CART_LAYOUT:
        return List.generate(1, (index) => ViewCartShimmer());
      case LayoutType.MY_ORDERS_LAYOUT:
        return List.generate(4, (index) => MyOrdersShimmer());
      case LayoutType.DESIGNER_ID_3_LAYOUT:
        return List.generate(
            8,
            (index) => DesignerShimmer(
                  isID3: true,
                ));
      default:
        return [defaultShimmerWidget];
    }
  }
}
