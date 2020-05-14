import 'package:flutter/material.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WishListIcon extends StatelessWidget {
  final double width;
  final double height;
  final bool filled ; 

  const WishListIcon({Key key,@required this.width,@required this.height,@required this.filled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SvgPicture.asset("assets/svg/wishlist.svg",color: filled ? logoRed : Colors.grey,height: height,width: width,);
  }
}
