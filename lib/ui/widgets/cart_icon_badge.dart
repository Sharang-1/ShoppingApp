import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shared/app_colors.dart';

class CartIconWithBadge extends StatelessWidget {
  final iconColor;
  final int count;

  const CartIconWithBadge({
    Key key,
    @required this.iconColor,
    this.count = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            color: iconColor,
            height: 26,
            width: 26,
          ),
        ),
        count > 0
            ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: logoRed,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Text(
                    count.toString(),
                    style: TextStyle(fontSize: 8),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
