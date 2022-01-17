import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/app_colors.dart';
import '../../shared/shared_styles.dart';
import '../../shared/ui_helpers.dart';

class MyOrdersShimmer extends StatelessWidget {
  const MyOrdersShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: Container(
                      width: 80,
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                //  horizontalSpaceSmall,
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: Container(
                      width: 120,
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                horizontalSpaceSmall,
              ],
            ),
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
                              width: 100,
                              height: 100,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(1),
                                      child: Shimmer.fromColors(
                                        baseColor: shimmerBaseColor,
                                        highlightColor: shimmerHighlightColor,
                                        child: Container(
                                          width: 80,
                                          height: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceTiny,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: shimmerBaseColor,
                                          highlightColor: shimmerHighlightColor,
                                          child: Container(
                                            width: 35,
                                            height: 8,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                verticalSpaceTiny,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(1),
                                      child: Shimmer.fromColors(
                                        baseColor: shimmerBaseColor,
                                        highlightColor: shimmerHighlightColor,
                                        child: Container(
                                          width: 35,
                                          height: 8,
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
                                          width: 15,
                                          height: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceTiny,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(1),
                                      child: Shimmer.fromColors(
                                        baseColor: shimmerBaseColor,
                                        highlightColor: shimmerHighlightColor,
                                        child: Container(
                                          width: 35,
                                          height: 8,
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
                ],
              ),
            ),
          ],
        ));
  }
}
