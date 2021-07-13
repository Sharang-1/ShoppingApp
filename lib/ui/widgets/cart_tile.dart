import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../controllers/base_controller.dart';
import '../../locator.dart';
import '../../models/cart.dart';
import '../../models/order_details.dart';
import '../../services/api/api_service.dart';
import '../../services/dialog_service.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import '../views/cart_select_delivery_view.dart';
import '../views/cart_select_promocode_view.dart';
import 'cart_product_tile_ui.dart';

class CartTile extends StatefulWidget {
  final Item item;
  final Function onDelete;
  final int index;

  const CartTile({
    Key key,
    this.item,
    this.onDelete,
    this.index,
  }) : super(key: key);

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final APIService _apiService = locator<APIService>();
  final _controller = new TextEditingController();

  bool isPromoCodeApplied = false;
  String finalTotal = "-";
  String shippingCharges = "-";
  String deliveryStatus = "";
  String promoCode = "";
  String promoCodeId = "";
  String promoCodeDiscount = "0";
  int quantity = 0;
  Item item;
  OrderDetails orderDetails;

  @override
  void initState() {
    item = widget.item;
    quantity = item.quantity >= 1 ? item.quantity : 1;
    item.quantity = item.quantity >= 1 ? item.quantity : 1;

    // finalTotal = (discountedPrice * item.quantity).toString();
    setUpOrderDetails();
    setUpProductPrices();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setUpProductPrices() async {
    final res = await _apiService.calculateProductPrice(
        item.productId.toString(), quantity);
    if (res != null) {
      setState(() {
        finalTotal = calculateTotalCost(
            item.product.cost, item.quantity, res.deliveryCharges.cost);
        shippingCharges = res.deliveryCharges.cost.toString();
      });
    }
    orderDetails.total = rupeeUnicode + finalTotal;
    orderDetails.deliveryCharges = rupeeUnicode + shippingCharges;
  }

  String calculateTotalCost(Cost cost, num quantity, num deliveryCharges) =>
      (((cost.cost -
                      (cost?.productDiscount?.cost ?? 0) +
                      (cost?.convenienceCharges?.cost ?? 0) +
                      (cost?.gstCharges?.cost ?? 0)) *
                  quantity) +
              deliveryCharges)
          .toStringAsFixed(2);

  void setUpOrderDetails() {
    orderDetails = OrderDetails(
      productName: widget.item.product.name,
      qty: widget.item.quantity.toString(),
      size: widget.item.size != null && widget.item.size != ""
          ? (widget.item.size == 'N/A' ? '-' : widget.item.size)
          : "No Size given",
      color: widget.item.color != null && widget.item.color != ""
          ? widget.item.color
          : "-",
      promocode: promoCode,
      promocodeDiscount: '$rupeeUnicode$promoCodeDiscount',
      price: rupeeUnicode +
          (widget.item.quantity * widget.item.product.cost.cost).toString(),
      discount: "${widget.item.product.discount.toString()} %",
      discountedPrice: rupeeUnicode +
          (((widget.item.product.price -
                          (widget.item.product.price *
                              widget.item.product.discount /
                              100)) *
                      (widget.item.quantity)) ??
                  0)
              .toString(),
      convenienceCharges:
          '${widget?.item?.product?.cost?.convenienceCharges?.rate} %',
      gst:
          '$rupeeUnicode${((widget?.item?.quantity ?? 1) * (widget?.item?.product?.cost?.gstCharges?.cost ?? 0))?.toStringAsFixed(2)} (${widget?.item?.product?.cost?.gstCharges?.rate}%)',
      deliveryCharges: rupeeUnicode + shippingCharges,
      actualPrice:
          "$rupeeUnicode ${((widget?.item?.quantity ?? 1) * ((widget?.item?.product?.cost?.cost ?? 0) + (widget?.item?.product?.cost?.gstCharges?.cost ?? 0)) + (widget?.item?.product?.cost?.convenienceCharges?.cost) + BaseController.deliveryCharge).toStringAsFixed(2)}",
      saved:
          // ignore: deprecated_member_use
          "$rupeeUnicode ${(((widget?.item?.quantity ?? 1) * ((widget?.item?.product?.cost?.cost ?? 0) + (widget?.item?.product?.cost?.gstCharges?.cost ?? 0)) + (widget?.item?.product?.cost?.convenienceCharges?.cost) + BaseController.deliveryCharge) - (double.parse(finalTotal, (s) => 0) ?? 0)).toStringAsFixed(2)}",
      total: rupeeUnicode + finalTotal,
    );
  }

  void increseQty() {
    setState(() {
      item.quantity++;
      quantity++;
      setUpProductPrices();
    });
  }

  void decreaseQty() {
    setState(() {
      item.quantity--;
      quantity--;
      setUpProductPrices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 150,
          child: CartProductTileUI(
            item: item,
            finalTotal: finalTotal,
            shippingCharges: shippingCharges,
            promoCode: promoCode,
            onRemove: onCartItemDelete,
            promoCodeDiscount: promoCodeDiscount,
            isPromoCodeApplied: isPromoCodeApplied,
            proceedToOrder: proceedToOrder,
            increaseQty: increseQty,
            decreaseQty: decreaseQty,
            orderDetails: orderDetails,
            // deliveryStatus: proceedToOrder,
          ),
        ),
        verticalSpaceTiny,
        Row(
          children: <Widget>[
            OutlinedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: logoRed,
                  ),
                ),
              ),
              onPressed: applyCoupon,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/coupon.png',
                      height: 20,
                      width: 20,
                    ),
                    horizontalSpaceSmall,
                    Text(
                      "Apply Coupon",
                      style: TextStyle(
                        color: logoRed,
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: proceedToOrder,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Proceed to Order ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.grey[500],
        ),
      ],
    );
  }

  void proceedToOrder({int qty, String total}) async {
    BaseController.vibrate(duration: 50);
    final product =
        await _apiService.getProductById(productId: item.productId.toString());
    if (product.available && product.enabled)
      Navigator.push(
        context,
        PageTransition(
          child: SelectAddress(
            productId: item.productId.toString(),
            promoCode: promoCode,
            promoCodeId: promoCodeId,
            size: item.size,
            color: item.color,
            qty: qty ?? quantity,
            finalTotal: total ?? finalTotal,
            orderDetails: orderDetails,
          ),
          type: PageTransitionType.rightToLeft,
        ),
      );
    else
      DialogService.showCustomDialog(AlertDialog(
        content: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Sorry, product is currently not available",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ));
  }

  void applyCoupon({int qty, String total}) async {
    BaseController.vibrate(duration: 50);
    final product = await _apiService.getProductById(
        productId: item.productId.toString(), withCoupons: true);
    if (product.available && product.enabled)
      Navigator.push(
        context,
        PageTransition(
          child: SelectPromocode(
            productId: item.productId.toString(),
            promoCode: promoCode,
            promoCodeId: promoCodeId,
            availableCoupons: product.coupons,
            size: item.size,
            color: item.color,
            qty: qty ?? item.quantity,
            finalTotal: total ?? finalTotal,
            orderDetails: orderDetails,
          ),
          type: PageTransitionType.rightToLeft,
        ),
      );
    else
      DialogService.showCustomDialog(AlertDialog(
        content: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Sorry, product is currently not available",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ));
  }

  void onCartItemDelete() {
    widget.onDelete(widget.index);
  }
}
