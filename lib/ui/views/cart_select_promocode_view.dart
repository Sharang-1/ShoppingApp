import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/groupOrderData.dart';
import '../../locator.dart';
import '../../models/coupon.dart';
import '../../models/groupOrderModel.dart';
import '../../models/order_details.dart';
import '../../services/api/api_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';

class SelectPromocode extends StatefulWidget {
  final double finalTotal;
  final String productId;
  final String promoCode;
  final List<Coupon> availableCoupons;
  final String promoCodeId;
  final String size;
  final String color;
  final int qty;
  final int index;
  final OrderDetails orderDetails;

  const SelectPromocode({
    Key? key,
    required this.productId,
    required this.availableCoupons,
    required this.promoCode,
    required this.promoCodeId,
    required this.size,
    required this.color,
    required this.qty,
    required this.index,
    required this.finalTotal,
    required this.orderDetails,
  }) : super(key: key);

  @override
  _SelectPromocodeState createState() => _SelectPromocodeState();
}

class _SelectPromocodeState extends State<SelectPromocode> {
  String? couponRadioValue = "";
  String? couponGrpValue = "";
  final _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          SELECT_COUPON.tr,
          style: TextStyle(
            fontFamily: headingFont,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: appBarIconColor,
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: screenPadding,
          right: screenPadding,
          bottom: MediaQuery.of(context).padding.bottom + 4.0,
          top: 8.0,
        ),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CustomText(
              //   "${BaseController.formatPrice(num.parse(GroupOrderData.orderTotal.toString().replaceAll("₹", "")))}",
              //   fontSize: 14,
              //   color: logoRed,
              //   isBold: true,
              // ),
              // horizontalSpaceMedium,
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: applyPromoCode,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10,
                    ),
                    child: Text(
                      APPLY_COUPON.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                verticalSpace(10),
                const CutomStepper(
                  step: 1,
                ),
                verticalSpace(15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(curve15),
                      side: BorderSide(color: logoRed),
                    ),
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: ENTER_COUPON.tr,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
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
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: applyPromoCode,
                          child: Text(
                            APPLY.tr,
                            style: TextStyle(
                                color: darkRedSmooth,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(35),
                if (widget.availableCoupons.isEmpty)
                  Text("No Available coupon codes for this product!"),
                if (widget.availableCoupons.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/coupon.png',
                          height: 24,
                          width: 24,
                        ),
                        horizontalSpaceSmall,
                        Text(
                          COUPONS_FOR_YOU.tr,
                          style: TextStyle(
                            fontFamily: headingFont,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                verticalSpace(15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: List<Widget>.of(
                      widget.availableCoupons.map(
                        (Coupon c) => GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                couponGrpValue = couponRadioValue = c.code!;
                                _controller.text = c.code!;
                                // applyPromoCode();
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200]!,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Radio<String>(
                                      value: c.code ?? "",
                                      groupValue: couponGrpValue,
                                      onChanged: (val) {
                                        setState(() {
                                          couponGrpValue =
                                              couponRadioValue = val as String;
                                          _controller.text = val;
                                          // applyPromoCode();
                                        });
                                        print(val);
                                      },
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CustomText(
                                            c.name.toString(),
                                            color: Colors.grey[700]!,
                                            isBold: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Get FLAT Rs.${c.discount} off on order above Rs.${c.minimumOrderValue}.",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void applyPromoCode() async {
    if (_controller.text == "") return;
    FocusManager.instance.primaryFocus!.unfocus();
    final res = await locator<APIService>().applyPromocode(
      widget.productId.toString(),
      widget.qty,
      _controller.text.trim(),
      "",
    );
    if (res != null) {
      // _controller.text = "";

      OrderDetails orderDetails = widget.orderDetails;
      orderDetails.promocode = res.promocodeDiscount!.promocode ?? "";
      orderDetails.promocodeDiscount =
          '$rupeeUnicode${res.promocodeDiscount!.cost}';
      orderDetails.total = res.cost!.toStringAsFixed(2);
      // orderDetails.total = (res.cost! +
      //         ((res.productPrice! * res.gstCharges!.rate) / 100) -
      //         res.gstCharges!.cost)
      //     .toStringAsFixed(2);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(
          "🎉 Congratulation, You Saved Rs ${res.promocodeDiscount!.cost}",
          style: TextStyle(fontSize: 15),
        ),
      ));

      var idx = widget.index;

      GroupOrderData.cartProducts.clear();
      GroupOrderData.sellersList.clear();
      GroupOrderData.cartEstimateItems.clear();

      GroupOrderModel cartItem = GroupOrderModel(
        productId: widget.productId.toString(),
        variation: Variation(
          size: widget.size.toString(),
          // quantity: widget.quantity?.toInt(),
          color: widget.color.toString(),
        ),
        // orderQueue: OrderQueue(
        //   clientQueueId: (idx + 1).toString(),
        // ),
        clientQueueId: (idx + 1).toString(),
        promocode: _controller.text.trim(),
      );
      GroupOrderData.cartProducts.add(cartItem);

      Navigator.pop(context);

      // await Navigator.push(
      //   context,
      //   PageTransition(
      //       child: SelectAddress(
      //         products: [],

      //         // productId: widget.productId,
      //         // promoCode: res.promocodeDiscount!.promocode ?? "",
      //         // promoCodeId: res.promocodeDiscount!.promocodeId ?? "",
      //         // size: widget.size,
      //         // color: widget.color,
      //         // qty: widget.qty,
      //         // finalTotal: res.cost!.toStringAsFixed(2),
      //         // orderDetails: orderDetails,
      //       ),
      //       type: PageTransitionType.rightToLeft),
      // );
    } else {
      setState(() {
        _controller.text = "";
        couponGrpValue = null;
        couponRadioValue = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(INVALID_COUPON.tr)),
      );
    }
  }

  void proceedToOrder() {
    Navigator.pop(context);
    // Navigator.push(
    //   context,
    //   PageTransition(
    //     child: SelectAddress(
    //       products: GroupOrderData.cartProducts,
    //       estimateItems: GroupOrderData.cartEstimateItems,
    //       sellers: GroupOrderData.sellersList,
    //       payTotal: GroupOrderData.orderTotal,
    //     ),
    //     type: PageTransitionType.rightToLeft,
    //   ),
    // );
  }

  // void selectAddress() {
  //   Navigator.push(
  //     context,
  //     PageTransition(
  //         child: SelectAddress(
  //           products:[]
  //           // productId: widget.productId,
  //           // promoCode: widget.promoCode,
  //           // promoCodeId: widget.promoCodeId,
  //           // size: widget.size,
  //           // color: widget.color,
  //           // qty: widget.qty,
  //           // finalTotal: widget.finalTotal,
  //           // orderDetails: widget.orderDetails,
  //         ),
  //         type: PageTransitionType.rightToLeft),
  //   );
  // }
}
