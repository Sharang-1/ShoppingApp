import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/cart_select_delivery_controller.dart';
import '../../locator.dart';
import '../../models/calculatedPrice.dart';
import '../../models/order_details.dart';
import '../../models/user_details.dart';
import '../../services/api/api_service.dart';
import '../../services/dialog_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';
import '../widgets/order_details_bottomsheet.dart';
import 'address_input_form_view.dart';
import 'cart_payment_method_view.dart';

class SelectAddress extends StatefulWidget {
  final String finalTotal;
  final String productId;
  final String promoCode;
  final String promoCodeId;
  final String size;
  final String color;
  final int qty;
  final OrderDetails orderDetails;
  final bool isPromocodeApplied;

  const SelectAddress({
    Key? key,
    required this.productId,
    required this.promoCode,
    required this.promoCodeId,
    required this.size,
    required this.color,
    required this.qty,
    required this.finalTotal,
    required this.orderDetails,
    this.isPromocodeApplied = false,
  }) : super(key: key);

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  UserDetailsContact addressRadioValue = UserDetailsContact();
  UserDetailsContact addressGrpValue = UserDetailsContact();
  bool disabledPayment = true;
  String? deliveryCharges = "";
  late OrderDetails orderDetails;

  @override
  void initState() {
    orderDetails = widget.orderDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartSelectDeliveryController>(
      init: CartSelectDeliveryController(),
      builder: (controller) => Scaffold(
        backgroundColor: newBackgroundColor2,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            SELECT_ADDRESS.tr,
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
                InkWell(
                  onTap: () {
                    showBottomSheet(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      // isScrollControlled: true,
                      
                      context: context,
                      builder: (context) => OrderDetailsBottomsheet(
                        orderDetails: orderDetails,
                        buttonText: MAKE_PAYMENT.tr,
                        buttonIcon: FontAwesomeIcons.lock,
                        onButtonPressed: disabledPayment
                            ? () {}
                            : () async => await makePayment(controller),
                        isPromocodeApplied: widget.isPromocodeApplied,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        "${BaseController.formatPrice(num.parse(orderDetails.total!.replaceAll("₹", "")))}",
                        fontSize: 12,
                        isBold: true,
                      ),
                      CustomText(
                        VIEW_DETAILS.tr,
                        textStyle: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalSpaceMedium,
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: disabledPayment
                        ? null
                        : () async => await makePayment(controller),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.lock,
                              size: 16,
                            ),
                            horizontalSpaceSmall,
                            CustomText(
                              MAKE_PAYMENT.tr,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ],
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
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSpace(10),
                  const CutomStepper(
                    step: 2,
                  ),
                  verticalSpace(20),
                  if (controller.addresses.length != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        MY_ADDRESSES.tr,
                        style: TextStyle(
                            fontFamily: headingFont,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
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
                        controller.addresses.map(
                          (UserDetailsContact address) => GestureDetector(
                            onTap: () async {
                              setState(
                                () {
                                  addressGrpValue = addressRadioValue = address;
                                  disabledPayment = false;
                                },
                              );

                              final calculatedPrice = await calculatePrice();
                              if (calculatedPrice != null) {
                                deliveryCharges = calculatedPrice
                                    .deliveryCharges?.cost
                                    ?.toStringAsFixed(2);
                                setState(() {
                                  orderDetails.deliveryCharges =
                                      rupeeUnicode + deliveryCharges!;
                                  orderDetails.total =
                                      "$rupeeUnicode${calculatedPrice.cost?.toStringAsFixed(2)}";
                                });
                              }
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: spaceBetweenCards),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[200]!,
                                  ),
                                ),
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Radio(
                                        value: address,
                                        groupValue: addressGrpValue,

                                        onChanged: (val) async {
                                          setState(
                                                () {
                                              addressGrpValue = addressRadioValue = address;
                                              disabledPayment = false;
                                            },
                                          );

                                          final calculatedPrice = await calculatePrice();
                                          if (calculatedPrice != null) {
                                            deliveryCharges = calculatedPrice
                                                .deliveryCharges?.cost
                                                ?.toStringAsFixed(2);
                                            setState(() {
                                              orderDetails.deliveryCharges =
                                                  rupeeUnicode + deliveryCharges!;
                                              orderDetails.total =
                                              "$rupeeUnicode${calculatedPrice.cost?.toStringAsFixed(2)}";
                                            });
                                          }
                                        },
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                CustomText(
                                                  MY_ADDRESS.tr,
                                                  color: Colors.grey[700]!,
                                                  fontSize: 14,
                                                  isBold: true,
                                                ),
                                                verticalSpaceTiny_0,
                                                CustomText(
                                                  "${address.address}",
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                            if (deliveryCharges != null &&
                                                addressGrpValue == address)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: CustomText(
                                                  deliveryCharges == "0.00"
                                                      ? "Free Delivery"
                                                      : "+ ₹$deliveryCharges",
                                                  fontSize: subtitleFontSize,
                                                ),
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: darkRedSmooth,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          // PickResult pickedPlace = await Navigator.push(
                          //   context,
                          //   PageTransition(
                          //     child: AddressInputPage(),
                          //     type: PageTransitionType.rightToLeft,
                          //   ),
                          // );

                            UserDetailsContact userAdd =
                                await showMaterialModalBottomSheet(
                              expand: true,
                              context: context,
                              builder: (_) => BottomSheetForAddress(),
                            );
                            if (userAdd != null) {
                              controller.addAddress(userAdd);
                            }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/svg/address.svg",
                              color: Colors.white,
                              width: 25,
                              height: 25,
                            ),
                            horizontalSpaceSmall,
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomText(
                                ADD_ADDRESS.tr,
                                isBold: true,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<CalculatedPrice?> calculatePrice() =>
      locator<APIService>().calculateProductPrice(
        widget.productId,
        widget.qty,
        addressRadioValue.pincode.toString(),
        promocode: widget.promoCode,
      );

  Future<void> makePayment(controller) async {
    final serviceAvailability = await locator<APIService>().checkPincode(
        productId: widget.productId,
        pincode: addressRadioValue.pincode.toString());

    if (serviceAvailability == null) return;

    if (serviceAvailability.serviceAvailable ?? false) {
      Navigator.push(
        context,
        PageTransition(
            child: PaymentMethod(
              billingAddress: (addressRadioValue == null
                  ? controller.addresses[0]
                  : addressRadioValue),
              color: widget.color,
              productId: widget.productId,
              promoCode: widget.promoCode,
              promoCodeId: widget.promoCodeId,
              qty: widget.qty,
              size: widget.size,
              finalTotal: orderDetails.total ?? "",
              orderDetails: orderDetails,
            ),
            type: PageTransitionType.rightToLeft),
      );
    } else {
      DialogService.showNotDeliveringDialog(
          msg: serviceAvailability.message ?? "");
    }
  }
}
