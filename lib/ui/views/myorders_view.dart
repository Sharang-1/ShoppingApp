import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../locator.dart';
import '../../models/orders.dart';
import '../../services/navigation_service.dart';
import '../../viewmodels/orders_view_model.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/GridListWidget.dart';
import '../widgets/custom_text.dart';
import 'myorders_details_view.dart';

class MyOrdersView extends StatefulWidget {
  @override
  _MyOrdersViewState createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  final NavigationService _navigationService = locator<NavigationService>();
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    double subtitleFontSize = subtitleFontSizeStyle - 2;
    double titleFontSize = subtitleFontSizeStyle;
    double headingFontSize = headingFontSizeStyle;
    return ViewModelProvider<OrdersViewModel>.withConsumer(
      viewModel: OrdersViewModel(),
      onModelReady: (model) => model.getOrders(),
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
          iconTheme: IconThemeData(color: appBarIconColor),
        ),
        backgroundColor: backgroundWhiteCreamColor,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          child: SmartRefresher(
            enablePullDown: true,
            footer: null,
            header: WaterDropHeader(
              waterDropColor: logoRed,
              refresh: Container(),
              complete: Container(),
            ),
            controller: refreshController,
            onRefresh: () async {
              setState(() {
                key = UniqueKey();
              });
              await Future.delayed(Duration(milliseconds: 100));
              refreshController.refreshCompleted(resetFooterState: true);
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: screenPadding,
                    right: screenPadding,
                    top: 10,
                    bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    verticalSpace(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "My Orders",
                          style: TextStyle(
                              fontFamily: headingFont,
                              fontWeight: FontWeight.w700,
                              fontSize: headingFontSize),
                        ),
                        TextButton(
                          child: CustomText(
                            "Wishlist",
                            fontFamily: headingFont,
                            isBold: true,
                            fontSize: subtitleFontSize,
                            color: logoRed,
                          ),
                          onPressed: () {
                            _navigationService.navigateTo(WhishListRoute);
                          },
                        )
                      ],
                    ),
                    verticalSpace(20),
                    if (model.busy) CircularProgressIndicator(),
                    if (!model.busy && model.mOrders != null)
                      GroupedListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        elements: model.mOrders.orders,
                        groupBy: (Order o) => o.created.substring(0, 10),
                        groupComparator: (String a, String b) {
                          DateTime aDateTime = DateTime.parse(
                              "${a.substring(6, 10)}${a.substring(3, 5)}${a.substring(0, 2)}");
                          DateTime bDateTime = DateTime.parse(
                              "${b.substring(6, 10)}${b.substring(3, 5)}${b.substring(0, 2)}");
                          return bDateTime.compareTo(aDateTime);
                        },
                        groupSeparatorBuilder: (String created) {
                          var date = DateFormat.yMMMMd('en_US').format(
                              DateTime.parse(
                                  "${created.substring(6, 10)}${created.substring(3, 5)}${created.substring(0, 2)}"));
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: logoRed,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (BuildContext context, Order order) =>
                            Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            height: 120,
                            child: GestureDetector(
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(curve15),
                                ),
                                elevation: 5,
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(curve15),
                                        child: FadeInImage.assetNetwork(
                                          width: 120,
                                          height: 120,
                                          fadeInCurve: Curves.easeIn,
                                          placeholder:
                                              "assets/images/product_preloading.png",
                                          image:
                                              "$PRODUCT_PHOTO_BASE_URL/${order.product.key}/${order.product.photo.photos.first.name}-small.png",
                                          imageErrorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            "assets/images/product_preloading.png",
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      horizontalSpaceMedium,
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CustomText(
                                            order.product.name,
                                            isBold: true,
                                            color: Colors.grey[800],
                                            dotsAfterOverFlow: true,
                                            fontSize: titleFontSize,
                                          ),
                                          CustomText(
                                            rupeeUnicode +
                                                order.orderCost.cost.toString(),
                                            dotsAfterOverFlow: true,
                                            fontSize: titleFontSize,
                                            isBold: true,
                                            color: textIconOrange,
                                          ),
                                          if (order.variation.size != 'N/A')
                                            CustomText(order.variation.size,
                                                dotsAfterOverFlow: true,
                                                color: Colors.grey,
                                                fontSize: subtitleFontSize),
                                          CustomText(
                                            order.status.state,
                                            fontSize: subtitleFontSize,
                                            isBold: true,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      )),
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) =>
                                        MyOrdersDetailsView(order),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    if (!model.busy && model.mOrders?.orders?.length == 0)
                      verticalSpaceLarge,
                    if (!model.busy && model?.mOrders?.orders?.length == 0)
                      EmptyListWidget(),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
