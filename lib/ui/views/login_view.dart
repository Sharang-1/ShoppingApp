// import 'package:compound/ui/widgets/app_title.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/busy_button_circular.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:compound/viewmodels/login_view_model.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class LoginView extends StatelessWidget {
  final phoneNoController = TextEditingController();
  final nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();

  void onValidated() {}
  Widget inputFields(model, context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const WelcomeText(),
          verticalSpaceMedium,
          InputField(
            fieldFocusNode: _nameFocus,
            nextFocusNode: _mobileFocus,
            placeholder: 'Enter your name',
            controller: nameController,
            textInputType: TextInputType.text,
            validationMessage: model.nameValidation,
            onChanged: model.validateName,
          ),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              // model.validatePhoneNo(number.toString());
            },
            focusNode: _mobileFocus,
            onSubmit: () {
              _mobileFocus.unfocus();
            },
            onInputValidated: (bool flag) {
              if (flag) {
                _mobileFocus.unfocus();
              }
            },
            countries: ['IN', 'US'],
            inputDecoration: InputDecoration(
                hintText: "Phone Number",
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSizeStyle)),
            errorMessage: model.phoneNoValidation,
            textFieldController: phoneNoController,
            isEnabled: true,
            selectorType: PhoneInputSelectorType.DIALOG,
            autoValidate: true,
            formatInput: true,
          ),
          // InternationalPhoneInput(
          //     initialPhoneNumber: "",

          //     initialSelection: "IND",
          //     enabledCountries: ['+91', '+1']),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
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
                    enabled: model.phoneNoValidation == "" &&
                        phoneNoController.text != "" &&
                        model.nameValidation == "" &&
                        nameController.text != "",
                    title: 'Next',
                    busy: model.busy,
                    onPressed: () async {
                      await model.login(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const ImageLogo(),
                  Container(
                    height: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.width / 3) -
                        20 -
                        20 -
                        100,
                    child: inputFields(model, context),
                  )
                  // Expanded(child: inputFields(model, context)),
                ],
              ),
            ),
          )),
    );
  }
}

class ImageLogo extends StatelessWidget {
  const ImageLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/svg/logo.svg",
      color: logoRed,
      width: MediaQuery.of(context).size.width / 3,
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const GenericWelcomeText(txt: "Sign in with"),
        SizedBox(
          height: 5,
        ),
        const GenericWelcomeText(txt: "your name & "),
        SizedBox(
          height: 5,
        ),
        const GenericWelcomeText(txt: "phone number")
      ],
    );
  }
}

class GenericWelcomeText extends StatelessWidget {
  final txt;

  const GenericWelcomeText({Key key, this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: "Raleway",
          fontSize: headingFontSizeStyle + 2,
          fontWeight: FontWeight.w600),
    );
  }
}

// class LoginView extends StatelessWidget {
//   final phoneNoController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelProvider<LoginViewModel>.withConsumer(
//       viewModel: LoginViewModel(),
//       onModelReady: (model) => model.init(),
//       builder: (context, model, child) => Scaffold(
//           backgroundColor: Colors.white,
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 50),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(height: 150, child: AppTitle()),
//                 InputField(
//                   placeholder: 'Mobile Number',
//                   controller: phoneNoController,
//                   textInputType: TextInputType.phone,
//                   validationMessage: model.phoneNoValidation,
//                   onChanged: model.validatePhoneNo,
//                 ),
//                 verticalSpaceMedium,
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
// BusyButton(
//   enabled: model.phoneNoValidation == "" &&
//       phoneNoController.text != "",
//   title: 'Next',
//   busy: model.busy,
//   onPressed: () {
//     model.login(
//       phoneNo: phoneNoController.text,
//     );
//   },
// )
//                   ],
//                 ),
//                 // verticalSpaceMedium,
//                 // TextLink(
//                 //   'Create an Account if you\'re new.',
//                 //   onPressed: () {
//                 //     model.navigateToSignUp();
//                 //   },
//                 // )
//               ],
//             ),
//           )),
//     );
//   }
// }
