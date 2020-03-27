import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/app_title.dart';
import 'package:compound/ui/widgets/busy_button.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:compound/viewmodels/login_view_model.dart';

class LoginView extends StatelessWidget {
  final phoneNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 150, child: AppTitle()),
                InputField(
                  placeholder: 'Mobile Number',
                  controller: phoneNoController,
                  textInputType: TextInputType.phone,
                  validationMessage: model.phoneNoValidation,
                  onChanged: model.validatePhoneNo,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BusyButton(
                      enabled: model.phoneNoValidation == "" &&
                          phoneNoController.text != "",
                      title: 'Next',
                      busy: model.busy,
                      onPressed: () {
                        model.login(
                          phoneNo: phoneNoController.text,
                        );
                      },
                    )
                  ],
                ),
                // verticalSpaceMedium,
                // TextLink(
                //   'Create an Account if you\'re new.',
                //   onPressed: () {
                //     model.navigateToSignUp();
                //   },
                // )
              ],
            ),
          )),
    );
  }
}
