import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../models/cart.dart';
import '../../models/order_details.dart';
import '../../services/api/api_service.dart';
import '../shared/ui_helpers.dart';

class NewCartTile extends StatefulWidget {
  final Item item;
  final Function onDelete;
  final int index;
  const NewCartTile({Key? key,
  required this.item,
    required this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  State<NewCartTile> createState() => _NewCartTileState();
}

class _NewCartTileState extends State<NewCartTile> {
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
    finalTotal = (item.product!.cost!.costToCustomer! * item.quantity!).toString();
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
      finalTotal = (item.product!.cost!.costToCustomer! * quantity).toStringAsFixed(2);
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
      color: widget.item.color != null && widget.item.color != "" ? widget.item.color : "-",
      promocode: promoCode,
      promocodeDiscount: '$rupeeUnicode$promoCodeDiscount',
      price: rupeeUnicode + (widget.item.quantity! * widget.item.product!.cost!.cost!).toString(),
      discount: "${widget.item.product!.discount.toString()} %",
      discountedPrice: rupeeUnicode +
          (((widget.item.product!.price! -
                      (widget.item.product!.price! * widget.item.product!.discount! / 100)) *
                  (widget.item.quantity ?? 0))
              .toString()),
      convenienceCharges: '${widget.item.product?.cost?.convenienceCharges?.rate} %',
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
    return Container();
  }
}
