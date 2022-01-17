import 'package:flutter/material.dart';

import '../shared/app_colors.dart';

class CartIconWithBadge extends StatelessWidget {
  final iconColor;
  final int count;

  const CartIconWithBadge({
    Key? key,
    required this.iconColor,
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
          child: Image.asset(
            "assets/images/shopping.png",
            color: iconColor,
            height: 30,
            width: 30,
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
                  padding: EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
