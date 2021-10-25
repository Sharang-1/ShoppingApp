import 'package:compound/controllers/cart_count_controller.dart';
import 'package:compound/controllers/grid_view_builder/cart_grid_view_builder_controller.dart';
import 'package:compound/models/cart.dart' show Cart, Item;
import 'package:compound/models/grid_view_builder_filter_models/cartFilter.dart';
import 'package:compound/ui/widgets/cart_tile.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/base_grid_view_builder_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../models/categorys.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../models/grid_view_builder_filter_models/categoryFilter.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/grid_view_builder_filter_models/sellerFilter.dart';
import '../../models/productPageArg.dart';
import '../../models/products.dart';
import '../../models/sellers.dart';
import '../../services/analytics_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import 'categoryTileUI.dart';
import 'explore_designer_tile.dart';
import 'explore_product_tile.dart';
import 'grid_list_widget.dart';
import 'home_view_list_header.dart';
import 'product_tile_ui.dart';
import 'sellerTileUi.dart';
import 'shimmer/shimmer_widget.dart';
import 'top_picks_deals_card.dart';

enum LayoutType {
  //Promotion Layouts
  PROMOTION_LAYOUT_1,

  //Product Layouts
  PRODUCT_LAYOUT_1,
  PRODUCT_LAYOUT_2,
  PRODUCT_LAYOUT_3, // Explore Dzor Product Layout

  //Category Layouts
  CATEGORY_LAYOUT_1,
  CATEGORY_LAYOUT_2,
  CATEGORY_LAYOUT_3,
  CATEGORY_LAYOUT_4,

  //Designer Layouts
  DESIGNER_LAYOUT_1,
  DESIGNER_LAYOUT_2,
  DESIGNER_ID_1_2_LAYOUT,
  DESIGNER_ID_3_LAYOUT,
  DESIGNER_ID_3_VERTICAL_LAYOUT,

  //Explore
  EXPLORE_DESIGNER_LAYOUT,

  //Cart Layout
  VIEW_CART_LAYOUT,

  //My Orders Layout
  MY_ORDERS_LAYOUT,
}

// ignore: must_be_immutable
class SectionBuilder extends StatelessWidget {
  final SectionHeader header;
  final LayoutType layoutType;
  Key key;
  BuildContext context;
  BaseFilterModel filter;
  BaseGridViewBuilderController controller;
  int gridCount;
  Widget spacer;
  double height;
  bool toProduct;
  bool fromHome;
  bool withScrollBar;
  Axis scrollDirection;
  Function onEmptyList;
  Widget Function(BuildContext, dynamic, int, Future<bool> Function(int),
      Future<bool> Function(int, dynamic)) tileBuilder;
  bool isSmallDevice = Get.size.width < 375;
  String productId;
  List<String> exceptProductIDs = [];

  SectionBuilder({
    @required this.context,
    @required this.layoutType,
    @required this.controller,
    this.header,
    this.gridCount = 1,
    this.filter,
    key,
    this.spacer = verticalSpaceSmall,
    this.height,
    this.scrollDirection = Axis.vertical,
    this.toProduct = false,
    this.fromHome = false,
    this.withScrollBar = true,
    this.onEmptyList,
    this.tileBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (header != null && (header?.title?.isNotEmpty ?? false))
            HomeViewListHeader(
              title: header.title,
              subTitle: header.subTitle,
              viewAll: header.viewAll,
            ),
          if (header != null && (header?.title?.isNotEmpty ?? false)) spacer,
          SizedBox(
            height: getSize(layoutType),
            child: withScrollBar
                ? Theme(
                    data: ThemeData(
                      scrollbarTheme: ScrollbarThemeData().copyWith(
                        thumbColor: MaterialStateProperty.all(logoRed),
                        trackColor: MaterialStateProperty.all(Colors.black),
                        trackBorderColor:
                            MaterialStateProperty.all(Colors.grey[500]),
                        isAlwaysShown: true,
                        showTrackOnHover: true,
                      ),
                    ),
                    child: Scrollbar(
                      controller: ScrollController(),
                      child: getGridListWidget(
                        layoutType,
                        isSmallDevice: isSmallDevice,
                      ),
                    ),
                  )
                : getGridListWidget(layoutType, isSmallDevice: isSmallDevice),
          ),
        ],
      );

  Widget getGridListWidget(LayoutType type, {bool isSmallDevice = false}) {
    switch (type) {
      case LayoutType.PRODUCT_LAYOUT_1:
        return GridListWidget<Products, Product>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? ProductFilter(),
          gridCount: gridCount,
          controller: controller,
          childAspectRatio:
              getChildAspectRatio(layoutType, isSmallDevice: isSmallDevice),
          emptyListWidget: Container(),
          scrollDirection: scrollDirection,
          disablePagination: true,
          onEmptyList: onEmptyList,
          loadingWidget: ShimmerWidget(type: type),
          tileBuilder:
              (BuildContext context, productData, index, onUpdate, onDelete) {
            var product = productData as Product;
            return InkWell(
              onTap: () => BaseController.goToProductPage(productData),
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Container(
                  child: TopPicksAndDealsCard(
                    data: {
                      "key": product?.key ?? "Test",
                      "name": product?.name ?? "Test",
                      "actualCost": (product.cost.cost +
                              product.cost.convenienceCharges.cost +
                              product.cost.gstCharges.cost)
                          .round(),
                      "price": product?.cost?.costToCustomer?.round() ?? 0,
                      "discount": product?.cost?.productDiscount?.rate ?? 0,
                      "photo": product?.photo?.photos?.first?.name,
                      "sellerName": product?.seller?.name ?? "",
                      "isDiscountAvailable":
                          product?.discount != null && product.discount != 0
                              ? "true"
                              : null,
                    },
                  ),
                ),
              ),
            );
          },
        );

      case LayoutType.PRODUCT_LAYOUT_2:
        return GridListWidget<Products, Product>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? ProductFilter(),
          gridCount: gridCount,
          controller: controller,
          childAspectRatio: getChildAspectRatio(layoutType),
          emptyListWidget: Container(),
          scrollDirection: scrollDirection,
          disablePagination: true,
          onEmptyList: onEmptyList,
          loadingWidget: ShimmerWidget(
            type: type,
            scrollDirection: scrollDirection,
            childAspectRatio: getChildAspectRatio(layoutType),
          ),
          tileBuilder:
              (BuildContext context, productData, index, onUpdate, onDelete) {
            return Container(
              child: ProductTileUI(
                data: productData,
                onClick: () => NavigationService.to(
                  ProductIndividualRoute,
                  arguments: productData,
                ),
                index: index,
                cardPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
              ),
            );
          },
        );

      case LayoutType.VIEW_CART_LAYOUT:
        return GridListWidget<Cart, Item>(
            context: context,
            filter: CartFilter(),
            gridCount: gridCount,
            disablePagination: true,
            controller: controller,
            childAspectRatio: getChildAspectRatio(layoutType),
            loadingWidget: ShimmerWidget(
              type: type,
              scrollDirection: scrollDirection,
              childAspectRatio: getChildAspectRatio(layoutType),
            ),
            tileBuilder: tileBuilder
            //  (BuildContext context, data, index, onDelete, onUpdate) {
            //   Fimber.d("test");
            //   print((data as Item).toJson());
            //   final Item dItem = data as Item;
            //   exceptProductIDs.add(dItem.product.key);

            //   return CartTile(
            //     index: index,
            //     item: dItem,
            //     onDelete: (int index) async {
            //       final value = await onDelete(index);
            //       print("Delete product index: $index");
            //       if (!value) return;
            //       await controller
            //           .removeFromCartLocalStore(dItem.productId.toString());
            //       locator<CartCountController>().decrementCartCount();
            //       // try {
            //       //   await controller.removeProductFromCartEvent(dItem?.product);
            //       // } catch (e) {}
            //     },
            //   );
            // },
            );

      case LayoutType.PRODUCT_LAYOUT_3:
        return GridListWidget<Products, Product>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? ProductFilter(explore: true),
          gridCount: gridCount,
          controller: controller,
          childAspectRatio: getChildAspectRatio(layoutType),
          emptyListWidget: Container(),
          scrollDirection: scrollDirection,
          disablePagination: true,
          onEmptyList: onEmptyList,
          tileBuilder:
              (BuildContext context, productData, index, onUpdate, onDelete) {
            return ExploreProductTileUI(
              data: productData,
              onClick: () async {
                try {
                  await locator<AnalyticsService>().sendAnalyticsEvent(
                      eventName: "product_view_from_explore",
                      parameters: <String, dynamic>{
                        "product_id": productData?.key,
                        "product_name": productData?.name,
                        "category_id": productData?.category?.id?.toString(),
                        "category_name": productData?.category?.name,
                        "user_id": locator<HomeController>()?.details?.key,
                        "user_name": locator<HomeController>()?.details?.name,
                      });
                } catch (e) {}
                await NavigationService.to(
                  ProductIndividualRoute,
                  arguments: productData,
                );
              },
              index: index,
              cardPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              tags: <String>[
                if (locator<HomeController>()?.cityName?.toLowerCase() ==
                    'ahmedabad')
                  'CODAvailable',
              ],
            );
          },
        );

      case LayoutType.DESIGNER_LAYOUT_1:
      case LayoutType.DESIGNER_LAYOUT_2:
        return GridListWidget<Sellers, Seller>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? SellerFilter(),
          gridCount: gridCount,
          childAspectRatio: getChildAspectRatio(layoutType),
          controller: controller,
          disablePagination: true,
          scrollDirection: scrollDirection,
          emptyListWidget: Container(),
          onEmptyList: onEmptyList,
          tileBuilder: (BuildContext context, data, index, onDelete, onUpdate) {
            return GestureDetector(
              onTap: () {},
              child: SellerTileUi(
                data: data,
                fromHome: fromHome,
                toProduct: toProduct,
              ),
            );
          },
        );

      case LayoutType.DESIGNER_ID_1_2_LAYOUT:
        return GridListWidget<Sellers, Seller>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? SellerFilter(),
          gridCount: gridCount,
          childAspectRatio: getChildAspectRatio(
            layoutType,
            isSmallDevice: isSmallDevice,
          ),
          controller: controller,
          disablePagination: true,
          scrollDirection: scrollDirection,
          emptyListWidget: Container(),
          onEmptyList: onEmptyList,
          loadingWidget: ShimmerWidget(
            type: type,
            scrollDirection: scrollDirection,
            childAspectRatio: getChildAspectRatio(layoutType),
          ),
          tileBuilder: (BuildContext context, data, index, onDelete, onUpdate) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                child: DesignerTileUi(data: data, isSmallDevice: isSmallDevice),
              ),
            );
          },
        );

      case LayoutType.DESIGNER_ID_3_LAYOUT:
      case LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT:
        return GridListWidget<Sellers, Seller>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? SellerFilter(),
          gridCount: gridCount,
          childAspectRatio: getChildAspectRatio(layoutType),
          controller: controller,
          disablePagination: true,
          scrollDirection: scrollDirection,
          emptyListWidget: Container(),
          onEmptyList: onEmptyList,
          loadingWidget: ShimmerWidget(
            type: type,
            scrollDirection: scrollDirection,
            childAspectRatio: getChildAspectRatio(layoutType),
          ),
          tileBuilder: (BuildContext context, data, index, onDelete, onUpdate) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        (layoutType == LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT)
                            ? BorderSide(
                                color: Colors.grey[300],
                              )
                            : BorderSide.none,
                  ),
                ),
                child: DesignerTileUi(
                  data: data,
                  isID3: ((layoutType == LayoutType.DESIGNER_ID_3_LAYOUT) ||
                      layoutType == LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT),
                ),
              ),
            );
          },
        );

      case LayoutType.EXPLORE_DESIGNER_LAYOUT:
        return GridListWidget<Sellers, Seller>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? SellerFilter(),
          gridCount: gridCount,
          childAspectRatio: getChildAspectRatio(
            layoutType,
            isSmallDevice: isSmallDevice,
          ),
          controller: controller,
          disablePagination: true,
          scrollDirection: scrollDirection,
          emptyListWidget: Container(),
          onEmptyList: onEmptyList,
          tileBuilder: (BuildContext context, data, index, onDelete, onUpdate) {
            return GestureDetector(
              onTap: () => BaseController.goToSellerPage(data.key),
              child: ExploreDesignerTileUI(data: data),
            );
          },
        );

      case LayoutType.CATEGORY_LAYOUT_1:
      case LayoutType.CATEGORY_LAYOUT_2:
        return GridListWidget<Categorys, Category>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? CategoryFilter(),
          gridCount: gridCount,
          childAspectRatio: getChildAspectRatio(layoutType),
          controller: controller,
          disablePagination: true,
          scrollDirection: scrollDirection,
          emptyListWidget: Container(),
          onEmptyList: onEmptyList,
          tileBuilder: (BuildContext context, data, index, onDelete, onUpdate) {
            return GestureDetector(
              onTap: () => NavigationService.to(
                CategoryIndiViewRoute,
                arguments: ProductPageArg(
                  queryString: data.filter,
                  subCategory: data.name,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: CategoryTileUI(
                  data: data,
                ),
              ),
            );
          },
        );

      case LayoutType.CATEGORY_LAYOUT_3:
      case LayoutType.CATEGORY_LAYOUT_4:
        return GridListWidget<Categorys, Category>(
          key: UniqueKey(),
          context: context,
          filter: filter ?? CategoryFilter(),
          gridCount: gridCount,
          childAspectRatio: getChildAspectRatio(layoutType),
          controller: controller,
          disablePagination: true,
          scrollDirection: scrollDirection,
          emptyListWidget: Container(),
          onEmptyList: onEmptyList,
          tileBuilder: (BuildContext context, data, index, onDelete, onUpdate) {
            return GestureDetector(
              onTap: () => NavigationService.to(
                CategoryIndiViewRoute,
                arguments: ProductPageArg(
                  queryString: data.filter,
                  subCategory: data.name,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: (layoutType == LayoutType.CATEGORY_LAYOUT_4)
                      ? BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey[300],
                            ),
                            bottom: BorderSide(
                              color: Colors.grey[300],
                            ),
                          ),
                        )
                      : BoxDecoration(),
                  child: NewCategoryTile(
                    data: data,
                    fromCategory: layoutType == LayoutType.CATEGORY_LAYOUT_4,
                  ),
                ),
              ),
            );
          },
        );

      default:
        return null;
    }
  }

  double getSize(LayoutType type) {
    switch (type) {

      //Product
      case LayoutType.PRODUCT_LAYOUT_1:
      case LayoutType.PRODUCT_LAYOUT_2:
        return 260;
      case LayoutType.PRODUCT_LAYOUT_3:
        return null;

      //Designer
      case LayoutType.DESIGNER_LAYOUT_1:
        return 220;
      case LayoutType.DESIGNER_LAYOUT_2:
        return null;
      case LayoutType.DESIGNER_ID_1_2_LAYOUT:
        return 250;
      case LayoutType.DESIGNER_ID_3_LAYOUT:
        return 110;
      case LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT:
        return null;

      //Explore
      case LayoutType.EXPLORE_DESIGNER_LAYOUT:
        return 140;

      //Category
      case LayoutType.CATEGORY_LAYOUT_1:
        return 150;
      case LayoutType.CATEGORY_LAYOUT_2:
        return 200;
      case LayoutType.CATEGORY_LAYOUT_3:
        return 100;
      case LayoutType.VIEW_CART_LAYOUT:
        return 350;
      case LayoutType.MY_ORDERS_LAYOUT:
        return 260;
      case LayoutType.CATEGORY_LAYOUT_4:
        return null;

      //Promotion
      case LayoutType.PROMOTION_LAYOUT_1:
        return 240;

      //Otherwise
      default:
        return 240;
    }
  }

  double getChildAspectRatio(LayoutType type, {bool isSmallDevice = false}) {
    switch (type) {
      case LayoutType.PRODUCT_LAYOUT_1:
      case LayoutType.PRODUCT_LAYOUT_2:
        return 1.35;
      case LayoutType.PRODUCT_LAYOUT_3:
        return 0.68;
      case LayoutType.VIEW_CART_LAYOUT:
        return 0.95;
      case LayoutType.MY_ORDERS_LAYOUT:
        return 1.00;
      case LayoutType.DESIGNER_LAYOUT_1:
        return 0.60;
      case LayoutType.DESIGNER_LAYOUT_2:
        return 1.80;
      case LayoutType.DESIGNER_ID_1_2_LAYOUT:
        return 0.60;
      case LayoutType.DESIGNER_ID_3_LAYOUT:
        return 0.30;
      case LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT:
        return 3.40;
      case LayoutType.CATEGORY_LAYOUT_1:
        return 0.50;
      case LayoutType.CATEGORY_LAYOUT_2:
        return 2.0;
      case LayoutType.CATEGORY_LAYOUT_3:
        return 1.2;
      case LayoutType.CATEGORY_LAYOUT_4:
        return 0.95;
      case LayoutType.EXPLORE_DESIGNER_LAYOUT:
        return 1;

      default:
        return 1.35;
    }
  }
}

class SectionHeader {
  final String title, subTitle;
  final Function viewAll;

  const SectionHeader({@required this.title, this.subTitle, this.viewAll});
}

class CategoryLayout1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FutureSectionBuilder extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Widget loadingWidget;

  const FutureSectionBuilder({
    Key key,
    this.child,
    this.duration = const Duration(seconds: 2),
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(duration),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? child
              : loadingWidget ?? Container(),
    );
  }
}
