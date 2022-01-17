import 'package:flutter/material.dart';

import '../shared/app_colors.dart';

class ProfileSetupIndicator extends StatelessWidget {
  ProfileSetupIndicator({
    Key? key,
    this.width = 12,
    this.height = 12,
  }) : super(key: key);
  final double width;
  final double height;
  final Color color = logoRed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
