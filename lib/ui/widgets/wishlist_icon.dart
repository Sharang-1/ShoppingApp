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
    return SvgPicture.asset(
      "assets/svg/wishlist.svg",
      color: filled ? logoRed : Colors.grey[100],
      height: height,
      width: width,
    );
  }
}
