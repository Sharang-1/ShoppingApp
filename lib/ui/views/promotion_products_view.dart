import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

import '../../constants/dynamic_links.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/whishlist_filter_model.dart';
import '../../models/products.dart';
import '../../services/dynamic_link_service.dart';
import '../../viewmodels/grid_view_builder_view_models/wishlist_grid_view_builder_view_model.dart';
import '../../viewmodels/whishlist_view_model.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/GridListWidget.dart';
import '../widgets/ProductTileUI.dart';

class PromotionProduct extends StatefulWidget {
  final String promotionId;
  final List<String> productIds;
  final String promotionTitle;
  PromotionProduct(
      {Key key,
      @required this.productIds,
      @required this.promotionTitle,
      @required this.promotionId})
      : super(key: key);

  @override
  _PromotionProductState createState() => _PromotionProductState();
}

class _PromotionProductState extends State<PromotionProduct> {
  WhishListFilter filter = WhishListFilter();
  Key promotionProductKey = UniqueKey();
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
    return ViewModelProvider<WhishListViewModel>.withConsumer(
      viewModel: WhishListViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundWhiteCreamColor,
          centerTitle: true,
          title: SvgPicture.asset(
            "assets/svg/logo.svg",
            color: logoRed,
            height: 35,
            width: 35,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        backgroundColor: backgroundWhiteCreamColor,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(
              waterDropColor: logoRed,
              refresh: Container(),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  verticalSpace(20),
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenPadding,
                            right: screenPadding - 5,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            widget.promotionTitle == null ||
                                    widget.promotionTitle == ""
                                ? "Products"
                                : widget.promotionTitle,
                            style: TextStyle(
                                fontFamily: headingFont,
                                fontWeight: FontWeight.w700,
                                fontSize: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () async {
                            await Share.share(
                              await _dynamicLinkService.createLink(
                                  promotionLink + widget.promotionId),
                              sharePositionOrigin: Rect.fromCenter(
                                center: Offset(100, 100),
                                width: 100,
                                height: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/share_icon.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(20),
                  FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 500)),
                    builder: (c, s) => s.connectionState == ConnectionState.done
                        ? GridListWidget<Products, Product>(
                            key: promotionProductKey,
                            context: context,
                            filter: filter,
                            gridCount: 2,
                            disablePagination: true,
                            viewModel: WhishListGridViewBuilderViewModel(
                                productIds: widget.productIds),
                            childAspectRatio: 0.8,
                            emptyListWidget: EmptyListWidget(
                              text: "",
                            ),
                            tileBuilder: (BuildContext context, data, index,
                                onDelete, onUpdate) {
                              final Product dProduct = data as Product;
                              return ProductTileUI(
                                index: index,
                                data: data,
                                onClick: () {
                                  model
                                      .goToProductPage(dProduct)
                                      .then((value) => setState(() {
                                            promotionProductKey = UniqueKey();
                                          }));
                                },
                              );
                            },
                          )
                        : Container(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
