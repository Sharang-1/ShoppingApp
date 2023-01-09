import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/server_urls.dart';
import '../../controllers/cart_controller.dart';
import '../../locator.dart';
import '../../models/ordersV2.dart';
import '../../models/products.dart';
import '../../services/api/api_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import 'help_view.dart';
import 'home_view_list.dart';

class MyOrdersDetailsView extends StatefulWidget {
  final Order mOrder;

  MyOrdersDetailsView(this.mOrder);

  @override
  _MyOrdersDetailsViewState createState() => _MyOrdersDetailsViewState();
}

class _MyOrdersDetailsViewState extends State<MyOrdersDetailsView> {
  final orderStatuses = [0, 1, 2, 3, 4, 5, 7];
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);
  late Order mOrder;
  bool isLoading = true;
  Product? productDetail;
  final APIService _apiService = locator<APIService>();

  @override
  void initState() {
    getProductInfo();
    super.initState();
  }

  getProductInfo() async {
    var productInfo = await _apiService.getProductById(productId: widget.mOrder.productId!);
    setState(() {
      productDetail = productInfo;
      isLoading = false;
    });
  }

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
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: logoRed),
                  )
                : SmartRefresher(
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
                                top: 10,
                                bottom: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  verticalSpace(10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: CustomText(
                                      "Order ID: " + mOrder.key!,
                                      fontSize: titleFontSize,
                                      isTitle: true,
                                      color: logoRed,
                                      isBold: true,
                                    ),
                                  ),
                                  verticalSpace(20),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        CustomText(
                                          "Shipping To",
                                          fontSize: headingFontSizeStyle,
                                          isTitle: true,
                                          isBold: true,
                                        ),
                                        verticalSpaceMedium,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black12,
                                                  width: 1,
                                                ),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Image.asset("assets/images/order_placed.png"),
                                            ),
                                            horizontalSpaceSmall,
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.person,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                      // CustomText(
                                                      //   "Shipping To",
                                                      //   fontSize: subtitleFontSize - 1,
                                                      //   color: Colors.grey,
                                                      //   isBold: true,
                                                      // ),
                                                      horizontalSpaceSmall,

                                                      CustomText(
                                                        (controller as CartController).userName,
                                                        color: Colors.black,
                                                        fontSize: subtitleFontSize + 1,
                                                        isBold: false,
                                                      ),
                                                    ],
                                                  ),
                                                  verticalSpaceSmall,
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.map,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                      // CustomText(
                                                      //   "Shipping Address    ",
                                                      //   fontSize: subtitleFontSize - 1,
                                                      //   color: Colors.grey,
                                                      //   isBold: true,
                                                      // ),
                                                      horizontalSpaceSmall,
                                                      Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: Get.width * 0.5),
                                                        child: CustomText(
                                                          mOrder.commonField?.customerDetails
                                                                  ?.address ??
                                                              "",
                                                          // align: TextAlign.start,
                                                          maxLines: 4,
                                                          color: Colors.black,
                                                          fontSize: subtitleFontSize + 1,
                                                          isBold: false,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  verticalSpaceTiny,
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.phone,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                      // CustomText(
                                                      //   "Shipping Address    ",
                                                      //   fontSize: subtitleFontSize - 1,
                                                      //   color: Colors.grey,
                                                      //   isBold: true,
                                                      // ),
                                                      horizontalSpaceSmall,
                                                      CustomText(
                                                        mOrder.commonField?.customerDetails
                                                                ?.customerPhone?.display ??
                                                            "",
                                                        align: TextAlign.start,
                                                        maxLines: 4,
                                                        color: Colors.black,
                                                        fontSize: subtitleFontSize + 1,
                                                        isBold: false,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  verticalSpace(20),
                                  if (!([6, 8, 9, 10, 11, 12].contains(mOrder.status?.id ?? -1)))
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    child: Column(
                                      children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              CustomText(
                                                "Arriving on",
                                                isBold: true,
                                                fontSize: subtitleFontSize + 1,
                                                color: Colors.black,
                                              ),
                                              CustomText(
                                                mOrder.deliveryDate!.substring(0, 10),
                                                fontSize: subtitleFontSize + 1,
                                                isBold: true,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  verticalSpace(20),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(curve15)),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(curve15),
                                                child: FadeInImage.assetNetwork(
                                                  width: 100,
                                                  height: 100,
                                                  fadeInCurve: Curves.easeIn,
                                                  placeholder:
                                                      "assets/images/product_preloading.png",
                                                  // image: "",
                                                  // todo : add product img here
                                                  image:
                                                      "$PRODUCT_PHOTO_BASE_URL/${productDetail!.key}/${productDetail!.photo!.photos!.first.name}-small.png",
                                                  imageErrorBuilder: (context, error, stackTrace) =>
                                                      Image.asset(
                                                          "assets/images/product_preloading.png",
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover),
                                                  fit: BoxFit.cover,
                                                )),
                                            horizontalSpaceSmall,
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CustomText(
                                                  productDetail?.name ?? "Product Name",
                                                  // todo : add product name here
                                                  // "Product name",
                                                  isBold: true,
                                                  maxLines: 3,
                                                  color: Colors.grey[800]!,
                                                  dotsAfterOverFlow: true,
                                                  fontSize: titleFontSize + 5,
                                                ),
                                                verticalSpaceSmall,
                                                CustomText(
                                                  "Qty: ${widget.mOrder.itemCost!.quantity}",
                                                  color: Colors.grey[800]!,
                                                  dotsAfterOverFlow: true,
                                                  fontSize: titleFontSize,
                                                ),
                                                if (widget.mOrder.variation!.size != null)
                                                  verticalSpaceSmall,
                                                if (widget.mOrder.variation!.size != null)
                                                  CustomText(
                                                    "Size: ${widget.mOrder.variation!.size}",
                                                    color: Colors.grey[800]!,
                                                    dotsAfterOverFlow: true,
                                                    fontSize: titleFontSize,
                                                  ),
                                                if (widget.mOrder.variation!.color != null)
                                                  verticalSpaceSmall,
                                                if (widget.mOrder.variation!.color != null)
                                                  CustomText(
                                                    "Color: ${widget.mOrder.variation!.color}",
                                                    color: Colors.grey[800]!,
                                                    dotsAfterOverFlow: true,
                                                    fontSize: titleFontSize,
                                                  ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      )),
                                  verticalSpace(30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              percent: (orderStatuses
                                                          .contains(mOrder.status?.id ?? -1)
                                                      ? ((orderStatuses.indexOf(
                                                                    widget.mOrder.status!.id ?? 0,
                                                                  ) +
                                                                  1) *
                                                              100) /
                                                          orderStatuses.length
                                                      : 100) /
                                                  100,
                                              padding: EdgeInsets.zero,
                                              linearStrokeCap: LinearStrokeCap.roundAll,
                                              linearGradient:
                                                  LinearGradient(colors: [textIconOrange, logoRed]),
                                            ),
                                          ),
                                        if (!([6, 8, 9, 10, 11, 12]
                                            .contains(mOrder.status?.id ?? -1)))
                                          verticalSpace(15),
                                        if (!([6, 8, 9, 10, 11, 12]
                                            .contains(mOrder.status?.id ?? -1)))
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
                                                mOrder.deliveryDate!.substring(0, 10),
                                                fontSize: subtitleFontSize - 1,
                                                isBold: true,
                                                color: Colors.grey[600]!,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  SectionDivider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(
                                              "Payment Method",
                                              fontSize: subtitleFontSize - 1,
                                              color: Colors.grey,
                                              isBold: true,
                                            ),
                                            CustomText(
                                              mOrder.commonField?.payment!.option!.name ?? "",
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(
                                              "Price",
                                              fontSize: subtitleFontSize - 1,
                                              color: Colors.grey,
                                              isBold: true,
                                            ),
                                            CustomText(
                                              '$rupeeUnicode${mOrder.itemCost?.cost?.toStringAsFixed(2)}',
                                              color: Colors.grey[600]!,
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
                                              "Quantity",
                                              fontSize: subtitleFontSize - 1,
                                              color: Colors.grey,
                                              isBold: true,
                                            ),
                                            CustomText(
                                              '${mOrder.itemCost?.quantity}',
                                              color: Colors.grey[600]!,
                                              fontSize: subtitleFontSize - 1,
                                              isBold: true,
                                            ),
                                          ],
                                        ),
                                        if ((mOrder.itemCost?.productDiscount?.cost ?? 0) != 0)
                                          verticalSpaceSmall,
                                        if ((mOrder.itemCost?.productDiscount?.cost ?? 0) != 0)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              CustomText(
                                                "Discount",
                                                fontSize: subtitleFontSize - 1,
                                                color: Colors.grey,
                                                isBold: true,
                                              ),
                                              CustomText(
                                                '$rupeeUnicode${mOrder.itemCost?.productDiscount?.cost?.toStringAsFixed(2)}',
                                                color: green,
                                                fontSize: subtitleFontSize - 1,
                                                isBold: true,
                                              ),
                                            ],
                                          ),
                                        // todo : add promocode discount here
                                        // if ((mOrder.orderCost?.promocodeDiscount
                                        //             ?.cost ??
                                        //         0) !=
                                        //     0)
                                        //   verticalSpaceSmall,
                                        // if ((mOrder.orderCost?.promocodeDiscount
                                        //             ?.cost ??
                                        //         0) !=
                                        //     0)
                                        //   Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.spaceBetween,
                                        //     children: <Widget>[
                                        //       CustomText(
                                        //         "Promocode Discount",
                                        //         fontSize: subtitleFontSize - 1,
                                        //         color: Colors.grey,
                                        //         isBold: true,
                                        //       ),
                                        //       CustomText(
                                        //         '$rupeeUnicode${mOrder.orderCost?.promocodeDiscount?.cost?.toStringAsFixed(2)}',
                                        //         color: green,
                                        //         fontSize: subtitleFontSize - 1,
                                        //         isBold: true,
                                        //       ),
                                        //     ],
                                        //   ),
                                        verticalSpaceSmall,
                                        Divider(
                                          color: Colors.grey[300],
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(
                                              "Total",
                                              fontSize: subtitleFontSize - 1,
                                              color: Colors.grey,
                                              isBold: true,
                                            ),
                                            CustomText(
                                              '$rupeeUnicode${mOrder.itemCost?.cost?.toStringAsFixed(2)}',
                                              color: Colors.grey[600]!,
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
                                              "GST",
                                              isBold: true,
                                              fontSize: subtitleFontSize - 1,
                                              color: Colors.grey,
                                            ),
                                            CustomText(
                                              '$rupeeUnicode${mOrder.itemCost?.gstCharges?.cost?.toStringAsFixed(2)}',
                                              color: green,
                                              fontSize: subtitleFontSize - 1,
                                              isBold: true,
                                            ),
                                          ],
                                        ),
                                        // todo : add delivery cost
                                        // verticalSpaceSmall,
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: <Widget>[
                                        //     CustomText(
                                        //       "Shipping Charge",
                                        //       isBold: true,
                                        //       fontSize: subtitleFontSize - 1,
                                        //       color: Colors.grey,
                                        //     ),
                                        //     CustomText(
                                        //       "$rupeeUnicode${(mOrder.commonField!.orderCost!.cost! - mOrder.itemCost!.gstCharges!.cost! - mOrder.itemCost!.cost!).toStringAsFixed(0)}",
                                        //       color: green,
                                        //       fontSize: subtitleFontSize - 1,
                                        //       isBold: true,
                                        //     ),
                                        //   ],
                                        // ),
                                        verticalSpaceSmall,
                                        Divider(
                                          color: Colors.grey[300],
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(
                                              "Sub Total",
                                              fontSize: titleFontSize + 2,
                                              isBold: true,
                                              color: Colors.black,
                                            ),
                                            CustomText(
                                              '$rupeeUnicode${(mOrder.itemCost?.cost ?? 0)  + (mOrder.itemCost?.gstCharges?.cost ?? 0)}',
                                              color: logoRed,
                                              fontSize: titleFontSize + 2,
                                              isBold: true,
                                            ),
                                          ],
                                        ),
                                        // verticalSpaceSmall,
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        //   children: <Widget>[
                                        //     Expanded(
                                        //       child: CustomText(
                                        //         "Delivery Status",
                                        //         fontSize: subtitleFontSize,
                                        //         isBold: true,
                                        //         color: Colors.grey,
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       child: CustomText(
                                        //         mOrder.status?.state ?? '-',
                                        //         align: TextAlign.end,
                                        //         color: textIconOrange,
                                        //         fontSize: subtitleFontSize + 2,
                                        //         isBold: true,
                                        //       ),
                                        //     ),
                                        //     verticalSpaceSmall,
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  if (!(<int>[9, 12].contains(mOrder.status?.id ?? -1))) ...[
                                    verticalSpace(50),
                                    Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: BorderSide(color: textIconOrange, width: 2)),
                                        ),
                                        onPressed: () async => await showModalBottomSheet(
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
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: InkWell(
                                            child: Text(
                                              "Returns & Refunds",
                                              style: TextStyle(
                                                  color: textIconOrange, fontWeight: FontWeight.bold),
                                            ),
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
