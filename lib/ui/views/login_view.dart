import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/app_title.dart';
import 'package:compound/ui/widgets/busy_button_circular.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:compound/viewmodels/login_view_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginView extends StatelessWidget {
  final phoneNoController = TextEditingController();
  final nameController = TextEditingController();

  Widget genericWelcomeText(String txt) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: "Raleway", fontSize: 27, fontWeight: FontWeight.w600),
    );
  }

  Widget welcomeText(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        genericWelcomeText("Sign in with"),
        SizedBox(
          height: 5,
        ),
        genericWelcomeText("your name & "),
        SizedBox(
          height: 5,
        ),
        genericWelcomeText("phone number")
      ],
    );
  }

  Widget inputFields(model, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          welcomeText(context),
          verticalSpaceMedium,
          InputField(
            placeholder: 'Enter your name',
            controller: nameController,
            textInputType: TextInputType.text,
            validationMessage: model.nameValidation,
            onChanged: model.validateName,
          ),
          // InputField(
          //   placeholder: 'Mobile number',
          //   controller: phoneNoController,
          //   textInputType: TextInputType.phone,
          //   validationMessage: model.phoneNoValidation,
          //   onChanged: model.validatePhoneNo,
          // ),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              model.validatePhoneNo;
            },
            errorMessage:model.phoneNoValidation ,
            textFieldController: phoneNoController,
            isEnabled: true,
            autoValidate: true,
            formatInput: true,
          ),
        ],
      )),
    );
  }

  Widget bottomBar(model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Next",
            style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 30,
                fontWeight: FontWeight.w300),
          ),
          horizontalSpaceMedium,
          BusyButtonCicular(
            enabled:
                model.phoneNoValidation == "" && phoneNoController.text != "" && model.nameValidation == "" && nameController.text != "",
            title: 'Next',
            busy: model.busy,
            onPressed: () {
              print((phoneNoController.text).replaceAll(" ", ""));
              model.login(
                phoneNo: (phoneNoController.text).replaceAll(" ", ""),
                name:nameController.text
              );
            },
          ),
        ],
      ),
    );
  }

  Widget image(context) {
    return Image.asset(
      "assets/images/logo_red.png",
      width: MediaQuery.of(context).size.width / 3,
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
            child: bottomBar(model),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  image(context),
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
