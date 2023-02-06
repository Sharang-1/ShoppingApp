import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/server_urls.dart';
import '../../controllers/cart_controller.dart';
import '../../models/orders.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import 'help_view.dart';
import 'home_view_list.dart';

class MyOrdersDetailsViewV1 extends StatefulWidget {
  final Order mOrder;

  MyOrdersDetailsViewV1(this.mOrder);

  @override
  _MyOrdersDetailsViewV1State createState() => _MyOrdersDetailsViewV1State();
}

class _MyOrdersDetailsViewV1State extends State<MyOrdersDetailsViewV1> {
  final orderStatuses = [0, 1, 2, 3, 4, 5, 7];
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);
  late Order mOrder;

  @override
  Widget build(BuildContext context) => GetBuilder(
        init: CartController()..init(),
        initState: (state) {
          mOrder = widget.mOrder;
        },
        builder: (controller) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              ORDER_DETAILS.tr,
              style: TextStyle(
                fontFamily: headingFont,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            iconTheme: IconThemeData(color: appBarIconColor),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            top: true,
            left: false,
            right: false,
            child: SmartRefresher(
              enablePullDown: true,
              footer: null,
              header: WaterDropHeader(
                waterDropColor: logoRed,
                refresh: Center(
                  child: Center(
                    child: Image.asset(
                      "assets/images/loading_img.gif",
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
                complete: Container(),
              ),
              controller: refreshController,
              onRefresh: () async {
                setState(() {
                  key = new UniqueKey();
                });

                await Future.delayed(Duration(milliseconds: 100));

                refreshController.refreshCompleted(resetFooterState: true);
              },
              child: CustomScrollView(
                slivers: <Widget>[
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
                            CustomText(
                              "Order ID: " + mOrder.key!,
                              fontSize: titleFontSize,
                              isTitle: true,
                              color: logoRed,
                              isBold: true,
                            ),
                            verticalSpace(20),
                            SizedBox(
                                height: 150,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(curve15)),
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      curve15),
                                              child: FadeInImage.assetNetwork(
                                                width: 150,
                                                height: 150,
                                                fadeInCurve: Curves.easeIn,
                                                placeholder:
                                                    "assets/images/product_preloading.png",
                                                image:
                                                    "$PRODUCT_PHOTO_BASE_URL/${mOrder.product?.key}/${mOrder.product?.photo?.photos?.first.name}-small.png",
                                                imageErrorBuilder: (context,
                                                        error, stackTrace) =>
                                                    Image.asset(
                                                        "assets/images/product_preloading.png",
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover),
                                                fit: BoxFit.cover,
                                              )),
                                          horizontalSpaceMedium,
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              CustomText(
                                                widget.mOrder.product?.name ??
                                                    '',
                                                isBold: true,
                                                color: Colors.grey[800]!,
                                                dotsAfterOverFlow: true,
                                                fontSize: titleFontSize + 2,
                                              ),
                                              CustomText(
                                                "Qty: ${widget.mOrder.orderCost!.quantity}",
                                                color: Colors.grey[800]!,
                                                dotsAfterOverFlow: true,
                                                fontSize: titleFontSize,
                                              ),
                                              if (widget
                                                      .mOrder.variation!.size !=
                                                  null)
                                                CustomText(
                                                  "Size: ${widget.mOrder.variation!.size}",
                                                  color: Colors.grey[800]!,
                                                  dotsAfterOverFlow: true,
                                                  fontSize: titleFontSize,
                                                ),
                                              if (widget.mOrder.variation!
                                                      .color !=
                                                  null)
                                                CustomText(
                                                  "Color: ${widget.mOrder.variation!.color}",
                                                  color: Colors.grey[800]!,
                                                  dotsAfterOverFlow: true,
                                                  fontSize: titleFontSize,
                                                ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: CustomText(
                                                      widget.mOrder.status!
                                                          .state!,
                                                      fontSize:
                                                          subtitleFontSize,
                                                      isBold: true,
                                                      color: textIconBlue,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: CustomText(
                                                        '$rupeeUnicode${mOrder.orderCost?.cost}',
                                                        fontSize: titleFontSize,
                                                        isBold: true,
                                                        color: lightGreen,
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      "Delivery Status",
                                      fontSize: headingFontSizeStyle,
                                      isTitle: true,
                                      isBold: true,
                                    ),
                                    CustomText(
                                      mOrder.status!.state!,
                                      fontSize: headingFontSizeStyle,
                                      isTitle: true,
                                      isBold: true,
                                    ),
                                  ],
                                ),
                                verticalSpace(15),
                                if (!([6, 8, 9, 10, 11, 12]
                                    .contains(mOrder.status?.id ?? -1)))
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: LinearPercentIndicator(
                                      lineHeight: 15.0,
                                      percent: (orderStatuses.contains(
                                                  mOrder.status?.id ?? -1)
                                              ? ((orderStatuses.indexOf(
                                                            widget
                                                                        .mOrder
                                                                        .status!
                                                                        .id
                                                                    as int? ??
                                                                0,
                                                          ) +
                                                          1) *
                                                      100) /
                                                  orderStatuses.length
                                              : 100) /
                                          100,
                                      padding: EdgeInsets.zero,
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      linearGradient: LinearGradient(
                                          colors: [textIconOrange, logoRed]),
                                    ),
                                  ),
                                if (!([6, 8, 9, 10, 11, 12]
                                    .contains(mOrder.status?.id ?? -1)))
                                  verticalSpace(15),
                                if (!([6, 8, 9, 10, 11, 12]
                                    .contains(mOrder.status?.id ?? -1)))
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
                                        mOrder.deliveryDate!.substring(0, 10),
                                        fontSize: subtitleFontSize - 1,
                                        isBold: true,
                                        color: Colors.grey[600]!,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            SectionDivider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  "Shipping Info",
                                  fontSize: headingFontSizeStyle,
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
                                      (controller as CartController).userName,
                                      color: Colors.grey[600]!,
                                      fontSize: subtitleFontSize - 1,
                                      isBold: true,
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: Colors.grey[600]!,
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
                            SectionDivider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  "Payment Info",
                                  fontSize: headingFontSizeStyle,
                                  isTitle: true,
                                  isBold: true,
                                ),
                                verticalSpaceMedium,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(
                                      "Payment Method",
                                      fontSize: subtitleFontSize - 1,
                                      color: Colors.grey,
                                      isBold: true,
                                    ),
                                    CustomText(
                                      mOrder.payment!.option!.name ?? "",
                                      color: Colors.grey[600]!,
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
                                      "Price",
                                      fontSize: subtitleFontSize - 1,
                                      color: Colors.grey,
                                      isBold: true,
                                    ),
                                    CustomText(
                                      '$rupeeUnicode${(mOrder.product!.price! + (mOrder.orderCost!.convenienceCharges!.cost! / (mOrder.orderCost?.quantity ?? 1))).toStringAsFixed(2)}',
                                      color: Colors.grey[600]!,
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
                                      "Quantity",
                                      fontSize: subtitleFontSize - 1,
                                      color: Colors.grey,
                                      isBold: true,
                                    ),
                                    CustomText(
                                      '${mOrder.orderCost?.quantity}',
                                      color: Colors.grey[600]!,
                                      fontSize: subtitleFontSize - 1,
                                      isBold: true,
                                    ),
                                  ],
                                ),
                                if ((mOrder.orderCost?.productDiscount?.cost ??
                                        0) !=
                                    0)
                                  verticalSpaceSmall,
                                if ((mOrder.orderCost?.productDiscount?.cost ??
                                        0) !=
                                    0)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CustomText(
                                        "Discount",
                                        fontSize: subtitleFontSize - 1,
                                        color: Colors.grey,
                                        isBold: true,
                                      ),
                                      CustomText(
                                        '$rupeeUnicode${mOrder.orderCost?.productDiscount?.cost?.toStringAsFixed(2)}',
                                        color: green,
                                        fontSize: subtitleFontSize - 1,
                                        isBold: true,
                                      ),
                                    ],
                                  ),
                                if ((mOrder.orderCost?.promocodeDiscount
                                            ?.cost ??
                                        0) !=
                                    0)
                                  verticalSpaceSmall,
                                if ((mOrder.orderCost?.promocodeDiscount
                                            ?.cost ??
                                        0) !=
                                    0)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CustomText(
                                        "Promocode Discount",
                                        fontSize: subtitleFontSize - 1,
                                        color: Colors.grey,
                                        isBold: true,
                                      ),
                                      CustomText(
                                        '$rupeeUnicode${mOrder.orderCost?.promocodeDiscount?.cost?.toStringAsFixed(2)}',
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
                                      "Sub Total",
                                      fontSize: subtitleFontSize - 1,
                                      color: Colors.grey,
                                      isBold: true,
                                    ),
                                    CustomText(
                                      '$rupeeUnicode${((mOrder.product!.price! * (mOrder.orderCost?.quantity ?? 1)) - (mOrder.orderCost?.productDiscount?.cost ?? 0) - (mOrder.orderCost?.promocodeDiscount?.cost ?? 0) + (mOrder.orderCost?.convenienceCharges?.cost ?? 0)).toStringAsFixed(2)}',
                                      color: Colors.grey[600]!,
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
                                      "GST",
                                      isBold: true,
                                      fontSize: subtitleFontSize - 1,
                                      color: Colors.grey,
                                    ),
                                    CustomText(
                                      '$rupeeUnicode${mOrder.orderCost?.gstCharges?.cost?.toStringAsFixed(2)}',
                                      color: green,
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
                                      mOrder.orderCost?.deliveryCharges?.cost ==
                                              0
                                          ? "Free Delivery"
                                          : '$rupeeUnicode${mOrder.orderCost?.deliveryCharges?.cost?.toStringAsFixed(2)}',
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
                                      '$rupeeUnicode${mOrder.orderCost?.cost}',
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
                                        mOrder.status?.state ?? '-',
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
                            if (!(<int>[9, 12]
                                .contains(mOrder.status?.id ?? -1))) ...[
                              verticalSpace(50),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: textIconOrange, width: 2)),
                                ),
                                onPressed: () async =>
                                    await showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(curve10),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  context: context,
                                  builder: (con) => HelpView(),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: InkWell(
                                    child: Text(
                                      "Returns & Refunds",
                                      style: TextStyle(
                                          color: textIconOrange,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            verticalSpace(20),
                          ],
                        ),
                      ),
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
