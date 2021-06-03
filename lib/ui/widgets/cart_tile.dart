import 'package:compound/models/promoCode.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../controllers/base_controller.dart';
import '../../locator.dart';
import '../../models/cart.dart';
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

  @override
  void initState() {
    quantity = widget.item.quantity >= 1 ? widget.item.quantity : 1;
    widget.item.quantity = widget.item.quantity >= 1 ? widget.item.quantity : 1;

    // finalTotal = (discountedPrice * widget.item.quantity).toString();
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
        widget.item.productId.toString(), widget.item.quantity);
    if (res != null) {
      setState(() {
        finalTotal = calculateTotalCost(widget.item.product.cost,
            widget.item.quantity, res.deliveryCharges.cost);
        shippingCharges = res.deliveryCharges.cost.toString();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 150,
          child: CartProductTileUI(
            item: widget.item,
            finalTotal: finalTotal,
            shippingCharges: shippingCharges,
            promoCode: promoCode,
            onRemove: onCartItemDelete,
            promoCodeDiscount: promoCodeDiscount,
            isPromoCodeApplied: isPromoCodeApplied,
            proceedToOrder: proceedToOrder,

            // deliveryStatus: proceedToOrder,
          ),
        ),
        verticalSpaceTiny,
        Row(
          children: <Widget>[
            OutlinedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Colors.yellowAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: applyCoupon,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "🎁 Apply Coupon",
                  style: TextStyle(
                    color: textIconBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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

  void proceedToOrder() async {
    BaseController.vibrate(duration: 50);
    final product = await _apiService.getProductById(
        productId: widget.item.productId.toString());
    if (product.available && product.enabled)
      Navigator.push(
        context,
        PageTransition(
          child: SelectAddress(
            productId: widget.item.productId.toString(),
            promoCode: promoCode,
            promoCodeId: promoCodeId,
            size: widget.item.size,
            color: widget.item.color,
            qty: widget.item.quantity,
            finalTotal: finalTotal,
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

  void applyCoupon() async {
    BaseController.vibrate(duration: 50);
    final product = await _apiService.getProductById(
        productId: widget.item.productId.toString());
    if (product.available && product.enabled)
      Navigator.push(
        context,
        PageTransition(
          child: SelectPromocode(
            productId: widget.item.productId.toString(),
            promoCode: promoCode,
            promoCodeId: promoCodeId,
            //TODO: Add promocodes
            availablePromoCodes: [
              PromoCode(
                promocodeDiscount: PromocodeDiscount(
                    cost: 10, promocode: "test", promocodeId: "35450188"),
              ),
              PromoCode(
                promocodeDiscount: PromocodeDiscount(
                    cost: 20, promocode: "test2", promocodeId: "35451361"),
              ),
              PromoCode(
                promocodeDiscount: PromocodeDiscount(
                    cost: 14, promocode: "test3", promocodeId: "35451500"),
              ),
            ],
            size: widget.item.size,
            color: widget.item.color,
            qty: widget.item.quantity,
            finalTotal: finalTotal,
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
