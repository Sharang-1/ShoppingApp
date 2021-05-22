import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/wishlist_grid_view_builder_controller.dart';
import '../../models/grid_view_builder_filter_models/wishlist_filter_model.dart';
import '../../models/products.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/GridListWidget.dart';
import '../widgets/ProductTileUI.dart';

class WishList extends StatefulWidget {
  WishList({Key key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  WishListFilter filter = WishListFilter();
  Key wishListKey = UniqueKey();

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    wishListKey = UniqueKey();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BaseController(),
      builder: (controller) => Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                verticalSpace(20),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenPadding,
                    right: screenPadding,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Text(
                    "Wishlist",
                    style: TextStyle(
                        fontFamily: headingFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 30),
                  ),
                ),
                verticalSpace(20),
                FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 500)),
                  builder: (c, s) => s.connectionState == ConnectionState.done
                      ? GridListWidget<Products, Product>(
                          key: wishListKey,
                          context: context,
                          filter: filter,
                          gridCount: 2,
                          disablePagination: true,
                          controller: WishListGridViewBuilderController(),
                          childAspectRatio: 0.8,
                          tileBuilder: (BuildContext context, data, index,
                              onDelete, onUpdate) {
                            final Product dProduct = data as Product;
                            return ProductTileUI(
                              index: index,
                              data: data,
                              onClick: () {
                                BaseController.goToProductPage(dProduct)
                                    .then((value) => setState(() {
                                          wishListKey = UniqueKey();
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