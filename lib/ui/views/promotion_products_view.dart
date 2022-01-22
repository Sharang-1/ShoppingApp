import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

import '../../constants/dynamic_links.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/wishlist_grid_view_builder_controller.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/products.dart';
import '../../services/dynamic_link_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/grid_list_widget.dart';
import '../widgets/product_tile_ui.dart';

class PromotionProduct extends StatefulWidget {
  final String promotionId;
  final List<String> productIds;
  final List<int> demographicIds;
  final String? promotionTitle;
  PromotionProduct({
    Key? key,
    required this.productIds,
    this.promotionTitle,
    required this.promotionId,
    required this.demographicIds,
  }) : super(key: key);

  @override
  _PromotionProductState createState() => _PromotionProductState();
}

class _PromotionProductState extends State<PromotionProduct> {
  Key? promotionProductKey = UniqueKey();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    promotionProductKey = UniqueKey();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.promotionTitle == null || widget.promotionTitle == ""
              ? "Products"
              : widget.promotionTitle!,
          style: TextStyle(
            fontFamily: headingFont,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Share.share(
                await _dynamicLinkService
                        .createLink(promotionLink + widget.promotionId) ??
                    "",
                sharePositionOrigin: Rect.fromCenter(
                  center: Offset(100, 100),
                  width: 100,
                  height: 100,
                ),
              );
            },
            icon: Icon(
              Platform.isIOS ? CupertinoIcons.share : Icons.share,
              size: 25,
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: false,
        child: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(
            waterDropColor: logoRed,
            refresh: Center(
              child: Center(
                child: Image.asset(
                  "assets/images/loading_img.gif",
                  height: 25,
                  width: 25,
                ),
              ),
            ),
            complete: Container(),
          ),
          controller: refreshController,
          onRefresh: () async {
            setState(() {
              promotionProductKey = new UniqueKey();
            });
            refreshController.refreshCompleted(resetFooterState: true);
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                verticalSpace(20),
                GridListWidget<Products, Product>(
                  onEmptyList: () {},
                  key: promotionProductKey,
                  context: context,
                  filter: ProductFilter(demographicIds: widget.demographicIds),
                  gridCount: 2,
                  disablePagination: true,
                  controller: (widget.demographicIds.length) == 0
                      ? WishListGridViewBuilderController(
                          productIds: widget.productIds)
                      : ProductsGridViewBuilderController(),
                  childAspectRatio: 0.7,
                  emptyListWidget: EmptyListWidget(
                    text: "",
                  ),
                  tileBuilder: (
                    BuildContext context,
                    data,
                    index,
                    onDelete,
                  ) {
                    final Product dProduct = data as Product;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),
                      ),
                      child: ProductTileUI(
                        index: index,
                        data: data,
                        cardPadding: EdgeInsets.zero,
                        onClick: () {
                          BaseController.goToProductPage(dProduct).then(
                            (value) => setState(
                              () {
                                promotionProductKey = UniqueKey();
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
