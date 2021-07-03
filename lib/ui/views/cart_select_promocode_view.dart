import 'package:compound/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../locator.dart';
import '../../models/coupon.dart';
import '../../services/api/api_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';
import 'cart_select_delivery_view.dart';

class SelectPromocode extends StatefulWidget {
  final String finalTotal;
  final String productId;
  final String promoCode;
  final List<Coupon> availableCoupons;
  final String promoCodeId;
  final String size;
  final String color;
  final int qty;

  const SelectPromocode({
    Key key,
    @required this.productId,
    @required this.availableCoupons,
    @required this.promoCode,
    @required this.promoCodeId,
    @required this.size,
    @required this.color,
    @required this.qty,
    @required this.finalTotal,
  }) : super(key: key);

  @override
  _SelectPromocodeState createState() => _SelectPromocodeState();
}

class _SelectPromocodeState extends State<SelectPromocode> {
  String couponRadioValue;
  String couponGrpValue;
  final _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Select Coupon",
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
          bottom: 8.0,
          top: 8.0,
        ),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                //         onTap: () async {
                //           await showModalBottomSheet<void>(
                // clipBehavior: Clip.antiAlias,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(30),
                //     topRight: Radius.circular(30),
                //   ),
                // ),
                // isScrollControlled: true,
                // context: context,
                // builder: (context) {
                //   return bottomSheetDetailsTable(
                //     titleFontSize,
                //     subtitleFontSize,
                //   );
                // });
                // },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "${BaseController.formatPrice(num.parse(widget.finalTotal.replaceAll("₹", "")))}",
                      fontSize: 12,
                      isBold: true,
                      // color: lightGreen,
                    ),
                    // CustomText(
                    //   "View Details",
                    //   fontSize: 12,
                    // ),
                  ],
                ),
              ),
              horizontalSpaceMedium,
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: SelectAddress(
                            productId: widget.productId,
                            promoCode: widget.promoCode,
                            promoCodeId: widget.promoCodeId,
                            size: widget.size,
                            color: widget.color,
                            qty: widget.qty,
                            finalTotal: widget.finalTotal,
                          ),
                          type: PageTransitionType.rightToLeft),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10,
                    ),
                    child: Text(
                      "Select Address",
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
                              textCapitalization: TextCapitalization.characters,
                              decoration: const InputDecoration(
                                hintText: 'Enter Coupon Code',
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
                  ),
                ),
                verticalSpace(35),
                if (widget.availableCoupons.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "🎁 Coupons For You !",
                      style: TextStyle(
                        fontFamily: headingFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
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
                          onTap: () => setState(
                            () {
                              couponGrpValue = couponRadioValue = c.code;
                              _controller.text = c.code;
                              applyPromoCode();
                            },
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Radio(
                                  value: c.code,
                                  groupValue: couponGrpValue,
                                  onChanged: (val) {
                                    setState(() {
                                      couponGrpValue = couponRadioValue = val;
                                      _controller.text = val;
                                      applyPromoCode();
                                    });
                                    print(val);
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CustomText(
                                        c.name.toString(),
                                        color: Colors.grey[700],
                                        isBold: true,
                                      ),
                                    ],
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
    FocusManager.instance.primaryFocus.unfocus();
    final res = await locator<APIService>().applyPromocode(
      widget.productId.toString(),
      widget.qty,
      _controller.text.toLowerCase(),
      "",
    );
    if (res != null) {
      // setState(() {
      //   shippingCharges = res.deliveryCharges.cost.toString();
      //   finalTotal = res.cost.toString();
      //   promoCode = res.promocodeDiscount.promocode;
      //   promoCodeDiscount = res.promocodeDiscount.cost.toString();
      //   promoCodeId = res.promocodeDiscount.promocodeId;
      //   isPromoCodeApplied = true;
      // });

      _controller.text = "";

      ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(content: Text("Coupon Applied Successfully!")),
      );

      await Navigator.push(
        context,
        PageTransition(
            child: SelectAddress(
              productId: widget.productId,
              promoCode: res.promocodeDiscount.promocode,
              promoCodeId: res.promocodeDiscount.promocodeId,
              size: widget.size,
              color: widget.color,
              qty: widget.qty,
              finalTotal: res.cost.toStringAsFixed(2),
            ),
            type: PageTransitionType.rightToLeft),
      );
    } else {
      setState(() {
        _controller.text = "";
        couponGrpValue = null;
        couponRadioValue = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid Coupon")),
      );
    }
  }
}
