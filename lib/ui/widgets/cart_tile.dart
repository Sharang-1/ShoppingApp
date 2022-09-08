import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../controllers/base_controller.dart';
import '../../locator.dart';
import '../../models/cart.dart';
import '../../models/order_details.dart';
import '../../services/api/api_service.dart';
import '../../services/dialog_service.dart';
import '../../utils/lang/translation_keys.dart';
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
    Key? key,
    required this.item,
    required this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final APIService _apiService = locator<APIService>();
  final _controller = new TextEditingController();

  bool isPromoCodeApplied = false;
  String finalTotal = "0";
  String deliveryStatus = "";
  String promoCode = "";
  String promoCodeId = "";
  String promoCodeDiscount = "0";
  int quantity = 0;
  late Item item;
  late OrderDetails orderDetails;
  @override
  void initState() {
    item = widget.item;
    quantity = item.quantity! >= 1 ? item.quantity as int : 1;
    item.quantity = item.quantity! >= 1 ? item.quantity : 1;
    finalTotal =
        (item.product!.cost!.costToCustomer! * item.quantity!).toString();
    setUpOrderDetails();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setUpProductPrices() async {
    setState(() {
      finalTotal =
          (item.product!.cost!.costToCustomer! * quantity).toStringAsFixed(2);
    });
    orderDetails.total = rupeeUnicode + finalTotal;
  }

  void setUpOrderDetails() {
    orderDetails = OrderDetails(
      productName: widget.item.product!.name,
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
          (widget.item.quantity! * widget.item.product!.cost!.cost!).toString(),
      discount: "${widget.item.product!.discount.toString()} %",
      discountedPrice: rupeeUnicode +
          (((widget.item.product!.price! -
                      (widget.item.product!.price! *
                          widget.item.product!.discount! /
                          100)) *
                  (widget.item.quantity ?? 0))
              .toString()),
      convenienceCharges:
          '${widget.item.product?.cost?.convenienceCharges?.rate} %',
      gst:
          '$rupeeUnicode${((widget.item.quantity ?? 1) * (widget.item.product?.cost?.gstCharges?.cost ?? 0)).toStringAsFixed(2)} (${widget.item.product?.cost?.gstCharges?.rate}%)',
      deliveryCharges: "-",
      actualPrice:
          "$rupeeUnicode ${((widget.item.quantity ?? 1) * ((widget.item.product?.cost?.cost ?? 0) + (widget.item.product?.cost?.gstCharges?.cost ?? 0)) + (widget.item.product?.cost?.convenienceCharges?.cost ?? 0)).toStringAsFixed(2)}",
      saved:
          // ignore: deprecated_member_use
          "$rupeeUnicode ${(((widget.item.quantity ?? 1) * ((widget.item.product?.cost?.cost ?? 0) + (widget.item.product?.cost?.gstCharges?.cost ?? 0)) + (widget.item.product?.cost?.convenienceCharges?.cost ?? 0)) - (double.parse(finalTotal, (s) => 0))).toStringAsFixed(0)}",
      total: rupeeUnicode + finalTotal,
    );
  }

  void increseQty() {
    setState(() {
      item.quantity = item.quantity! + 1;
      quantity++;
      setUpProductPrices();
    });
  }

  void decreaseQty() {
    setState(() {
      item.quantity = item.quantity! - 1;
      quantity--;
      setUpProductPrices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(border: Border.all()),
          height: 150,
          child: CartProductTileUI(
            item: item,
            finalTotal: finalTotal,
            promoCode: promoCode,
            onRemove: () {
              onCartItemDelete();
            },
            promoCodeDiscount: promoCodeDiscount,
            isPromoCodeApplied: isPromoCodeApplied,
            proceedToOrder: proceedToOrder,
            increaseQty: increseQty,
            decreaseQty: decreaseQty,
            orderDetails: orderDetails,
          ),
        ),
        // verticalSpaceTiny,
        // Row(
        //   children: <Widget>[
        //     OutlinedButton(
        //       style: ElevatedButton.styleFrom(
        //         elevation: 0,
        //         primary: Colors.white,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //           side: BorderSide(
        //             color: logoRed,
        //           ),
        //         ),
        //       ),
        //       onPressed: applyCoupon,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 8),
        //         child: Row(
        //           children: [
        //             Image.asset(
        //               'assets/images/coupon_icon.png',
        //               // color: Colors.black,
        //               height: 30,
        //               width: 30,
        //             ),
        //             horizontalSpaceSmall,
        //             Text(
        //               APPLY_COUPON.tr,
        //               style: TextStyle(
        //                 color: logoRed,
        //                 fontSize: 12,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     horizontalSpaceSmall,
        //     Expanded(
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           elevation: 0,
        //           primary: lightGreen,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //         ),
        //         onPressed: proceedToOrder,
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(vertical: 8),
        //           child: Text(
        //             PROCEED_TO_ORDER.tr,
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 12,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
       
        Divider(
          color: Colors.grey[500],
        ),
      ],
    );
  }

  void proceedToOrder({int? qty, String? total}) async {
    BaseController.vibrate(duration: 50);
    final product =
        await _apiService.getProductById(productId: item.productId.toString());
    if ((product!.available ?? false) && (product.enabled ?? false))
      Navigator.push(
        context,
        PageTransition(
          child: SelectAddress(
            productId: item.productId.toString(),
            promoCode: promoCode,
            promoCodeId: promoCodeId,
            size: item.size ?? "",
            color: item.color ?? "",
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

  void applyCoupon({int? qty, String? total}) async {
    BaseController.vibrate(duration: 50);
    final product = await _apiService.getProductById(
        productId: item.productId.toString(), withCoupons: true);
    if ((product?.available ?? false) && (product!.enabled ?? false))
      Navigator.push(
        context,
        PageTransition(
          child: SelectPromocode(
            productId: item.productId.toString(),
            promoCode: promoCode,
            promoCodeId: promoCodeId,
            availableCoupons: product.coupons ?? [],
            size: item.size ?? "",
            color: item.color ?? "",
            qty: (qty ?? item.quantity) as int,
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
