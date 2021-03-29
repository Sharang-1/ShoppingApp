import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../viewmodels/verify_otp_model.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class OtpVerifiedView2 extends StatefulWidget {
  @override
  _TextFadeState createState() => _TextFadeState();
}

class _TextFadeState extends State<OtpVerifiedView2>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  double _position = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.ease);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    const double headingFontSize = headingFontSizeStyle + 15;
    return ViewModelProvider<VerifyOTPViewModel>.withConsumer(
      viewModel: VerifyOTPViewModel(),
      onModelReady: (model) => model.otpVerified(loader: true),
      builder: (context, model, child) => Scaffold(
          backgroundColor: backgroundWhiteCreamColor,
          body: AnimatedBuilder(
              animation: _animation,
              child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Hello",
                          style: TextStyle(
                            fontSize: headingFontSize,
                            fontFamily: "Raleway",
                          ),
                        ),
                        Text(
                          model.name,
                          style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: headingFontSize + 5,
                              fontWeight: FontWeight.w600),
                        ),
                      ])),
              builder: (context, child) {
                return Transform.translate(
                    offset: Offset(
                        0,
                        MediaQuery.of(context).size.height *
                            _position *
                            (1 - _animation.value)),
                    child: AnimatedOpacity(
                      duration: _animationController.duration,
                      opacity: _animation.value,
                      curve: Curves.ease,
                      child: child,
                    ));
              })),
    );
  }
}
