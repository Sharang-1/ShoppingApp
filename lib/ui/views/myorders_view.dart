import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/viewmodels/orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import './myorders_details_view.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../widgets/custom_text.dart';
import '../shared/app_colors.dart';
import 'package:flutter_svg/svg.dart';

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
                              FlatButton(
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
                            ...model.mOrders.orders.map(
                              (o) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: SizedBox(
                                      height: 120,
                                      child: GestureDetector(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      curve15),
                                            ),
                                            elevation: 5,
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              curve15),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        width: 120,
                                                        height: 120,
                                                        fadeInCurve:
                                                            Curves.easeIn,
                                                        placeholder:
                                                            "assets/images/product_preloading.png",
                                                        image:
                                                            "$PRODUCT_PHOTO_BASE_URL/${o.product.key}/${o.product.photo.photos.first.name}",
                                                        imageErrorBuilder: (context, error, stackTrace) => Image.asset("assets/images/product_preloading.png", width: 120,
                                                        height: 120, fit: BoxFit.cover,),
                                                        fit: BoxFit.cover,
                                                      )),
                                                  horizontalSpaceMedium,
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      CustomText(
                                                        o.product.name,
                                                        isBold: true,
                                                        color: Colors.grey[800],
                                                        dotsAfterOverFlow: true,
                                                        fontSize: titleFontSize,
                                                      ),
                                                      CustomText(
                                                        rupeeUnicode +
                                                            o.orderCost.cost
                                                                .toString(),
                                                        dotsAfterOverFlow: true,
                                                        fontSize: titleFontSize,
                                                        isBold: true,
                                                        color: textIconOrange,
                                                      ),
                                                      if (o.variation.size !=
                                                          'N/A')
                                                        CustomText(
                                                            o.variation.size,
                                                            dotsAfterOverFlow:
                                                                true,
                                                            color: Colors.grey,
                                                            fontSize:
                                                                subtitleFontSize),
                                                      CustomText(
                                                        o.status.state,
                                                        fontSize:
                                                            subtitleFontSize,
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
                                            )),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyOrdersDetailsView(o)));
                                        },
                                      )),
                                );
                              },
                            ),
                          if (!model.busy && model.mOrders?.orders?.length == 0)
                            verticalSpaceLarge,
                          if (!model.busy && model?.mOrders?.orders?.length == 0)
                            EmptyListWidget(),
                          // SizedBox(
                          //     height: 200,
                          //     child: Card(
                          //         clipBehavior: Clip.antiAlias,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(curve15),
                          //         ),
                          //         elevation: 5,
                          //         child: Padding(
                          //           padding: EdgeInsets.only(
                          //               left: 15, top: 20, bottom: 20),
                          //           child: Row(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.center,
                          //             children: <Widget>[
                          //               ClipRRect(
                          //                   borderRadius:
                          //                       BorderRadius.circular(curve15),
                          //                   child: FadeInImage.assetNetwork(
                          //                     width: (MediaQuery.of(context)
                          //                                 .size
                          //                                 .width -
                          //                             70) /
                          //                         3,
                          //                     height: 140,
                          //                     fadeInCurve: Curves.easeIn,
                          //                     placeholder:
                          //                         "assets/images/placeholder.png",
                          //                     image:
                          //                         "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                          //                     fit: BoxFit.cover,
                          //                   )),
                          //               horizontalSpaceMedium,
                          //               Expanded(
                          //                   child: Column(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceEvenly,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: <Widget>[
                          //                   CustomText(
                          //                     "Nike T-Shirt",
                          //                     isBold: true,
                          //                     color: Colors.grey[800],
                          //                     dotsAfterOverFlow: true,
                          //                     fontSize: titleFontSize,
                          //                   ),
                          //                   CustomText(
                          //                     rupeeUnicode + '100',
                          //                     dotsAfterOverFlow: true,
                          //                     fontSize: titleFontSize,
                          //                     isBold: true,
                          //                     color: textIconOrange,
                          //                   ),
                          //                   CustomText("XL",
                          //                       dotsAfterOverFlow: true,
                          //                       color: Colors.grey,
                          //                       fontSize: subtitleFontSize),
                          //                   CustomText(
                          //                     "Shipping",
                          //                     fontSize: subtitleFontSize,
                          //                     isBold: true,
                          //                     color: Colors.grey,
                          //                   ),
                          //                 ],
                          //               )),
                          //               IconButton(
                          //                 icon: Icon(
                          //                   Icons.arrow_forward_ios,
                          //                   color: Colors.grey,
                          //                 ),
                          //                 onPressed: () {
                          //                   Navigator.push(
                          //                       context,
                          //                       new MaterialPageRoute(
                          //                           builder: (context) =>
                          //                               MyOrdersDetailsView()));
                          //                 },
                          //               )
                          //             ],
                          //           ),
                          //         ))),
                          verticalSpaceMedium,
                        ]),
                  )),
                ),
              ),
              // ),
              // )
            ));
  }
}

/*

***************** GridListView for cart *****************************

    viewModel: CartViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: GridListWidget<Cart, Item>(
            // key: key,
            context: context,
            filter: filter,
            gridCount: 1,
            disablePagination: true,
            viewModel: CartGridViewBuilderViewModel(),
            childAspectRatio: 3,
            tileBuilder: (BuildContext context, data, index) {
              Fimber.d("test");
              print((data as Item).toJson());
              final Item dItem = data as Item;
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("ID : " + dItem.productId.toString()),
                    Text("Name : " + dItem.product.name),
                    Text("Price : " + dItem.product.price.toString()),
                    Text("Qty : " + dItem.quantity.toString()),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("Remove Item"),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

*/
