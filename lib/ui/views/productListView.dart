// import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

import '../../constants/dynamic_links.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/products.dart';
import '../../services/dynamic_link_service.dart';
import '../../viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import '../../viewmodels/productListViewModel.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/GridListWidget.dart';
import '../widgets/ProductFilterDialog.dart';
import '../widgets/ProductTileUI.dart';

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
  String sellerKey;
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  @override
  void initState() {
    filter = ProductFilter(existingQueryString: widget.queryString);
    sellerKey = widget?.queryString?.split('=')?.last?.replaceAll(';', '');
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
          actions: [
            if (widget.queryString.isEmpty && widget.subCategory.isEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(FontAwesomeIcons.slidersH,
                        color: Colors.black, size: 20),
                    onPressed: () async {
                      ProductFilter filterDialogResponse =
                          await showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        isScrollControlled: true,
                        clipBehavior: Clip.antiAlias,
                        context: context,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                              heightFactor: 0.75,
                              child: ProductFilterDialog(
                                oldFilter: filter,
                              ));
                        },
                      );

                      if (filterDialogResponse != null) {
                        setState(() {
                          filter = filterDialogResponse;
                          key = UniqueKey();
                        });
                      }
                    },
                  ),
                ),
              )
          ],
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
              waterDropColor: logoRed,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.queryString.isNotEmpty ||
                      widget.subCategory.isNotEmpty)
                    verticalSpace(20),
                  if (widget.queryString.isNotEmpty ||
                      widget.subCategory.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Row(
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
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                    fontFamily: headingFont,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                await Share.share(
                                  await _dynamicLinkService
                                      .createLink(sellerLink + sellerKey),
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
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              iconSize: 50,
                              icon: Icon(FontAwesomeIcons.slidersH,
                                  color: Colors.black, size: 20),
                              onPressed: () async {
                                ProductFilter filterDialogResponse =
                                    await showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  ),
                                  isScrollControlled: true,
                                  clipBehavior: Clip.antiAlias,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                        heightFactor: 0.75,
                                        child: ProductFilterDialog(
                                          oldFilter: filter,
                                        ));
                                  },
                                );

                                if (filterDialogResponse != null) {
                                  setState(() {
                                    filter = filterDialogResponse;
                                    key = UniqueKey();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
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
                            viewModel: ProductsGridViewBuilderViewModel(
                                limit: (widget.queryString.isEmpty &&
                                        widget.subCategory.isEmpty)
                                    ? 50
                                    : 10),
                            childAspectRatio: 0.7,
                            tileBuilder: (BuildContext context, data, index,
                                onUpdate, onDelete) {
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
      ),
    );
  }
}
