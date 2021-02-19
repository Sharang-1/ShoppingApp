import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/products.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/ProductTileUI.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'package:compound/viewmodels/productListViewModel.dart';
// import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductListView extends StatefulWidget {
  final String queryString;
  final String subCategory;

  ProductListView({
    Key key,
    @required this.queryString,
    @required this.subCategory,
  }) : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  ProductFilter filter;
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    filter = ProductFilter(existingQueryString: widget.queryString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProductListViewModel>.withConsumer(
      viewModel: ProductListViewModel(),
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
          top: false,
          left: false,
          right: false,
          bottom: false,
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(
              waterDropColor: Colors.blue,
              refresh: Container(),
              complete: Container(),
            ),
            controller: refreshController,
            onRefresh: () async {
              setState(() {
                key = new UniqueKey();
              });
              refreshController.refreshCompleted(resetFooterState: true);
            },
            child: Column(
              children: [
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
                          widget.subCategory,
                          style: TextStyle(
                              fontFamily: headingFont,
                              fontWeight: FontWeight.w700,
                              fontSize: 30),
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
                          key: key,
                          context: context,
                          filter: filter,
                          gridCount: 2,
                          emptyListWidget: EmptyListWidget(text: ""),
                          viewModel: ProductsGridViewBuilderViewModel(),
                          childAspectRatio: 0.7,
                          tileBuilder: (BuildContext context, data, index, onUpdate,
                              onDelete) {
                            return ProductTileUI(
                              data: data,
                              onClick: () => model.goToProductPage(data),
                              index: index,
                            );
                          },
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
