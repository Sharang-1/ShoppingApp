import 'package:compound/controllers/base_controller.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/server_urls.dart';
import '../../models/cart.dart';
import '../../utils/stringUtils.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class CartProductTileUI extends StatefulWidget {
  final Item item;
  final bool isPromoCodeApplied;
  final String finalTotal;
  final String shippingCharges;
  final String promoCode;
  final String promoCodeDiscount;
  final Function({int qty, String total}) proceedToOrder;
  final Function increaseQty;
  final Function decreaseQty;
  final Function onRemove;

  CartProductTileUI({
    Key key,
    @required this.item,
    this.isPromoCodeApplied = true,
    this.finalTotal = "",
    this.shippingCharges = "",
    this.promoCode = "",
    this.promoCodeDiscount = "",
    this.increaseQty,
    this.decreaseQty,
    @required this.proceedToOrder,
    @required this.onRemove,
  }) : super(key: key);
  @override
  _CartProductTileUIState createState() => _CartProductTileUIState();
}

class _CartProductTileUIState extends State<CartProductTileUI> {
  bool clicked;
  double price;
  double discount;
  double deliveryCharges;
  double discountedPrice;
  String productImage;
  Map<String, String> orderSummaryDetails;

  static const orderSummaryDetails1 = [
    "Product Name",
    // "Seller",
    "Qty",
    "Size",
    "Color",
  ];
  static const orderSummaryDetails2 = [
    "Promo Code",
    "Promo Code Discount",
  ];
  static const orderSummaryDetails3 = [
    "Price",
    "Discount",
    "Discounted Price",
    "Convenience Charges",
    "GST",
    "Delivery Charges",
    "Total"
  ];

  @override
  void initState() {
    clicked = false;
    price = widget.item.product.price;
    discount = widget.item.product.discount ?? 0;
    productImage =
        widget.item.product.photo?.photos?.elementAt(0)?.name ?? null;
    deliveryCharges = 0;
    discountedPrice = price - (price * discount / 100);

    updateDetails();

    super.initState();
  }

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    updateDetails();
    super.didUpdateWidget(oldWidget);
  }

  void updateDetails({num qty}) {
    orderSummaryDetails = {
      "Product Name": widget.item.product.name,
      "Qty": qty?.toString() ?? widget.item.quantity.toString(),
      "Size": widget.item.size != null && widget.item.size != ""
          ? (widget.item.size == 'N/A' ? '-' : widget.item.size)
          : "No Size given",
      "Color": widget.item.color != null && widget.item.color != ""
          ? widget.item.color
          : "-",
      "Promo Code": widget.promoCode,
      "Promo Code Discount": '$rupeeUnicode${widget.promoCodeDiscount}',
      "Price": rupeeUnicode +
          ((qty ?? widget.item.quantity) * widget.item.product.cost.cost)
              .toString(),
      "Discount": discount.toString() + "%",
      "Discounted Price": rupeeUnicode +
          ((discountedPrice * (qty ?? widget.item.quantity)) ?? 0).toString(),
      "Convenience Charges":
          '${widget?.item?.product?.cost?.convenienceCharges?.rate} %',
      "GST":
          '$rupeeUnicode${(((qty ?? widget?.item?.quantity) ?? 1) * (widget?.item?.product?.cost?.gstCharges?.cost ?? 0))?.toStringAsFixed(2)} (${widget?.item?.product?.cost?.gstCharges?.rate}%)',
      "Delivery Charges": rupeeUnicode + widget.shippingCharges,
      "Actual Price":
          "$rupeeUnicode ${(((qty ?? widget?.item?.quantity) ?? 1) * ((widget?.item?.product?.cost?.cost ?? 0) + (widget?.item?.product?.cost?.gstCharges?.cost ?? 0)) + (widget?.item?.product?.cost?.convenienceCharges?.cost) + BaseController.deliveryCharge).toStringAsFixed(2)}",
      "Saved":
          // ignore: deprecated_member_use
          "$rupeeUnicode ${((((qty ?? widget?.item?.quantity) ?? 1) * ((widget?.item?.product?.cost?.cost ?? 0) + (widget?.item?.product?.cost?.gstCharges?.cost ?? 0)) + (widget?.item?.product?.cost?.convenienceCharges?.cost) + BaseController.deliveryCharge) - (double.parse(widget.finalTotal, (s) => 0) ?? 0)).toStringAsFixed(2)}",
      "Total": qty == null ? rupeeUnicode + widget.finalTotal : '-',
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: widget.proceedToOrder,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(curve15),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(curve10),
                    child: FadeInImage.assetNetwork(
                      width: 100,
                      fadeInCurve: Curves.easeIn,
                      placeholder: "assets\images\product_preloading.png",
                      image: productImage != null
                          ? '$PRODUCT_PHOTO_BASE_URL/${widget.item.productId}/$productImage-small.png'
                          : "https://images.unsplashr.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        "assets/images/product_preloading.png",
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          verticalSpaceTiny,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  capitalizeString(
                                      orderSummaryDetails["Product Name"]),
                                  dotsAfterOverFlow: true,
                                  isTitle: true,
                                  isBold: true,
                                  fontSize: titleFontSize,
                                ),
                              ),
                              InkWell(
                                onTap: widget.onRemove,
                                child: Icon(
                                  FontAwesomeIcons.trashAlt,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceTiny,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    "Qty : ",
                                    dotsAfterOverFlow: true,
                                    color: Colors.grey,
                                    fontSize: subtitleFontSize - 2,
                                  ),
                                  InkWell(
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: subtitleFontSize - 2,
                                      ),
                                    ),
                                    onTap: () {
                                      num qty =
                                          num.parse(orderSummaryDetails["Qty"]);
                                      if (qty > 1)
                                        setState(() {
                                          qty--;
                                          widget.decreaseQty();
                                          updateDetails(qty: qty);
                                        });
                                      setUpProductPrices(qty);
                                    },
                                  ),
                                  horizontalSpaceTiny,
                                  CustomText(
                                    "${orderSummaryDetails["Qty"]}",
                                    dotsAfterOverFlow: true,
                                    color: Colors.grey,
                                    fontSize: subtitleFontSize - 2,
                                  ),
                                  horizontalSpaceTiny,
                                  InkWell(
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: subtitleFontSize - 2,
                                      ),
                                    ),
                                    onTap: () {
                                      num qty =
                                          num.parse(orderSummaryDetails["Qty"]);
                                      setState(() {
                                        qty++;
                                        widget.increaseQty();
                                        updateDetails(qty: qty);
                                      });
                                      setUpProductPrices(qty);
                                    },
                                  ),
                                ],
                              ),
                              if ((double.parse(orderSummaryDetails["Saved"]
                                          .replaceAll(rupeeUnicode, "")) ??
                                      0) >
                                  0)
                                CustomText(
                                  orderSummaryDetails["Actual Price"],
                                  textStyle: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                          verticalSpaceTiny,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Size : ${orderSummaryDetails["Size"]}",
                                dotsAfterOverFlow: true,
                                color: Colors.grey,
                                fontSize: subtitleFontSize - 2,
                              ),
                              CustomText(
                                orderSummaryDetails["Total"],
                                color: Colors.black,
                                isBold: true,
                                fontSize: priceFontSize,
                              ),
                            ],
                          ),
                          verticalSpaceTiny,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Color : ${orderSummaryDetails["Color"]}",
                                dotsAfterOverFlow: true,
                                color: Colors.grey,
                                fontSize: subtitleFontSize - 2,
                              ),
                              if ((double.parse(orderSummaryDetails["Saved"]
                                          .replaceAll(rupeeUnicode, "")) ??
                                      0) >
                                  0)
                                CustomText(
                                  "You Saved: ${orderSummaryDetails["Saved"]}",
                                  color: textIconBlue,
                                  isBold: true,
                                  fontSize: 10,
                                ),
                            ],
                          ),
                          verticalSpaceSmall,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceSmall,
            InkWell(
              onTap: onTap,
              child: Container(
                color: Colors.grey[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Product Details",
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    Icon(
                      !clicked
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setUpProductPrices(int qty) async {
    final res = await locator<APIService>()
        .calculateProductPrice(widget.item.productId.toString(), qty);
    if (res != null) {
      setState(() {
        orderSummaryDetails["Total"] = rupeeUnicode +
            calculateTotalCost(
                widget.item.product.cost, qty, res.deliveryCharges.cost);
        orderSummaryDetails["Delivery Charges"] =
            res.deliveryCharges.cost.toString();
      });
    }
  }

  String calculateTotalCost(Cost cost, num quantity, num deliveryCharges) =>
      (((cost.cost -
                      (cost?.productDiscount?.cost ?? 0) +
                      (cost?.convenienceCharges?.cost ?? 0) +
                      (cost?.gstCharges?.cost ?? 0)) *
                  quantity) +
              deliveryCharges)
          .toStringAsFixed(2);

  void onTap() {
    setState(() {
      clicked = true;
    });

    showModalBottomSheet<void>(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return bottomSheetDetailsTable(
            titleFontSize,
            subtitleFontSize,
          );
        }).whenComplete(() {
      setState(() {
        clicked = false;
      });
    });
  }

  Widget bottomSheetDetailsTable(titleFontSize, subtitleFontSize) {
    return FractionallySizedBox(
      heightFactor: MediaQuery.of(context).size.height > 600
          ? MediaQuery.of(context).size.height > 800
              ? 0.75
              : 0.88
          : 0.92,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: appBarIconColor),
          centerTitle: true,
          title: Text(
            "Details",
            style: TextStyle(color: Colors.black, fontSize: 23),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.clear_circled_solid),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              color: Colors.grey[700],
              iconSize: 30,
            ),
            horizontalSpaceSmall
          ],
          backgroundColor: Colors.grey[300],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 30, 25, 10),
            child: Column(
              children: <Widget>[
                Table(
                    children: orderSummaryDetails1
                        .map((String key) {
                          return <TableRow>[
                            TableRow(children: [
                              CustomText(
                                key,
                                color: Colors.grey,
                                fontSize: titleFontSize,
                              ),
                              CustomText(
                                orderSummaryDetails[key],
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              )
                            ]),
                            TableRow(children: [
                              verticalSpace(8),
                              verticalSpace(8),
                            ]),
                          ];
                        })
                        .expand((element) => element)
                        .toList()),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Divider(),
                ),
                if (widget.isPromoCodeApplied)
                  Table(
                      children: orderSummaryDetails2
                          .map((String key) {
                            return <TableRow>[
                              TableRow(children: [
                                CustomText(
                                  key,
                                  color: Colors.grey,
                                  fontSize: titleFontSize,
                                ),
                                CustomText(
                                  orderSummaryDetails[key],
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                )
                              ]),
                              TableRow(children: [
                                verticalSpace(8),
                                verticalSpace(8),
                              ]),
                            ];
                          })
                          .expand((element) => element)
                          .toList()),
                if (widget.isPromoCodeApplied)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Divider(),
                  ),
                Table(
                  children: orderSummaryDetails3
                      .map(
                        (String key) {
                          return key == "Total"
                              ? <TableRow>[
                                  TableRow(
                                    children: [
                                      verticalSpaceSmall,
                                      verticalSpaceSmall
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Divider(thickness: 1),
                                      Divider(thickness: 1),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpaceSmall,
                                      verticalSpaceSmall
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      CustomText(key,
                                          isBold: true,
                                          color: Colors.grey,
                                          fontSize: titleFontSize),
                                      CustomText(
                                        orderSummaryDetails[key],
                                        fontSize: titleFontSize + 2,
                                        color: lightGreen,
                                        isBold: true,
                                      )
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpace(8),
                                      verticalSpace(8),
                                    ],
                                  ),
                                ]
                              : <TableRow>[
                                  TableRow(
                                    children: [
                                      CustomText(
                                        key,
                                        color: Colors.grey,
                                        fontSize: titleFontSize,
                                      ),
                                      CustomText(
                                        key == "Delivery Charges" &&
                                                orderSummaryDetails[key] ==
                                                    "0.0"
                                            ? "Free Delivery"
                                            : orderSummaryDetails[key]
                                                .toString(),
                                        fontSize: subtitleFontSize,
                                        color: key == "Delivery Charges"
                                            ? orderSummaryDetails[key] == "0.0"
                                                ? green
                                                : Colors.black
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpace(8),
                                      verticalSpace(8),
                                    ],
                                  ),
                                  if (key == "Discounted Price" &&
                                      widget.isPromoCodeApplied)
                                    TableRow(
                                      children: [
                                        CustomText(
                                          "Price After Promocode Applied",
                                          color: Colors.grey,
                                          fontSize: titleFontSize,
                                        ),
                                        CustomText(
                                          rupeeUnicode +
                                              (double.parse(orderSummaryDetails[
                                                              "Discounted Price"]
                                                          .replaceAll(
                                                              rupeeUnicode,
                                                              " ")) -
                                                      double.parse(widget
                                                          .promoCodeDiscount))
                                                  .toStringAsFixed(2),
                                          fontSize: subtitleFontSize,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                  if (key == "Discounted Price" &&
                                      widget.isPromoCodeApplied)
                                    TableRow(
                                      children: [
                                        verticalSpace(8),
                                        verticalSpace(8),
                                      ],
                                    ),
                                ];
                        },
                      )
                      .expand((element) => element)
                      .toList(),
                ),
                verticalSpaceMedium,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: lightGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            // side: BorderSide(
                            //     color: Colors.black, width: 0.5)
                          ),
                        ),
                        onPressed: () => widget.proceedToOrder(
                            qty: int.parse(orderSummaryDetails["Qty"]),
                            total: orderSummaryDetails["Total"]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            orderSummaryDetails["Total"] +
                                "\t" +
                                "Proceed to Order ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
