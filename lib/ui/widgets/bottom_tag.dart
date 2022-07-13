import 'package:flutter/material.dart';

import '../shared/shared_styles.dart';

class BottomTag extends StatelessWidget {
  final Widget childWidget;
  final double appBarHeight;
  final double statusBarHeight;
  const BottomTag(
      {Key? key,
      required this.childWidget,
      required this.appBarHeight,
      required this.statusBarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Container(
              color: Colors.white,
              height: 80,
              padding:
                  EdgeInsets.symmetric(horizontal: screenPadding, vertical: 10),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo.png",
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
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
