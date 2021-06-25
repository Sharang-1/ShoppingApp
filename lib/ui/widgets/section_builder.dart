import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/base_grid_view_builder_controller.dart';
import '../../models/categorys.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../models/grid_view_builder_filter_models/categoryFilter.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/grid_view_builder_filter_models/sellerFilter.dart';
import '../../models/productPageArg.dart';
import '../../models/products.dart';
import '../../models/sellers.dart';
import '../../services/navigation_service.dart';
import '../shared/ui_helpers.dart';
import 'explore_product_tile.dart';
import 'grid_list_widget.dart';
import 'product_tile_ui.dart';
import 'categoryTileUI.dart';
import 'home_view_list_header.dart';
import 'sellerTileUi.dart';
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

  //Designer Layouts
  DESIGNER_LAYOUT_1,
  DESIGNER_LAYOUT_2,
  DESIGNER_ID_1_2_LAYOUT,
  DESIGNER_ID_3_LAYOUT,
  DESIGNER_ID_3_VERTICAL_LAYOUT,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (header != null)
            HomeViewListHeader(
              title: header.title,
              subTitle: header.subTitle,
              viewAll: header.viewAll,
            ),
          if (header != null) spacer,
          SizedBox(
            height: getSize(layoutType),
            child: withScrollBar
                ? Theme(
                    data: ThemeData(
                      scrollbarTheme: ScrollbarThemeData().copyWith(
                        thumbColor: MaterialStateProperty.all(Colors.grey[600]),
                        trackColor: MaterialStateProperty.all(Colors.black),
                        trackBorderColor:
                            MaterialStateProperty.all(Colors.grey[500]),
                        isAlwaysShown: true,
                        interactive: true,
                        showTrackOnHover: true,
                      ),
                    ),
                    child: Scrollbar(
                      controller: ScrollController(),
                      child: getGridListWidget(layoutType),
                    ),
                  )
                : getGridListWidget(layoutType),
          ),
        ],
      );

  Widget getGridListWidget(LayoutType type) {
    switch (type) {
      case LayoutType.PRODUCT_LAYOUT_1:
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
          tileBuilder:
              (BuildContext context, productData, index, onUpdate, onDelete) {
            var product = productData as Product;
            return InkWell(
              onTap: () => BaseController.goToProductPage(productData),
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TopPicksAndDealsCard(
                  data: {
                    "key": product?.key ?? "Test",
                    "name": product?.name ?? "Test",
                    "actualCost": (product.cost.cost +
                            product.cost.convenienceCharges.cost +
                            product.cost.gstCharges.cost +
                            BaseController.deliveryCharge)
                        .round(),
                    "price": (product.cost.costToCustomer +
                                BaseController.deliveryCharge)
                            .round() ??
                        0,
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
          tileBuilder:
              (BuildContext context, productData, index, onUpdate, onDelete) {
            return ProductTileUI(
              data: productData,
              onClick: () => NavigationService.to(
                ProductIndividualRoute,
                arguments: productData,
              ),
              index: index,
              cardPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            );
          },
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
              onClick: () => NavigationService.to(
                ProductIndividualRoute,
                arguments: productData,
              ),
              index: index,
              cardPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
          childAspectRatio: getChildAspectRatio(layoutType),
          controller: controller,
          disablePagination: true,
          scrollDirection: scrollDirection,
          emptyListWidget: Container(),
          onEmptyList: onEmptyList,
          tileBuilder: (BuildContext context, data, index, onDelete, onUpdate) {
            return GestureDetector(
              onTap: () {},
              child: DesignerTileUi(data: data),
            );
          },
        );

      case LayoutType.DESIGNER_ID_1_2_LAYOUT:
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
          tileBuilder: (BuildContext context, data, index, onDelete, onUpdate) {
            return GestureDetector(
              onTap: () {},
              child: DesignerTileUi(
                data: data,
                isID3: ((layoutType == LayoutType.DESIGNER_ID_3_LAYOUT) || layoutType == LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT),
              ),
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
                child: HomeScreenCategoryTile(
                  data: data,
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
        return 240;
      case LayoutType.PRODUCT_LAYOUT_3:
        return null;

      //Designer
      case LayoutType.DESIGNER_LAYOUT_1:
        return 220;
      case LayoutType.DESIGNER_LAYOUT_2:
        return null;
      case LayoutType.DESIGNER_ID_1_2_LAYOUT:
        return 225;
      case LayoutType.DESIGNER_ID_3_LAYOUT:
        return 110;
      case LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT:
        return null;

      //Category
      case LayoutType.CATEGORY_LAYOUT_1:
        return 150;
      case LayoutType.CATEGORY_LAYOUT_2:
        return 200;
      case LayoutType.CATEGORY_LAYOUT_3:
        return 100;

      //Promotion
      case LayoutType.PROMOTION_LAYOUT_1:
        return 240;

      //Otherwise
      default:
        return 240;
    }
  }

  double getChildAspectRatio(LayoutType type) {
    switch (type) {
      case LayoutType.PRODUCT_LAYOUT_1:
      case LayoutType.PRODUCT_LAYOUT_2:
        return 1.35;
      case LayoutType.PRODUCT_LAYOUT_3:
        return 0.73;
      case LayoutType.DESIGNER_LAYOUT_1:
        return 0.60;
      case LayoutType.DESIGNER_LAYOUT_2:
        return 1.80;
      case LayoutType.DESIGNER_ID_1_2_LAYOUT:
        return 0.60;
      case LayoutType.DESIGNER_ID_3_LAYOUT:
        return 0.30;
      case LayoutType.DESIGNER_ID_3_VERTICAL_LAYOUT:
        return 3.50;
      case LayoutType.CATEGORY_LAYOUT_1:
        return 0.50;
      case LayoutType.CATEGORY_LAYOUT_2:
        return 2.0;
      case LayoutType.CATEGORY_LAYOUT_3:
        return 1.2;

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
