import 'package:compound/controllers/base_controller.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/order_details.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/ui/widgets/order_details_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../controllers/cart_select_delivery_controller.dart';
import '../../google_maps_place_picker/google_maps_place_picker.dart';
import '../../models/user_details.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';
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
    Key key,
    @required this.productId,
    @required this.promoCode,
    @required this.promoCodeId,
    @required this.size,
    @required this.color,
    @required this.qty,
    @required this.finalTotal,
    @required this.orderDetails,
    this.isPromocodeApplied = false,
  }) : super(key: key);

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  UserDetailsContact addressRadioValue;
  UserDetailsContact addressGrpValue;
  bool disabledPayment = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartSelectDeliveryController>(
      init: CartSelectDeliveryController(),
      builder: (controller) => Scaffold(
        backgroundColor: newBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Select Address",
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
                    showModalBottomSheet<void>(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => OrderDetailsBottomsheet(
                        orderDetails: widget.orderDetails,
                        buttonText: "Make Payment",
                        onButtonPressed: disabledPayment
                            ? null
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
                        "${BaseController.formatPrice(num.parse(widget.finalTotal.replaceAll("₹", "")))}",
                        fontSize: 12,
                        isBold: true,
                      ),
                      CustomText("View Details",
                          textStyle: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          )),
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
                              "Make Payment",
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
                        "My Addresses",
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
                            onTap: () => setState(
                              () {
                                addressGrpValue = addressRadioValue = address;
                                disabledPayment = false;
                              },
                            ),
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: spaceBetweenCards),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[200],
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
                                        onChanged: (val) {
                                          // setState(() {
                                          //   addressGrpValue =
                                          //       addressRadioValue = val;
                                          //   disabledPayment = false;
                                          // });
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
                                              "My Address: ",
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                              isBold: true,
                                            ),
                                            verticalSpaceTiny_0,
                                            CustomText(
                                              "${address.address}",
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                            // verticalSpaceTiny_0,
                                            // CustomText(
                                            //   "My Location: ",
                                            //   color: Colors.grey[700],
                                            //   fontSize: 14,
                                            //   isBold: true,
                                            // ),
                                            // verticalSpaceTiny_0,
                                            // CustomText(
                                            //   "${address.googleAddress}",
                                            //   color: Colors.grey,
                                            //   fontSize: 14,
                                            // ),
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
                            // side: BorderSide(
                            //     color: Colors.black, width: 0.5)
                          ),
                        ),
                        onPressed: () async {
                          PickResult pickedPlace = await Navigator.push(
                            context,
                            PageTransition(
                              child: AddressInputPage(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                          if (pickedPlace != null) {
                            UserDetailsContact userAdd =
                                await showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (_) => BottomSheetForAddress(
                                pickedPlace: pickedPlace,
                              ),
                            );
                            if (userAdd != null) {
                              controller.addAddress(userAdd);
                            }
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
                                "Add Address",
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

  Future<void> makePayment(controller) async {
    final serviceAvailability = await locator<APIService>().checkPincode(
        productId: widget.productId,
        pincode: addressRadioValue.pincode.toString());

    if (serviceAvailability == null) return;

    if (serviceAvailability.serviceAvailable) {
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
              finalTotal: widget.finalTotal,
              orderDetails: widget.orderDetails,
            ),
            type: PageTransitionType.rightToLeft),
      );
    } else {
      DialogService.showNotDeliveringDialog(msg: serviceAvailability.message);
      // Get.snackbar(
      //   "Service Not Available",
      //   serviceAvailability.message,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }
}
