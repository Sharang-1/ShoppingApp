import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  double fontSize;
  bool isBold;
  TextStyle textStyle;
  String text;
  Color color;
  bool replaceWithDotsAfterOverFlow;
  String fontFamily;
  FontWeight fontWeight;

  CustomText(this.text,
      {this.color = Colors.black,
      this.fontSize = 16,
      this.isBold = false,
      this.textStyle,
      this.replaceWithDotsAfterOverFlow = false,
      this.fontFamily = "",
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: replaceWithDotsAfterOverFlow
          ? TextOverflow.ellipsis
          : TextOverflow.visible,
      style: textStyle != null
          ? textStyle
          : TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
              fontWeight: isBold
                  ? FontWeight.bold
                  : (fontWeight != null ? fontWeight : FontWeight.normal),
              color: color),
    );
  }
}
