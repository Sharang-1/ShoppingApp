import 'package:compound/viewmodels/otp_finished_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class otpFinishedScreen2 extends StatefulWidget {
  @override
  _TextFadeState createState() => _TextFadeState();
}

class _TextFadeState extends State<otpFinishedScreen2>
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
    return ViewModelProvider<OtpFinishedScreenModel>.withConsumer(
      viewModel: OtpFinishedScreenModel(),
      onModelReady: (model) => model.init(2),
      builder: (context, model, child) => Scaffold(
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
                            fontSize: 40,
                            fontFamily: "Raleway",
                          ),
                        ),
                        Text(
                          model.name,
                          style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 45,
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
