import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../controllers/login_controller.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import '../widgets/input_field.dart';

class LoginView extends StatelessWidget {
  final phoneNoController = TextEditingController();
  final nameController = TextEditingController();
  final _nameFocus = FocusNode();
  final _mobileFocus = FocusNode();

  Widget inputFields(LoginController controller, context) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign in with \nYour name & mobile number".capitalize!,
              style: TextStyle(
                fontSize: headingFontSizeStyle,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            verticalSpaceMedium,
            InputField(
              fieldFocusNode: _nameFocus,
              nextFocusNode: _mobileFocus,
              placeholder: 'Enter your name',
              fontSize: 14,
              controller: nameController,
              textInputType: TextInputType.text,
              validationMessage: controller.nameValidationMessage,
              onChanged: controller.validateName,
            ),
            InternationalPhoneNumberInput(
              focusNode: _mobileFocus,
              onSubmit: () {
                _mobileFocus.unfocus();
              },
              onInputValidated: (bool flag) {
                if (flag) {
                  _mobileFocus.unfocus();
                }
              },
              countries: ['IN'],
              inputDecoration: InputDecoration(
                hintText: "Mobile Number",
                border: OutlineInputBorder(),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSizeStyle,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              errorMessage: controller.phoneNoValidationMessage,
              textFieldController: phoneNoController,
              isEnabled: true,
              onInputChanged: (value) {},
              // selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              formatInput: true,
            ),
            verticalSpaceTiny,
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                "*Enter a valid Indian mobile number to receive a login OTP.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: subtitleFontSize - 2,
                ),
              ),
            ),
            verticalSpaceMedium,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("Age"),
                verticalSpaceTiny,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: controller.ageLookup!
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              controller.onAgeChanged(e.id!);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: e.id == controller.selectedAgeId
                                        ? logoRed
                                        : Colors.grey[500]!),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
                              margin: EdgeInsets.only(right: 8.0),
                              child: CustomText(
                                e.name ?? "",
                                fontSize: subtitleFontSize,
                                isBold: e.id == controller.selectedAgeId,
                                color:
                                    e.id == controller.selectedAgeId ? logoRed : Colors.grey[500]!,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            verticalSpaceMedium,
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.genderLookup!
                    .map(
                      (e) => InkWell(
                        onTap: () => controller.onGenderIdChanged(e.id!),
                        child: e.id == 3
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8.0,
                                ),
                                margin: EdgeInsets.only(right: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/images/${e.id == 0 ? "man" : e.id == 1 ? "woman" : "other"}.png",
                                      package: e.id == 2 ? 'gender_picker' : null,
                                      height: 30,
                                      width: 30,
                                    ),
                                    verticalSpaceSmall,
                                    CustomText(
                                      e.name ?? "",
                                      fontSize: subtitleFontSize,
                                      isBold: e.id == controller.selectedGenderId,
                                      color: e.id == controller.selectedGenderId
                                          ? logoRed
                                          : Colors.grey[500]!,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: TextButton(
                  onPressed: () => controller.onGenderIdChanged(3),
                  child: Text(
                    "Prefer not to say",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: controller.selectedGenderId == 3 ? logoRed : Colors.black87,
                      fontSize: subtitleFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) => Scaffold(
          // bottomNavigationBar: BottomAppBar(
          //   elevation: 0,
          //   color: Colors.transparent,
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          //     child:
          //   ),
          // ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                    width: Get.width,
                    height: Get.height,
                    child: Image.asset(
                      "assets/icons/abstract-bg2.jpg",
                      fit: BoxFit.cover,
                    )),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 8.0),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  // color: logoRed,
                                  width: MediaQuery.of(context).size.width / 3.2,
                                ),
                              ),
                            ),
                            verticalSpaceMedium,
                            inputFields(controller, context),
                            Center(
                              child: GestureDetector(
                                onTap: (controller.phoneNoValidationMessage == "" &&
                                        phoneNoController.text != "" &&
                                        controller.nameValidationMessage == "" &&
                                        nameController.text != "" &&
                                        controller.selectedAgeId != -1 &&
                                        controller.selectedGenderId != -1)
                                    ? () async {
                                        await controller.login(
                                            phoneNo: (phoneNoController.text).replaceAll(" ", ""),
                                            name: nameController.text);
                                      }
                                    : () async {},
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 15,),
                                  // margin: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    color: (controller.phoneNoValidationMessage == "" &&
                                            phoneNoController.text != "" &&
                                            controller.nameValidationMessage == "" &&
                                            nameController.text != "" &&
                                            controller.selectedAgeId != -1 &&
                                            controller.selectedGenderId != -1)
                                        ? logoRed
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      horizontalSpaceSmall,
                                      Text(
                                        "Get OTP",
                                        style: TextStyle(
                                          fontSize: headingFontSizeStyle,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                      // BusyButtonCicular(
                                      //   enabled: controller.phoneNoValidationMessage == "" &&
                                      //       phoneNoController.text != "" &&
                                      //       controller.nameValidationMessage == "" &&
                                      //       nameController.text != "" &&
                                      //       controller.selectedAgeId != -1 &&
                                      //       controller.selectedGenderId != -1,
                                      //   title: 'Next',
                                      //   busy: controller.busy,
                                      //   onPressed: () async {
                                      //     await controller.login(
                                      //         phoneNo: (phoneNoController.text).replaceAll(" ", ""),
                                      //         name: nameController.text);
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //   bottom: 10,
                //   right: 10,
                //   child: Container(
                //     height: 40,
                //     decoration: BoxDecoration(
                //       color: (controller.phoneNoValidationMessage == "" &&
                //               phoneNoController.text != "" &&
                //               controller.nameValidationMessage == "" &&
                //               nameController.text != "" &&
                //               controller.selectedAgeId != -1 &&
                //               controller.selectedGenderId != -1) ? logoRed : Colors.grey,
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         horizontalSpaceSmall,
                //         Text(
                //           "Get OTP",
                //           style: TextStyle(
                //             fontSize: headingFontSizeStyle,
                //             fontWeight: FontWeight.w500,
                //             color: Colors.white,
                //           ),
                //         ),
                //         horizontalSpaceSmall,
                //         BusyButtonCicular(
                //           enabled: controller.phoneNoValidationMessage == "" &&
                //               phoneNoController.text != "" &&
                //               controller.nameValidationMessage == "" &&
                //               nameController.text != "" &&
                //               controller.selectedAgeId != -1 &&
                //               controller.selectedGenderId != -1,
                //           title: 'Next',
                //           busy: controller.busy,
                //           onPressed: () async {
                //             await controller.login(
                //                 phoneNo: (phoneNoController.text).replaceAll(" ", ""),
                //                 name: nameController.text);
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: TextButton(
                    onPressed: controller.skipLogin,
                    child: CustomText(
                      "Continue as Guest >>",
                      color: Colors.black,
                      isBold: true,
                      fontSize: titleFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
