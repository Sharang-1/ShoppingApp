import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';

import '../../constants/server_urls.dart';
import '../../locator.dart';
import '../../models/cart.dart';
import '../../models/order_details.dart';
import '../../services/api/api_service.dart';
import '../../utils/stringUtils.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class NewCartTile extends StatefulWidget {
  final Item item;
  final Function onDelete;
  final int index;
  const NewCartTile({
    Key? key,
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

class CartProductTileNew extends StatefulWidget {
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
  const CartProductTileNew({
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
  State<CartProductTileNew> createState() => _CartProductTileNewState();
}

class _CartProductTileNewState extends State<CartProductTileNew> {
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
      color: widget.item.color != null && widget.item.color != "" ? widget.item.color : "-",
      promocode: widget.promoCode,
      promocodeDiscount: '$rupeeUnicode${widget.promoCodeDiscount}',
      price: rupeeUnicode +
          ((qty ?? widget.item.quantity)! * widget.item.product!.cost!.cost!).toString(),
      discount: discount.toString() + "%",
      discountedPrice:
          rupeeUnicode + ((discountedPrice * (qty ?? widget.item.quantity!))).toString(),
      convenienceCharges: '${widget.item.product?.cost?.convenienceCharges?.rate} %',
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
    return Container(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(curve10),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black12,
      //         blurRadius: 5,
      //       ),
      //     ],
      //     color: Color(0xffeeeeee),
      //     ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(curve10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ],
                color: Color(0xffeeeeee),
                ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(curve10),
              child: FadeInImage.assetNetwork(
                width: 100,
                fadeInCurve: Curves.easeIn,
                placeholder: "assets/images/product_preloading.png",
                image: productImage != null
                    ? '$PRODUCT_PHOTO_BASE_URL/${widget.item.productId}/$productImage-small.png'
                    : "https://images.unsplashr.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/product_preloading.png",
                  width: 100,
                  fit: BoxFit.fitWidth,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          horizontalSpaceSmall,
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 190,
                child: CustomText(
                    capitalizeString(
                      orderDetails.productName ?? "",
                    ),
                    maxLines: 2,
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
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: logoRed,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],)
          ]),
        ],
      ),
    );
  }
}
