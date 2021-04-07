import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../locator.dart';
import '../../models/cart.dart';
import '../../services/api/api_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../views/cart_select_delivery_view.dart';
import 'CartProductTileUI.dart';

class CartTileUI extends StatefulWidget {
  final Item item;
  final Function onDelete;
  final int index;

  const CartTileUI({
    Key key,
    this.item,
    this.onDelete,
    this.index,
  }) : super(key: key);

  @override
  _CartTileUIState createState() => _CartTileUIState();
}

class _CartTileUIState extends State<CartTileUI> {
  final APIService _apiService = locator<APIService>();
  final _controller = new TextEditingController();

  bool isPromoCodeApplied = false;
  String finalTotal = "-";
  String shippingCharges = "-";
  String deliveryStatus = "";
  String promoCode = "No Promocode";
  String promoCodeId = "";
  String promoCodeDiscount = "0";
  int quantity = 0;

  @override
  void initState() {
    // {
    //   "productId": "630644",
    //   "productPrice": 500.0,
    //   "quantity": 4,
    //   "shippingCharge": 0.0,
    //   "cost": 2000.0,
    //   "costToSeller": 2000.0
    // }

    // final price = widget.item.product.price;
    // final discount = widget.item.product.discount;
    // final discountedPrice = price - (price * discount / 100);

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

  void applyPromoCode() async {
    if (_controller.text == "") return;
    FocusManager.instance.primaryFocus.unfocus();
    final res = await _apiService.applyPromocode(
        widget.item.productId.toString(),
        widget.item.quantity,
        _controller.text,
        "");
    if (res != null) {
      setState(() {
        shippingCharges = res.deliveryCharges.cost.toString();
        finalTotal = res.cost.toString();
        promoCode = res.promocodeDiscount.promocode;
        promoCodeDiscount = res.promocodeDiscount.cost.toString();
        promoCodeId = res.promocodeDiscount.promocodeId;
        isPromoCodeApplied = true;
      });

      _controller.text = "";

      ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(content: Text("Promocode Applied Successfully!")),
      );
    } else {
      _controller.text = "";

      ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(content: Text("Invalid Promocode")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 140,
          child: CartProductTileUI(
            item: widget.item,
            finalTotal: finalTotal,
            shippingCharges: shippingCharges,
            promoCode: promoCode,
            promoCodeDiscount: promoCodeDiscount,
            isPromoCodeApplied: isPromoCodeApplied,
            proceedToOrder: proceedToOrder,
            // deliveryStatus: proceedToOrder,
          ),
        ),
        if (!isPromoCodeApplied) verticalSpaceSmall,
        if (!isPromoCodeApplied)
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(curve15),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              child: SizedBox(
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: 'Enter Promo Code',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              autofocus: false,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.all(0),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              // side: BorderSide(
                              //     color: Colors.black, width: 0.5)
                            ),
                          ),
                          onPressed: applyPromoCode,
                          child: Text(
                            "Apply",
                            style: TextStyle(
                                color: darkRedSmooth,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ))),
        verticalSpaceTiny,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: backgroundWhiteCreamColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: logoRed, width: 1.5),
                ),
              ),
              onPressed: onCartItemDelete,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Remove",
                  style: TextStyle(color: logoRed),
                ),
              ),
            ),
            horizontalSpaceMedium,
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: proceedToOrder,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
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
        ),
      ],
    );
  }

  void proceedToOrder() async {
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
      Get.dialog(AlertDialog(
        content: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Sorry, product is currently not available", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ));
  }

  void onCartItemDelete() {
    widget.onDelete(widget.index);
  }
}
