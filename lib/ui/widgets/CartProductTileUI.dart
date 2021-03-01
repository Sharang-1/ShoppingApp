import 'package:compound/constants/server_urls.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartProductTileUI extends StatefulWidget {
  final Item item;
  final bool isPromoCodeApplied;
  final String finalTotal;
  final String shippingCharges;
  final String promoCode;
  final String promoCodeDiscount;
  final Function proceedToOrder;

  CartProductTileUI({
    Key key,
    @required this.item,
    this.isPromoCodeApplied = true,
    this.finalTotal = "",
    this.shippingCharges = "",
    this.promoCode = "",
    this.promoCodeDiscount = "",
    @required this.proceedToOrder,
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
    "GST Tax",
    "Delivery Charges",
    "Total"
  ];

  @override
  void initState() {
    clicked = false;
    price = widget.item.product.price;
    discount = widget.item.product.discount;
    productImage =
        widget.item.product.photo?.photos?.elementAt(0)?.name ?? null;
    deliveryCharges = 0;
    discountedPrice = price - (price * discount / 100);

    orderSummaryDetails = {
      "Product Name": widget.item.product.name,
      // "Seller": "Nike",
      "Qty": widget.item.quantity.toString(),
      "Size": widget.item.size != null && widget.item.size != ""
          ? widget.item.size
          : "No Size given",
      "Color": widget.item.color != null && widget.item.color != ""
          ? widget.item.color
          : "No Color given",
      "Promo Code": widget.promoCode,
      "Promo Code Discount": '$rupeeUnicode${widget.promoCodeDiscount}',
      "Price": rupeeUnicode +
          (widget.item.quantity * widget.item.product.cost.cost).toString(),
      "Discount": discount.toString() + "%",
      "Discount Price":
          rupeeUnicode + (discountedPrice * widget.item.quantity).toString(),
      "Convenience Charges":
          '${widget?.item?.product?.cost?.convenienceCharges?.rate} %',
      "GST Tax":
          '$rupeeUnicode${widget?.item?.product?.cost?.gstCharges?.cost?.toStringAsFixed(2)} (${widget?.item?.product?.cost?.gstCharges?.rate}%)',
      "Delivery Charges": rupeeUnicode + widget.shippingCharges,
      "Total": rupeeUnicode + widget.finalTotal,
    };

    super.initState();
  }

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    orderSummaryDetails = {
      "Product Name": widget.item.product.name,
      // "Seller": "Nike",
      "Qty": widget.item.quantity.toString(),
      "Size": widget.item.size != null && widget.item.size != ""
          ? widget.item.size
          : "No Size given",
      "Color": widget.item.color != null && widget.item.color != ""
          ? widget.item.color
          : "No Color given",
      "Promo Code": widget.promoCode,
      "Promo Code Discount": '$rupeeUnicode${widget.promoCodeDiscount}',
      "Price": rupeeUnicode + price.toString(),
      "Discount": discount.toString() + "%",
      "Discounted Price":
          rupeeUnicode + (discountedPrice * widget.item.quantity).toString(),
      "Convenience Charges":
          '${widget?.item?.product?.cost?.convenienceCharges?.rate} %',
      "GST Tax":
          '$rupeeUnicode${widget?.item?.product?.cost?.gstCharges?.cost?.toStringAsFixed(2)} (${widget?.item?.product?.cost?.gstCharges?.rate}%)',
      "Delivery Charges": rupeeUnicode + widget.shippingCharges,
      "Total": rupeeUnicode + widget.finalTotal,
    };

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(curve15),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(curve15),
              child: FadeInImage.assetNetwork(
                width: 120,
                fadeInCurve: Curves.easeIn,
                placeholder: "assets\images\product_preloading.png",
                image: productImage != null
                    ? '$PRODUCT_PHOTO_BASE_URL/${widget.item.productId}/$productImage'
                    : "https://images.unsplashr.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/product_preloading.png",
                  width: 120,
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
                    CustomText(
                      orderSummaryDetails["Product Name"],
                      dotsAfterOverFlow: true,
                      isTitle: true,
                      isBold: true,
                      fontSize: titleFontSize,
                    ),
                    // verticalSpaceTiny,
                    // CustomText(
                    //   "By Nike",
                    //   color: Colors.grey,
                    //   dotsAfterOverFlow: true,
                    //   fontSize: subtitleFontSize - 2,
                    // ),
                    verticalSpaceSmall,
                    Row(
                      children: <Widget>[
                        CustomText(
                          orderSummaryDetails["Total"],
                          color: darkRedSmooth,
                          isBold: true,
                          fontSize: priceFontSize,
                        ),
                        horizontalSpaceTiny,
                        orderSummaryDetails["Total"]
                                    .replaceAll(rupeeUnicode, "") !=
                                orderSummaryDetails["Price"]
                                    .replaceAll(rupeeUnicode, "")
                            ? Expanded(
                                child: Text(
                                  orderSummaryDetails["Price"],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: priceFontSize - 2,
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                    verticalSpaceTiny,
                    CustomText(
                      "Qty : ${orderSummaryDetails["Qty"]} Piece(s)",
                      dotsAfterOverFlow: true,
                      color: Colors.grey,
                      fontSize: subtitleFontSize - 2,
                    ),
                    verticalSpaceTiny,
                    CustomText(
                      "Size : ${orderSummaryDetails["Size"]}",
                      dotsAfterOverFlow: true,
                      color: Colors.grey,
                      fontSize: subtitleFontSize - 2,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                !clicked ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.grey,
              ),
              onPressed: () {
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
              },
            )
          ],
        ),
      ),
    );
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
        backgroundColor: Colors.white,
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
                                      CustomText(orderSummaryDetails[key],
                                          fontSize: titleFontSize + 2,
                                          color: darkRedSmooth,
                                          isBold: true)
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
                                              (double.parse(orderSummaryDetails["Discounted Price"]
                                                          .replaceAll(
                                                              rupeeUnicode,
                                                              " ")) -
                                                          double.parse(widget.promoCodeDiscount))
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
                      child: RaisedButton(
                        elevation: 5,
                        onPressed: widget.proceedToOrder,
                        color: green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          // side: BorderSide(
                          //     color: Colors.black, width: 0.5)
                        ),
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
