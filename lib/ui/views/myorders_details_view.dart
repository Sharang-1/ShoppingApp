import 'package:compound/models/orders.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';

import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/cart_view_model.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:compound/ui/views/help_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyOrdersDetailsView extends StatefulWidget {
  final Order mOrder;

  MyOrdersDetailsView(this.mOrder);

  @override
  _MyOrdersDetailsViewState createState() => _MyOrdersDetailsViewState();
}

class _MyOrdersDetailsViewState extends State<MyOrdersDetailsView> {
  final orderStatuses = [1, 2, 3, 4, 5, 7];
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);
  Order mOrder;

  @override
  void initState() {
    super.initState();
    mOrder = widget.mOrder;
  }

  @override
  Widget build(BuildContext context) {
    double subtitleFontSize = subtitleFontSizeStyle - 2;
    double titleFontSize = subtitleFontSizeStyle;
    double headingFontSize = titleFontSizeStyle;

    return ViewModelProvider<CartViewModel>.withConsumer(
        viewModel: CartViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
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
                        key = new UniqueKey();
                      });

                      await Future.delayed(Duration(milliseconds: 100));

                      refreshController.refreshCompleted(
                          resetFooterState: true);
                    },
                    child: CustomScrollView(slivers: <Widget>[
                      SliverAppBar(
                        elevation: 0,
                        floating: true,
                        snap: true,
                        backgroundColor: backgroundWhiteCreamColor,
                        centerTitle: true,
                        iconTheme: IconThemeData(color: appBarIconColor),
                      ),
                      SliverList(
                        // Use a delegate to build items as they're scrolled on screen.
                        delegate: SliverChildBuilderDelegate(
                          // The builder function returns a ListTile with a title that
                          // displays the index of the current item.
                          (context, index) => Padding(
                            padding: EdgeInsets.only(
                                left: screenPadding,
                                right: screenPadding,
                                top: 10,
                                bottom: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  verticalSpace(10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CustomText(
                                        "Order Details",
                                        isTitle: true,
                                        fontWeight: FontWeight.w700,
                                        fontSize: headingFontSize + 2,
                                      ),
                                      CustomText(
                                        "Order ID: " + mOrder.key,
                                        fontSize: subtitleFontSize,
                                        isTitle: true,
                                        color: logoRed,
                                        isBold: true,
                                      ),
                                    ],
                                  ),
                                  verticalSpace(20),
                                  SizedBox(
                                      height: 150,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      curve15)),
                                          child: Container(
                                            // padding: EdgeInsets.only(
                                            //     left: 15, top: 15, bottom: 15, right: 15),
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
                                                      width: 150,
                                                      height: 150,
                                                      fadeInCurve:
                                                          Curves.easeIn,
                                                      placeholder:
                                                          "assets/images/product_preloading.png",
                                                      image:
                                                          "$PRODUCT_PHOTO_BASE_URL/${mOrder.product.key}/${mOrder.product.photo.photos.first.name}",
                                                      fit: BoxFit.cover,
                                                    )),
                                                horizontalSpaceMedium,
                                                Expanded(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    CustomText(
                                                      widget
                                                          .mOrder.product.name,
                                                      isBold: true,
                                                      color: Colors.grey[800],
                                                      dotsAfterOverFlow: true,
                                                      fontSize:
                                                          titleFontSize + 5,
                                                    ),
                                                    CustomText(
                                                      rupeeUnicode +
                                                          mOrder.orderCost.cost
                                                              .toString(),
                                                      dotsAfterOverFlow: true,
                                                      fontSize:
                                                          titleFontSize + 5,
                                                      isBold: true,
                                                      color: textIconOrange,
                                                    ),
                                                    if (mOrder.variation.size ==
                                                        null)
                                                      CustomText(
                                                          mOrder.variation.size,
                                                          dotsAfterOverFlow:
                                                              true,
                                                          color: Colors.grey,
                                                          fontSize:
                                                              subtitleFontSize +
                                                                  5),
                                                    CustomText(
                                                      widget
                                                          .mOrder.status.state,
                                                      fontSize:
                                                          subtitleFontSize + 5,
                                                      isBold: true,
                                                      color: textIconBlue,
                                                    ),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ))),
                                  verticalSpace(30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            "Delivery Status",
                                            fontSize: headingFontSize,
                                            isTitle: true,
                                            isBold: true,
                                          ),
                                          CustomText(
                                            mOrder.status.state,
                                            fontSize: headingFontSize,
                                            isTitle: true,
                                            isBold: true,
                                          ),
                                        ],
                                      ),
                                      verticalSpace(15),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: LinearPercentIndicator(
                                          lineHeight: 15.0,
                                          percent: (orderStatuses.contains(
                                                      mOrder?.status?.id ?? 0)
                                                  ? ((orderStatuses.indexOf(
                                                                  widget
                                                                      .mOrder
                                                                      .status
                                                                      .id) +
                                                              1) *
                                                          100) /
                                                      orderStatuses.length
                                                  : 100) /
                                              100,
                                          padding: EdgeInsets.zero,
                                          linearStrokeCap:
                                              LinearStrokeCap.roundAll,
                                          linearGradient: LinearGradient(
                                              colors: [
                                                textIconOrange,
                                                logoRed
                                              ]),
                                        ),
                                      ),
                                      verticalSpace(15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(
                                            "Estimated Delivery:",
                                            isBold: true,
                                            fontSize: subtitleFontSize - 1,
                                            color: Colors.grey,
                                          ),
                                          CustomText(
                                            mOrder.deliveryDate
                                                .substring(0, 10),
                                            fontSize: subtitleFontSize - 1,
                                            isBold: true,
                                            color: Colors.grey[600],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  verticalSpace(40),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CustomText(
                                        "Shipping Info",
                                        fontSize: headingFontSize,
                                        isTitle: true,
                                        isBold: true,
                                      ),
                                      verticalSpaceMedium,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(
                                            "Shipping To",
                                            fontSize: subtitleFontSize - 1,
                                            color: Colors.grey,
                                            isBold: true,
                                          ),
                                          CustomText(
                                            model.userName,
                                            color: Colors.grey[600],
                                            fontSize: subtitleFontSize - 1,
                                            isBold: true,
                                          ),
                                        ],
                                      ),
                                      verticalSpaceSmall,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: CustomText(
                                              "Shipping Address    ",
                                              fontSize: subtitleFontSize - 1,
                                              color: Colors.grey,
                                              isBold: true,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                CustomText(
                                                  mOrder.billingAddress ?? "",
                                                  align: TextAlign.end,
                                                  color: Colors.grey[600],
                                                  fontSize:
                                                      subtitleFontSize - 1,
                                                  isBold: true,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  verticalSpace(40),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CustomText(
                                        "Payment Info",
                                        fontSize: headingFontSize,
                                        isTitle: true,
                                        isBold: true,
                                      ),
                                      verticalSpaceMedium,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(
                                            "Payment On Delivery Via",
                                            fontSize: subtitleFontSize - 1,
                                            color: Colors.grey,
                                            isBold: true,
                                          ),
                                          CustomText(
                                            mOrder.payment.option.name,
                                            color: Colors.grey[600],
                                            fontSize: subtitleFontSize - 1,
                                            isBold: true,
                                          ),
                                        ],
                                      ),
                                      verticalSpaceSmall,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(
                                            "Listed Price",
                                            fontSize: subtitleFontSize - 1,
                                            color: Colors.grey,
                                            isBold: true,
                                          ),
                                          CustomText(
                                            rupeeUnicode +
                                                mOrder.product.price.toString(),
                                            color: Colors.grey[600],
                                            fontSize: subtitleFontSize - 1,
                                            isBold: true,
                                          ),
                                        ],
                                      ),
                                      if (widget
                                              .mOrder.orderCost.productPrice !=
                                          mOrder.product.price)
                                        verticalSpaceSmall,
                                      if (widget
                                              .mOrder.orderCost.productPrice !=
                                          mOrder.product.price)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(
                                              "Discounted Price",
                                              isBold: true,
                                              fontSize: subtitleFontSize - 1,
                                              color: Colors.grey,
                                            ),
                                            CustomText(
                                              rupeeUnicode +
                                                  mOrder.orderCost.productPrice
                                                      .toString(),
                                              color: Colors.grey[600],
                                              fontSize: subtitleFontSize - 1,
                                              isBold: true,
                                            ),
                                          ],
                                        ),
                                      verticalSpaceSmall,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(
                                            "Shipping Charge",
                                            isBold: true,
                                            fontSize: subtitleFontSize - 1,
                                            color: Colors.grey,
                                          ),
                                          CustomText(
                                            mOrder.orderCost.shippingCharge == 0
                                                ? "Free Delivery"
                                                : mOrder
                                                    .orderCost.shippingCharge
                                                    .toString(),
                                            color: green,
                                            fontSize: subtitleFontSize - 1,
                                            isBold: true,
                                          ),
                                        ],
                                      ),
                                      verticalSpaceSmall,
                                      Divider(
                                        color: Colors.grey[300],
                                        thickness: 1.5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(
                                            "Total",
                                            fontSize: subtitleFontSize,
                                            isBold: true,
                                            color: Colors.grey,
                                          ),
                                          CustomText(
                                            rupeeUnicode +
                                                mOrder.orderCost.cost
                                                    .toString(),
                                            color: textIconOrange,
                                            fontSize: subtitleFontSize + 2,
                                            isBold: true,
                                          ),
                                        ],
                                      ),
                                      verticalSpaceSmall,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Expanded(
                                            child: CustomText(
                                              "Delivery Status",
                                              fontSize: subtitleFontSize,
                                              isBold: true,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: CustomText(
                                              mOrder.status.state,
                                              align: TextAlign.end,
                                              color: textIconOrange,
                                              fontSize: subtitleFontSize + 2,
                                              isBold: true,
                                            ),
                                          ),
                                          verticalSpaceSmall,
                                        ],
                                      ),
                                    ],
                                  ),
                                  verticalSpace(50),
                                  RaisedButton(
                                    elevation: 0,
                                    onPressed: () async =>
                                        await showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(curve30))),
                                      clipBehavior: Clip.antiAlias,
                                      context: context,
                                      builder: (con) => HelpView(),
                                    ),
                                    color: backgroundWhiteCreamColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(
                                            color: textIconOrange, width: 2)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: InkWell(
                                        child: Text(
                                          "Help",
                                          style: TextStyle(
                                              color: textIconOrange,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  verticalSpace(20),
                                ]),
                          ),
                          childCount: 1,
                        ),
                      ),
                      //
                    ]),
                  )),
            ));
  }

  Widget childWidget(subtitleFontSize, titleFontSize, headingFontSize) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenPadding, right: screenPadding, top: 10, bottom: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            verticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomText(
                  "Order Details",
                  isTitle: true,
                  fontWeight: FontWeight.w700,
                  fontSize: headingFontSize + 2,
                ),
                CustomText(
                  "Order ID: " + mOrder.key,
                  fontSize: subtitleFontSize,
                  isTitle: true,
                  color: logoRed,
                  isBold: true,
                ),
              ],
            ),
            verticalSpace(20),
            SizedBox(
                height: 180,
                child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(curve15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 15, bottom: 15, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(curve15),
                              child: FadeInImage.assetNetwork(
                                width: 100,
                                height: 120,
                                fadeInCurve: Curves.easeIn,
                                placeholder:
                                    "assets/images/product_preloading.png",
                                image:
                                    "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                fit: BoxFit.cover,
                              )),
                          horizontalSpaceMedium,
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CustomText(
                                mOrder.product.name,
                                isBold: true,
                                color: Colors.grey[800],
                                dotsAfterOverFlow: true,
                                fontSize: titleFontSize,
                              ),
                              CustomText(
                                rupeeUnicode + mOrder.orderCost.cost.toString(),
                                dotsAfterOverFlow: true,
                                fontSize: titleFontSize,
                                isBold: true,
                                color: textIconOrange,
                              ),
                              CustomText(mOrder.variation.size,
                                  dotsAfterOverFlow: true,
                                  color: Colors.grey,
                                  fontSize: subtitleFontSize),
                              CustomText(
                                mOrder.status.state,
                                fontSize: subtitleFontSize,
                                isBold: true,
                                color: Colors.grey,
                              ),
                            ],
                          )),
                        ],
                      ),
                    ))),
            verticalSpace(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  "Delivery Status",
                  fontSize: headingFontSize,
                  isTitle: true,
                  isBold: true,
                ),
                verticalSpace(15),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: LinearPercentIndicator(
                    lineHeight: 15.0,
                    percent: orderStatuses.contains(mOrder?.status?.id ?? 0)
                        ? (orderStatuses.indexOf(mOrder.status.id) + 1) *
                            100 /
                            orderStatuses.length
                        : 100,
                    padding: EdgeInsets.zero,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    linearGradient:
                        LinearGradient(colors: [textIconOrange, logoRed]),
                  ),
                ),
                verticalSpace(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomText(
                      "Estimated Delivery:",
                      isBold: true,
                      fontSize: subtitleFontSize - 1,
                      color: Colors.grey,
                    ),
                    CustomText(
                      mOrder.deliveryDate,
                      fontSize: subtitleFontSize - 1,
                      isBold: true,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
            verticalSpace(40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  "Shipping Info",
                  fontSize: headingFontSize,
                  isTitle: true,
                  isBold: true,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomText(
                      "Shipping To",
                      fontSize: subtitleFontSize - 1,
                      color: Colors.grey,
                      isBold: true,
                    ),
                    CustomText(
                      "Rohan Shah",
                      color: Colors.grey[600],
                      fontSize: subtitleFontSize - 1,
                      isBold: true,
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      "Shipping Address    ",
                      fontSize: subtitleFontSize - 1,
                      color: Colors.grey,
                      isBold: true,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          CustomText(
                            mOrder.billingAddress ?? "",
                            align: TextAlign.end,
                            color: Colors.grey[600],
                            fontSize: subtitleFontSize - 1,
                            isBold: true,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            verticalSpace(40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  "Payment Info",
                  fontSize: headingFontSize,
                  isTitle: true,
                  isBold: true,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomText(
                      "Payment On Delivery Via",
                      fontSize: subtitleFontSize - 1,
                      color: Colors.grey,
                      isBold: true,
                    ),
                    CustomText(
                      mOrder.payment.option.name,
                      color: Colors.grey[600],
                      fontSize: subtitleFontSize - 1,
                      isBold: true,
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomText(
                      "Listed Price",
                      fontSize: subtitleFontSize - 1,
                      color: Colors.grey,
                      isBold: true,
                    ),
                    CustomText(
                      rupeeUnicode + mOrder.product.price.toString(),
                      color: Colors.grey[600],
                      fontSize: subtitleFontSize - 1,
                      isBold: true,
                    ),
                  ],
                ),
                verticalSpaceSmall,
                if (mOrder.orderCost.productPrice != mOrder.product.price)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomText(
                        "Discounted Price",
                        isBold: true,
                        fontSize: subtitleFontSize - 1,
                        color: Colors.grey,
                      ),
                      CustomText(
                        rupeeUnicode + mOrder.orderCost.productPrice.toString(),
                        color: Colors.grey[600],
                        fontSize: subtitleFontSize - 1,
                        isBold: true,
                      ),
                    ],
                  ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomText(
                      "Shipping Charge",
                      isBold: true,
                      fontSize: subtitleFontSize - 1,
                      color: Colors.grey,
                    ),
                    CustomText(
                      mOrder.orderCost.shippingCharge == 0
                          ? "Free Delivery"
                          : mOrder.orderCost.shippingCharge.toString(),
                      color: green,
                      fontSize: subtitleFontSize - 1,
                      isBold: true,
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Divider(
                  color: Colors.grey[300],
                  thickness: 1.5,
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomText(
                      "Total",
                      fontSize: subtitleFontSize,
                      isBold: true,
                      color: Colors.grey,
                    ),
                    CustomText(
                      rupeeUnicode + mOrder.orderCost.cost.toString(),
                      color: textIconOrange,
                      fontSize: subtitleFontSize + 2,
                      isBold: true,
                    ),
                  ],
                ),
              ],
            ),
            verticalSpace(50),
            RaisedButton(
                elevation: 0,
                onPressed: () {},
                color: backgroundWhiteCreamColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: textIconOrange, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Help",
                    style: TextStyle(
                        color: textIconOrange, fontWeight: FontWeight.bold),
                  ),
                )),
            verticalSpace(20),
          ]),
    );
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
