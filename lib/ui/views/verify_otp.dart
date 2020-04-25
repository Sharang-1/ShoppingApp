import 'dart:async';

import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/app_title.dart';
import 'package:compound/ui/widgets/busy_button_circular.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:compound/ui/widgets/text_link.dart';
import 'package:compound/viewmodels/verify_otp_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyOTPView extends StatefulWidget {
  @override
  _VerifyOTPViewState createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  final otpController = TextEditingController();

  final oneSec = const Duration(seconds: 1);
  bool otpSendButtonEnabled = false;
  int timerCountDownSeconds = 30;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    updateTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String getFormatedCountDowndTimer() {
    return "00:${(timerCountDownSeconds < 10 ? '0' : '') + timerCountDownSeconds.toString()}";
  }

  void updateTimer() {
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (timerCountDownSeconds < 1) {
          timer.cancel();
          enableSendOTP();
        } else {
          timerCountDownSeconds--;
        }
      });
    });
  }

  void enableSendOTP() {
    setState(() {
      otpSendButtonEnabled = true;
    });
  }

  FutureOr<dynamic> resetTimer(void value) {
    setState(() {
      _timer.cancel();
      otpSendButtonEnabled = false;
      timerCountDownSeconds = 30;
      updateTimer();
    });
  }

  Widget genericWelcomeText(String txt) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: "Raleway", fontSize: 27, fontWeight: FontWeight.w600),
    );
  }

  Widget welcomeText(context, model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        genericWelcomeText("Enter the otp"),
        SizedBox(
          height: 5,
        ),
        genericWelcomeText("sent to ${model.phoneNo}"),
        SizedBox(
          height: 5,
        ),
        genericWelcomeText("via sms")
      ],
    );
  }

  Widget bottomBar(model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            onPressed: model.changePhoneNo,
            elevation: 0,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black,size: 30,),
          ),
          Row(
            children: <Widget>[
              Text(
                "Finish",
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 30,
                    fontWeight: FontWeight.w300),
              ),
              horizontalSpaceMedium,
              BusyButtonCicular(
                enabled: model.otpValidationMessage == "" &&
                    otpController.text != "",
                title: 'Verify',
                busy: model.busy,
                onPressed: () {
                  model.verifyOTP(
                    otp: otpController.text,
                  );
                },
              ),
            ],
          )
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

  _launchURL() async {
    const url = 'https://dzor.in/policy.html?source=c';
    //const url = 'https://www.google.co.in';
    //print(canLaunch(url));
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget inputFields(model, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[welcomeText(context, model)]),
          verticalSpaceMedium,
          // InputField(
          //   placeholder: 'OTP',
          //   controller: otpController,
          //   textInputType: TextInputType.numberWithOptions(decimal: true),
          //   onChanged: model.validateOtp,
          //   validationMessage: model.otpValidationMessage,
          // ),
          PinCodeTextField(
          pinBoxHeight: 40,
          pinBoxWidth: 40,
          pinBoxBorderWidth: 1,
          autofocus: false,
          controller: otpController,
          hideCharacter: false,
          // highlight: true,
          // highlightColor: Colors.blue,
          hasTextBorderColor: Colors.black45,
          defaultBorderColor: Colors.grey[300],
          pinBoxColor: Colors.white,
          maxLength: 4,
          // hasError: hasError,
          onTextChanged: model.validateOtp,
          onDone: (text) {
            model.verifyOTP(
              otp: text,
            );
          },
          wrapAlignment: WrapAlignment.center,
          pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
          pinTextStyle: TextStyle(fontSize: 20),
          pinBoxRadius: 3,
          pinTextAnimatedSwitcherTransition:
              ProvidedPinBoxTextAnimation.scalingTransition,
          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
        ),
          Text(getFormatedCountDowndTimer(),style: TextStyle(fontSize: 20),),
          verticalSpaceSmall,
          TextLink(
            'RESEND OTP',            
            onPressed: () {
              model.resendOTP().then(resetTimer);
            },
            enabled: otpSendButtonEnabled,
          ),
          verticalSpaceSmall,
          InkWell(
              onTap: () {
                _launchURL();
              },
              child: Text(
                "When you tap \"finish\" You agree to Dzor's terms and conditions",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Open Sans",
                  decoration: TextDecoration.underline,
                  fontSize: 15
                ),
                textAlign: TextAlign.center,
              ))
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<VerifyOTPViewModel>.withConsumer(
        viewModel: VerifyOTPViewModel(),
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
                  ],
                ),
              ),
            )));
  }
}

// class _VerifyOTPViewState extends State<VerifyOTPView> {
//   final otpController = TextEditingController();

//   final oneSec = const Duration(seconds: 1);
//   bool otpSendButtonEnabled = false;
//   int timerCountDownSeconds = 30;
//   Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     updateTimer();
//   }

//   @override
//   void dispose() {
//     otpController.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   String getFormatedCountDowndTimer() {
//     return "00:${(timerCountDownSeconds < 10 ? '0' : '') + timerCountDownSeconds.toString()}";
//   }

//   void updateTimer() {
//     _timer = Timer.periodic(oneSec, (Timer timer) {
//       setState(() {
//         if(timerCountDownSeconds < 1) {
//           timer.cancel();
//           enableSendOTP();
//         } else {
//           timerCountDownSeconds--;
//         }
//       });
//     });
//   }

//   void enableSendOTP() {
//     setState(() {
//       otpSendButtonEnabled = true;
//     });
//   }

//   FutureOr<dynamic> resetTimer(void value) {
//     setState(() {
//       _timer.cancel();
//       otpSendButtonEnabled = false;
//       timerCountDownSeconds = 30;
//       updateTimer();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelProvider<VerifyOTPViewModel>.withConsumer(
//       viewModel: VerifyOTPViewModel(),
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
//                 SizedBox(height: 100, child: AppTitle()),
//                 verticalSpaceSmall,
//                 Text("SMS containing OTP is sent to ${model.phoneNo}"),
//                 verticalSpaceSmall,
//                 TextLink("Change Mobile Number",
//                     onPressed: model.changePhoneNo),
//                 verticalSpaceMedium,
//                 InputField(
//                   placeholder: 'OTP',
//                   controller: otpController,
//                   textInputType: TextInputType.numberWithOptions(decimal: true),
//                   onChanged: model.validateOtp,
//                   validationMessage: model.otpValidationMessage,
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     BusyButton(
//                       enabled: model.otpValidationMessage == "" &&
//                           otpController.text != "",
//                       title: 'Verify',
//                       busy: model.busy,
//                       onPressed: () {
//                         model.verifyOTP(
//                           otp: otpController.text,
//                         );
//                       },
//                     )
//                   ],
//                 ),
//                 verticalSpaceMedium,
//                 Text(getFormatedCountDowndTimer()),
//                 verticalSpaceSmall,
//                 TextLink(
//                   'RESEND OTP',
//                   onPressed: () {
//                     model.resendOTP().then(resetTimer);
//                   },
//                   enabled: otpSendButtonEnabled,
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }

// import 'dart:async';

// import 'package:compound/ui/shared/ui_helpers.dart';
// import 'package:compound/ui/widgets/app_title.dart';
// import 'package:compound/ui/widgets/busy_button.dart';
// import 'package:compound/ui/widgets/input_field.dart';
// import 'package:compound/ui/widgets/text_link.dart';
// import 'package:compound/viewmodels/verify_otp_model.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_code_text_field/pin_code_text_field.dart';
// import 'package:provider_architecture/provider_architecture.dart';
// import 'package:url_launcher/url_launcher.dart';

// class VerifyOTPView extends StatefulWidget {
//   @override
//   _VerifyOTPViewState createState() => _VerifyOTPViewState();
// }

// class _VerifyOTPViewState extends State<VerifyOTPView> {
//   final otpController = TextEditingController();

//   final oneSec = const Duration(seconds: 1);
//   bool otpSendButtonEnabled = false;
//   int timerCountDownSeconds = 30;
//   Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     updateTimer();
//   }

//   @override
//   void dispose() {
//     otpController.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   String getFormatedCountDowndTimer() {
//     return "00:${(timerCountDownSeconds < 10 ? '0' : '') + timerCountDownSeconds.toString()}";
//   }

//   void updateTimer() {
//     _timer = Timer.periodic(oneSec, (Timer timer) {
//       setState(() {
//         if (timerCountDownSeconds < 1) {
//           timer.cancel();
//           enableSendOTP();
//         } else {
//           timerCountDownSeconds--;
//         }
//       });
//     });
//   }

//   void enableSendOTP() {
//     setState(() {
//       otpSendButtonEnabled = true;
//     });
//   }

//   FutureOr<dynamic> resetTimer(void value) {
//     setState(() {
//       _timer.cancel();
//       otpSendButtonEnabled = false;
//       timerCountDownSeconds = 30;
//       updateTimer();
//     });
//   }

//   Widget headingText(String txt, double width) {
//     return Text(
//       txt,
//       style: TextStyle(
//         fontSize: width * 0.08,
//         fontFamily: "Raleway",
//         fontWeight: FontWeight.w600,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double contextWidth = MediaQuery.of(context).size.width;
//     double contextHeight = MediaQuery.of(context).size.height;

//     return ViewModelProvider<VerifyOTPViewModel>.withConsumer(
//         viewModel: VerifyOTPViewModel(),
//         onModelReady: (model) => model.init(),
//         builder: (context, model, child) => Scaffold(
//             backgroundColor: Colors.white,
//             body: Scrollbar(
//                 child: SingleChildScrollView(
//                     child: ConstrainedBox(
//                         constraints: BoxConstraints.expand(
//                             height: MediaQuery.of(context).size.height),
//                         child: IntrinsicHeight(
//                             child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Flexible(
//                                 flex: 2,
//                                 child: Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 2, top: 20, bottom: 10),
//                                     child: Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Image.asset(
//                                         'assets/images/logo/o_logo_red.png',
//                                         width: contextWidth * 0.35,
//                                       ),
//                                     ))),
//                             Flexible(
//                                 flex: 2,
//                                 child: Padding(
//                                     padding: EdgeInsets.only(left: 5),
//                                     child: _numberTextColumn(
//                                         contextWidth, contextHeight, model))),
//                             Flexible(
//                                 flex: 2,
//                                 child: Padding(
//                                     padding: EdgeInsets.only(left: 5, right: 5),
//                                     child: _otpInsertColumn(
//                                         contextWidth, contextHeight, model))),
//                             Flexible(
//                                 flex: 1,
//                                 child: Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 5, right: 5, bottom: 10),
//                                     child: _backFinishButtonsRow(
//                                         contextWidth, contextHeight, model)))
//                           ],
//                         ))))))

//         // Scaffold(
//         //     backgroundColor: Colors.white,
//         //     body: Padding(
//         //       padding: const EdgeInsets.symmetric(horizontal: 50),
//         //       child: Column(
//         //         mainAxisSize: MainAxisSize.max,
//         //         mainAxisAlignment: MainAxisAlignment.center,
//         //         crossAxisAlignment: CrossAxisAlignment.center,
//         //         children: <Widget>[
//         //           SizedBox(height: 100, child: AppTitle()),
//         //           verticalSpaceSmall,
//         //           Text("SMS containing OTP is sent to ${model.phoneNo}"),
//         //           verticalSpaceSmall,
//         //           TextLink("Change Mobile Number",
//         //               onPressed: model.changePhoneNo),
//         //           verticalSpaceMedium,
//         //           InputField(
//         //             placeholder: 'OTP',
//         //             controller: otpController,
//         //             textInputType: TextInputType.numberWithOptions(decimal: true),
//         //             onChanged: model.validateOtp,
//         //             validationMessage: model.otpValidationMessage,
//         //           ),
//         //           Row(
//         //             mainAxisSize: MainAxisSize.max,
//         //             mainAxisAlignment: MainAxisAlignment.center,
//         //             children: [
//         //               BusyButton(
//         //                 enabled: model.otpValidationMessage == "" &&
//         //                     otpController.text != "",
//         //                 title: 'Verify',
//         //                 busy: model.busy,
//         //                 onPressed: () {
//         //                   model.verifyOTP(
//         //                     otp: otpController.text,
//         //                   );
//         //                 },
//         //               )
//         //             ],
//         //           ),
//         //           verticalSpaceMedium,
//         //           Text(getFormatedCountDowndTimer()),
//         //           verticalSpaceSmall,
//         //           TextLink(

//         //             'RESEND OTP',
//         //             onPressed: () {
//         //               model.resendOTP().then(resetTimer);
//         //             },
//         //             enabled: otpSendButtonEnabled,
//         //           ),
//         //         ],
//         //       ),
//         //     )),
//         );
//   }

//   Widget _numberTextColumn(double contextWidth, double contextHeight, model) {
//     return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Align(
//               alignment: Alignment.topLeft,
//               child: headingText("Enter the OTP", contextWidth)),
//           Row(children: <Widget>[
//             headingText('Sent to\t', contextWidth),
//             InkWell(
//                 onTap: model.changePhoneNo,
//                 child: Text(
//                   '+91 ${model.phoneNo}',
//                   style: TextStyle(
//                     fontSize: contextWidth * 0.08,
//                     fontFamily: "Raleway",
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ))
//           ]),
//           Align(
//               alignment: Alignment.topLeft,
//               child: headingText('Via SMS', contextWidth))
//         ]);
//   }

//   Widget _otpInsertColumn(double contextWidth, double contextHeight, model) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         PinCodeTextField(
//           pinBoxHeight: contextWidth * 0.12,
//           pinBoxWidth: contextWidth * 0.08,
//           pinBoxBorderWidth: 1,
//           autofocus: false,
//           controller: otpController,
//           hideCharacter: false,
//           // highlight: true,
//           // highlightColor: Colors.blue,
//           hasTextBorderColor: Colors.black45,
//           defaultBorderColor: Colors.grey[300],
//           pinBoxColor: Colors.white,
//           maxLength: 4,
//           // hasError: hasError,
//           onTextChanged: model.validateOtp,
//           onDone: (text) {
//             model.verifyOTP(
//               otp: text,
//             );
//           },
//           wrapAlignment: WrapAlignment.center,
//           pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
//           pinTextStyle: TextStyle(fontSize: contextWidth * 0.08),
//           pinBoxRadius: 3,
//           pinTextAnimatedSwitcherTransition:
//               ProvidedPinBoxTextAnimation.scalingTransition,
//           pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
//         ),
//         // Visibility(
//         //   child: Text(
//         //     "Wrong PIN!",
//         //     style: TextStyle(color: Colors.red),
//         //   ),
//         //   visible: hasError,

//         InkWell(
//             onTap: model.resendOTP().then(resetTimer),
//             child: Text(
//               "Resend OTP",
//               style: TextStyle(
//                   color: otpSendButtonEnabled
//                       ? Colors.grey[800]
//                       : Colors.grey[300],
//                   fontFamily: "Open Sans",
//                   fontSize: contextWidth * 0.05,
//                   decoration: TextDecoration.underline),
//             )),

//         Text(
//           getFormatedCountDowndTimer(),
//           style: TextStyle(
//               color: Colors.grey,
//               fontSize: contextWidth * 0.05,
//               fontFamily: "Open Sans"),
//         ),

//       ],
//     );
//   }

//   Widget _backFinishButtonsRow(
//       double contextWidth, double contextHeight, model) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         MaterialButton(
//           onPressed: () {},
//           color: Color.fromARGB(255, 184, 21, 20),
//           elevation: 5,
//           child: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//             size: contextWidth * 0.08,
//           ),
//           padding: EdgeInsets.all(10),
//           shape: CircleBorder(),
//         ),
//         Container(
//             child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//               Text(
//                 'Finish',
//                 style: TextStyle(
//                     fontSize: contextWidth * 0.08,
//                     fontFamily: "Raleway",
//                     fontWeight: FontWeight.w300),
//                 textAlign: TextAlign.center,
//               ),
//               MaterialButton(
//                   padding: EdgeInsets.all(10),
//                   onPressed: () {},
//                   color: Color.fromARGB(255, 184, 21, 20),
//                   elevation: 5,
//                   shape: CircleBorder(),
//                   child: Icon(
//                     Icons.arrow_forward,
//                     size: contextWidth * 0.08,
//                     color: Colors.white,
//                   )),
//             ]))
//       ],
//     );
//   }

//   _launchURL() async {
//     const url = 'https://dzor.in/policy.html?source=c';
//     //const url = 'https://www.google.co.in';
//     //print(canLaunch(url));
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
