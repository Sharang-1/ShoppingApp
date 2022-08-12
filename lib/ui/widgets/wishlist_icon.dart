import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shared/app_colors.dart';

class WishListIcon extends StatelessWidget {
  final double width;
  final double height;
  final bool filled;

  const WishListIcon(
      {Key? key,
      required this.width,
      required this.height,
      required this.filled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30, width: 30,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(shape : BoxShape.circle, color: Colors.white),
      child: Center(
        child: SvgPicture.asset(
          "assets/svg/wishlist.svg",
          color: filled ? logoRed : Colors.grey[300],
          height: height,
          width: width,
        ),
      ),
    );
  }
}
