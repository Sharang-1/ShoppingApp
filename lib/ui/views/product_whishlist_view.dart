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

class WhishList extends StatefulWidget {
  WhishList({Key key}) : super(key: key);

  @override
  _WhishListState createState() => _WhishListState();
}

class _WhishListState extends State<WhishList> {
  WhishListFilter filter = WhishListFilter();
  Key whishListKey = UniqueKey();

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    whishListKey = UniqueKey();
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
            child: Padding(
              padding: EdgeInsets.only(
                left: screenPadding,
                right: screenPadding,
                top: 10,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  verticalSpace(20),
                  Text(
                    "Whishlist",
                    style: TextStyle(
                        fontFamily: headingFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 30),
                  ),
                  verticalSpace(20),
                  GridListWidget<Products, Product>(
                    key: whishListKey,
                    context: context,
                    filter: filter,
                    gridCount: 2,
                    disablePagination: true,
                    viewModel: WhishListGridViewBuilderViewModel(),
                    childAspectRatio: 0.7,
                    tileBuilder: (BuildContext context, data, index, onDelete,
                        onUpdate) {
                      final Product dProduct = data as Product;
                      return ProductTileUI(
                        index: index,
                        data: data,
                        onClick: () {
                          model.goToProductPage(dProduct).then((value) => setState(() {
                            whishListKey = UniqueKey();
                          }));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
