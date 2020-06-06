import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shared/app_colors.dart';

class CartIconWithBadge extends StatelessWidget {
  final IconColor;

  const CartIconWithBadge({Key key,@required this.IconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        SizedBox(
          width: 30,
          height: 30,
        ),
        Positioned(
          top: 4,
          child: SvgPicture.asset(
            "assets/svg/bag.svg",
            color: IconColor,
            height: 26,
            width: 26,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: logoRed,
            ),
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Text(
              "8",
              style: TextStyle(fontSize: 8),
            ),
          ),
        )
      ],
    );
  }
}
