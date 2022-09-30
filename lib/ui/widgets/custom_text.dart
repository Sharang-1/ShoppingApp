import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final double fontSize;
  final bool isBold;
  final TextStyle? textStyle;
  final String text;
  final Color color;
  final bool dotsAfterOverFlow;
  final String fontFamily;
  final FontWeight? fontWeight;
  final bool isTitle;
  final TextAlign? align;
  final double? letterSpacing;
  final int? maxLines;

  CustomText(this.text,
      {this.color = Colors.black,
      this.fontSize = 16,
      this.isBold = false,
      this.textStyle,
      this.maxLines,
      this.dotsAfterOverFlow = false,
      this.fontFamily = "",
      this.fontWeight,
      this.letterSpacing,
      this.isTitle = false,
      this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: dotsAfterOverFlow ? TextOverflow.ellipsis : TextOverflow.visible,
      textAlign: align != null ? align : TextAlign.start,
      style: textStyle != null
          ? textStyle
          : TextStyle(
              fontSize: fontSize,
              fontFamily: isTitle ? "Poppins" : fontFamily,
              fontWeight:
                  isBold ? FontWeight.bold : (fontWeight != null ? fontWeight : FontWeight.normal),
              color: color,
              letterSpacing: letterSpacing ?? 0.2,
            ),
    );
  }
}
