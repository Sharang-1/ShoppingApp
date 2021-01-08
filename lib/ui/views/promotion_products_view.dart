import 'package:compound/models/grid_view_builder_filter_models/whishlist_filter_model.dart';
import 'package:compound/models/products.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';

import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/ProductTileUI.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/wishlist_grid_view_builder_view_model.dart';
import 'package:compound/viewmodels/whishlist_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../shared/shared_styles.dart';

import 'package:compound/locator.dart';
import 'package:share/share.dart';
import 'package:compound/constants/dynamic_links.dart';
import 'package:compound/services/dynamic_link_service.dart';

class PromotionProduct extends StatefulWidget {
  final String promotionId;
  final List<String> productIds;
  final String promotionTitle;
  PromotionProduct(
      {Key key, @required this.productIds, @required this.promotionTitle, @required this.promotionId})
      : super(key: key);

  @override
  _PromotionProductState createState() => _PromotionProductState();
}

class _PromotionProductState extends State<PromotionProduct> {
  WhishListFilter filter = WhishListFilter();
  Key promotionProductKey = UniqueKey();

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
                          await Share.share(await _dynamicLinkService.createLink(promotionLink + widget.promotionId));
                        },
                        child: Image.asset(
                          'assets/images/share_icon.png',
                          width: 30,
                          height: 30,
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
    );
  }
}
