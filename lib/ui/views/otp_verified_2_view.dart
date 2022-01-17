import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../locator.dart';
import '../../services/api/api_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class OtpVerifiedView2 extends StatefulWidget {
  @override
  _TextFadeState createState() => _TextFadeState();
}

class _TextFadeState extends State<OtpVerifiedView2>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;
  double _position = -1;
  String name = '';

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
    return FutureBuilder<String>(
      future: locator<APIService>().updateUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          name = snapshot.data ?? "";
        }
        Future.delayed(
          Duration(milliseconds: 2000),
          () async => await NavigationService.off(LoaderRoute),
        );
        return Scaffold(
          backgroundColor: newBackgroundColor,
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
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: headingFontSize + 5,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    0,
                    MediaQuery.of(context).size.height *
                        _position *
                        (1 - _animation.value)),
                child: AnimatedOpacity(
                  duration: _animationController.duration!,
                  opacity: _animation.value,
                  curve: Curves.ease,
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
