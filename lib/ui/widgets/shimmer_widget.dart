import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../shared/app_colors.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        width: 2000,
        height: 2000,
        color: Colors.white,
      ),
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
    );
  }
}
