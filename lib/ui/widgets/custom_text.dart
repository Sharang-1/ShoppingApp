import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final double fontSize;
  final bool isBold;
  final TextStyle textStyle;
  final String text;
  final Color color;
  final bool dotsAfterOverFlow;
  final String fontFamily;
  final FontWeight fontWeight;
  final bool isTitle;
  final TextAlign align;

  CustomText(this.text,
      {this.color = Colors.black,
      this.fontSize = 16,
      this.isBold = false,
      this.textStyle,
      this.dotsAfterOverFlow = false,
      this.fontFamily = "",
      this.fontWeight,
      this.isTitle = false,
      this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow:
          dotsAfterOverFlow ? TextOverflow.ellipsis : TextOverflow.visible,
      textAlign: align != null ? align : TextAlign.start,
      style: textStyle != null
          ? textStyle
          : TextStyle(
              fontSize: fontSize,
              fontFamily: isTitle ? "Raleway" : fontFamily,
              fontWeight: isBold
                  ? FontWeight.bold
                  : (fontWeight != null ? fontWeight : FontWeight.normal),
              color: color),
    );
  }
}
