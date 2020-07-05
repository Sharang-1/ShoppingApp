import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../shared/app_colors.dart';

class CircularProgressIndicatorWidget extends StatefulWidget {
  final bool fromCart ;

  const CircularProgressIndicatorWidget({Key key, this.fromCart}) : super(key: key);
  @override
  _CircularProgressIndicatorWidgetState createState() =>
      _CircularProgressIndicatorWidgetState();
}

class _CircularProgressIndicatorWidgetState
    extends State<CircularProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.ease);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _animation,
    builder: (context, child) {
                return CircularPercentIndicator(
              radius: ((MediaQuery.of(context).size.width / 2.5) + 40),
              lineWidth: 5.0,
              backgroundColor: Colors.transparent,
              percent: _animation.value,
              progressColor: widget.fromCart ? green  : lightBlue,
            );
              }
    );
  }
}
