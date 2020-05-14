import 'package:compound/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../shared/app_colors.dart';

class BottomTag extends StatelessWidget {
  final Widget childWidget;
  final double appBarHeight;
  final double statusBarHeight;
  const BottomTag(
      {Key key, @required this.childWidget,@required this.appBarHeight,@required this.statusBarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    130 -
                    appBarHeight -
                    statusBarHeight,
              ),
              child: childWidget),
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: backgroundWhiteCreamColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                  ),
                ],
              ),
              Container(
                color: Colors.grey[300],
                height: 80,
                padding: EdgeInsets.symmetric(
                    horizontal: screenPadding, vertical: 10),
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/svg/DZOR_full_logo_verti.svg",
                      color: Colors.grey[800],
                      height: 35,
                      width: 35,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "“ The difference between Style and Fashion is Quality ”",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ]);
  }
}
