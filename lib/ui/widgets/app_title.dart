import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final double fontSize;

  const AppTitle({Key key, this.fontSize = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "DZOR",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
