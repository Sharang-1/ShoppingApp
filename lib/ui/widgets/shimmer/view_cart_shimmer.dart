import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/app_colors.dart';
import '../../shared/shared_styles.dart';
import '../../shared/ui_helpers.dart';

class ViewCartShimmer extends StatelessWidget {
  const ViewCartShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SizedBox(
          height: 150,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(curve10),
                      child: Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: Container(
                          width: 110,
                          height: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            verticalSpaceTiny,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Shimmer.fromColors(
                                    baseColor: shimmerBaseColor,
                                    highlightColor: shimmerHighlightColor,
                                    child: Container(
                                      width: 80,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: shimmerBaseColor,
                                  highlightColor: shimmerHighlightColor,
                                  child: Container(
                                    width: 7,
                                    height: 5,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceTiny,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: shimmerBaseColor,
                                      highlightColor: shimmerHighlightColor,
                                      child: Container(
                                        width: 30,
                                        height: 7,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            verticalSpaceTiny,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Shimmer.fromColors(
                                    baseColor: shimmerBaseColor,
                                    highlightColor: shimmerHighlightColor,
                                    child: Container(
                                      width: 30,
                                      height: 7,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Shimmer.fromColors(
                                    baseColor: shimmerBaseColor,
                                    highlightColor: shimmerHighlightColor,
                                    child: Container(
                                      width: 30,
                                      height: 7,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceTiny,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Shimmer.fromColors(
                                    baseColor: shimmerBaseColor,
                                    highlightColor: shimmerHighlightColor,
                                    child: Container(
                                      width: 30,
                                      height: 7,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceSmall,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceSmall,
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                color: Colors.grey[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: 80,
                        height: 10,
                        color: Colors.white,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: 20,
                        height: 10,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        verticalSpaceTiny,
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                  width: 60,
                  height: 8,
                  color: Colors.white,
                ),
              ),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: Container(
                    width: 90,
                    height: 8,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.grey[500],
        ),
      ],
    ));
  }
}
