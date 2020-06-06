import 'package:compound/locator.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/cart_select_delivery_view.dart';
import 'package:compound/ui/widgets/CartProductTileUI.dart';
import 'package:flutter/material.dart';

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

    final price = widget.item.product.price;
    final discount = widget.item.product.discount;
    final discountedPrice = price - (price * discount / 100);

    quantity = widget.item.quantity >= 1 ? widget.item.quantity : 1;
    widget.item.quantity = widget.item.quantity >= 1 ? widget.item.quantity : 1;

    finalTotal = (discountedPrice * widget.item.quantity).toString();
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
        shippingCharges = res.shippingCharge.toString();
      });
    }
  }

  void applyPromoCode() async {
    if (_controller.text == "") return;
    final res = await _apiService.applyPromocode(
        widget.item.productId.toString(),
        widget.item.quantity,
        _controller.text,
        "");
    if (res != null) {
      setState(() {
        shippingCharges = res.shippingCharge.toString();
        finalTotal = res.cost.toString();
        promoCode = res.promocode;
        promoCodeDiscount = res.promocodeDiscount.toString();
        promoCodeId = res.promocodeId;
        isPromoCodeApplied = true;
      });

      _controller.text = "";

      Scaffold.of(context).showSnackBar(
        new SnackBar(content: Text("Promocode Applied Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 180,
          child: CartProductTileUI(
            item: widget.item,
            finalTotal: finalTotal,
            shippingCharges: shippingCharges,
            promoCode: promoCode,
            promoCodeDiscount: promoCodeDiscount,
            isPromoCodeApplied: isPromoCodeApplied,
            proceedToOrder: proceedToOrder,
          ),
        ),
        verticalSpaceMedium,
        SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 30,
                    bottom: 10,
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      labelText: '  Promo Code',
                      labelStyle: TextStyle(fontSize: 18),
                      alignLabelWithHint: true,
                      isDense: true,
                    ),
                    autofocus: false,
                    maxLines: 1,
                  ),
                ),
              ),
              FractionallySizedBox(
                heightFactor: 0.7,
                child: RaisedButton(
                  elevation: 5,
                  onPressed: applyPromoCode,
                  color: darkRedSmooth,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    // side: BorderSide(
                    //     color: Colors.black, width: 0.5)
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              elevation: 0,
              onPressed: onCartItemDelete,
              color: backgroundWhiteCreamColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: logoRed, width: 1.5),
              ),
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
              child: RaisedButton(
                elevation: 5,
                onPressed: proceedToOrder,
                color: green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
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

  void proceedToOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectAddress(
          productId: widget.item.productId.toString(),
          promoCode: promoCode,
          promoCodeId: promoCodeId,
          size: widget.item.size,
          color: widget.item.color,
          qty: widget.item.quantity,
          finalTotal: finalTotal,
        ),
      ),
    );
  }

  void onCartItemDelete() {
    widget.onDelete(widget.index);
  }
}
