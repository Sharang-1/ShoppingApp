import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/server_urls.dart';
import '../../models/cart.dart';
import '../../models/order_details.dart';
import '../../utils/stringUtils.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';
import 'order_details_bottomsheet.dart';

class CartProductTileUI extends StatefulWidget {
  final Item item;
  final bool isPromoCodeApplied;
  final String finalTotal;
  final String promoCode;
  final String promoCodeDiscount;
  final Function({int qty, String total}) proceedToOrder;
  final Function increaseQty;
  final Function decreaseQty;
  final Function onRemove;
  final OrderDetails orderDetails;

  CartProductTileUI({
    Key? key,
    required this.item,
    this.isPromoCodeApplied = true,
    this.finalTotal = "",
    this.promoCode = "",
    this.promoCodeDiscount = "",
    required this.increaseQty,
    required this.decreaseQty,
    required this.orderDetails,
    required this.proceedToOrder,
    required this.onRemove,
  }) : super(key: key);
  @override
  _CartProductTileUIState createState() => _CartProductTileUIState();
}

class _CartProductTileUIState extends State<CartProductTileUI> {
  late bool clicked;
  late double price;
  late double discount;
  late double deliveryCharges;
  late double discountedPrice;
  late String productImage;
  late OrderDetails orderDetails;

  @override
  void initState() {
    clicked = false;
    price = widget.item.product!.price as double;
    discount = (widget.item.product!.discount ?? 0) as double;
    productImage = widget.item.product!.photo?.photos?.elementAt(0).name ?? "";
    deliveryCharges = 0;
    discountedPrice = price - (price * discount / 100);

    orderDetails = widget.orderDetails;

    super.initState();
  }

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    updateDetails();
    super.didUpdateWidget(oldWidget);
  }

  void updateDetails({num? qty}) {
    orderDetails = OrderDetails(
      productName: widget.item.product!.name,
      qty: qty?.toString() ?? widget.item.quantity.toString(),
      size: widget.item.size != null && widget.item.size != ""
          ? (widget.item.size == 'N/A' ? '-' : widget.item.size)
          : "No Size given",
      color: widget.item.color != null && widget.item.color != ""
          ? widget.item.color
          : "-",
      promocode: widget.promoCode,
      promocodeDiscount: '$rupeeUnicode${widget.promoCodeDiscount}',
      price: rupeeUnicode +
          ((qty ?? widget.item.quantity)! * widget.item.product!.cost!.cost!)
              .toString(),
      discount: discount.toString() + "%",
      discountedPrice: rupeeUnicode +
          ((discountedPrice * (qty ?? widget.item.quantity!))).toString(),
      convenienceCharges:
          '${widget.item.product?.cost?.convenienceCharges?.rate} %',
      gst:
          '$rupeeUnicode${(((qty ?? widget.item.quantity) ?? 1) * (widget.item.product?.cost?.gstCharges?.cost ?? 0)).toStringAsFixed(2)} (${widget.item.product?.cost?.gstCharges?.rate}%)',
      deliveryCharges: "-",
      actualPrice:
          "$rupeeUnicode ${(((qty ?? widget.item.quantity) ?? 1) * ((widget.item.product?.cost?.cost ?? 0) + (widget.item.product?.cost?.gstCharges?.cost ?? 0)) + (widget.item.product?.cost?.convenienceCharges?.cost ?? 0)).toStringAsFixed(2)}",
      saved:
          // ignore: deprecated_member_use
          "$rupeeUnicode ${((((qty ?? widget.item.quantity) ?? 1) * ((widget.item.product?.cost?.cost ?? 0) + (widget.item.product?.cost?.gstCharges?.cost ?? 0)) + (widget.item.product?.cost?.convenienceCharges?.cost ?? 0)) - (double.parse(widget.finalTotal, (s) => 0))).toStringAsFixed(2)}",
      total: qty == null ? rupeeUnicode + widget.finalTotal : '-',
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
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
                      placeholder: "assets/images/product_preloading.png",
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
                                    orderDetails.productName ?? "",
                                  ),
                                  dotsAfterOverFlow: true,
                                  isTitle: true,
                                  isBold: true,
                                  fontSize: titleFontSize,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  widget.onRemove();
                                },
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
                                          num.parse(orderDetails.qty ?? "0");
                                      if (qty > 1)
                                        setState(() {
                                          qty--;
                                          widget.decreaseQty();
                                          updateDetails(qty: qty);
                                        });
                                      setUpProductPrices(qty as int? ?? 0);
                                    },
                                  ),
                                  horizontalSpaceTiny,
                                  CustomText(
                                    "${orderDetails.qty}",
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
                                          num.parse(orderDetails.qty ?? "0");
                                      setState(() {
                                        qty++;
                                        widget.increaseQty();
                                        updateDetails(qty: qty);
                                      });
                                      setUpProductPrices(qty as int? ?? 0);
                                    },
                                  ),
                                ],
                              ),
                              if ((double.parse(orderDetails.saved!
                                      .replaceAll(rupeeUnicode, ""))) >
                                  0)
                                CustomText(
                                  orderDetails.actualPrice ?? "",
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
                                "Size : ${orderDetails.size}",
                                dotsAfterOverFlow: true,
                                color: Colors.grey,
                                fontSize: subtitleFontSize - 2,
                              ),
                              CustomText(
                                orderDetails.total ?? "",
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
                                "Color : ${orderDetails.color}",
                                dotsAfterOverFlow: true,
                                color: Colors.grey,
                                fontSize: subtitleFontSize - 2,
                              ),
                              if ((double.parse(orderDetails.saved!
                                      .replaceAll(rupeeUnicode, ""))) >
                                  0)
                                CustomText(
                                  "You Saved: ${orderDetails.saved}",
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
              onTap: () {
                onTap();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                color: Colors.grey[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Product Details",
                      fontSize: 14,
                      isBold: true,
                      color: Colors.grey[500]!,
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
    setState(() {
      orderDetails.total = rupeeUnicode +
          (widget.item.product!.cost!.costToCustomer! * qty).toStringAsFixed(2);
    });
  }

  void onTap() {
    setState(() {
      clicked = true;
    });

    showModalBottomSheet<void>(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) => OrderDetailsBottomsheet(
        orderDetails: orderDetails,
        proceedToOrder: widget.proceedToOrder,
        isPromocodeApplied: widget.isPromoCodeApplied,
        onButtonPressed: () {},
      ),
    ).whenComplete(() {
      setState(() {
        clicked = false;
      });
    });
  }
}
