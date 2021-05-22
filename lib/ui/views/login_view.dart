import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../controllers/login_controller.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/busy_button_circular.dart';
import '../widgets/input_field.dart';

class LoginView extends StatelessWidget {
  final phoneNoController = TextEditingController();
  final nameController = TextEditingController();
  final _nameFocus = FocusNode();
  final _mobileFocus = FocusNode();

  Widget inputFields(controller, context) => Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign in with \nyour name & \nphone number",
                style: TextStyle(
                  fontFamily: "Raleway",
                  fontSize: headingFontSizeStyle + 2,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              verticalSpaceMedium,
              InputField(
                fieldFocusNode: _nameFocus,
                nextFocusNode: _mobileFocus,
                placeholder: 'Enter your name',
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
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSizeStyle)),
                errorMessage: controller.phoneNoValidationMessage,
                textFieldController: phoneNoController,
                isEnabled: true,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                autoValidate: true,
                formatInput: true,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "*Enter a valid Indian mobile number to receive a login OTP.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => GetBuilder(
        init: LoginController(),
        builder: (controller) => Scaffold(
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Next",
                    style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: headingFontSizeStyle,
                        fontWeight: FontWeight.w300),
                  ),
                  horizontalSpaceMedium,
                  BusyButtonCicular(
                    enabled: controller.phoneNoValidationMessage == "" &&
                        phoneNoController.text != "" &&
                        controller.nameValidationMessage == "" &&
                        nameController.text != "",
                    title: 'Next',
                    busy: controller.busy,
                    onPressed: () async {
                      await controller.login(
                          phoneNo: (phoneNoController.text).replaceAll(" ", ""),
                          name: nameController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: backgroundWhiteCreamColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 70, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: SvgPicture.asset(
                      "assets/svg/logo.svg",
                      color: logoRed,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.width / 3) -
                        180,
                    child: inputFields(controller, context),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
