import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/app_colors.dart';
import '../../shared/ui_helpers.dart';

class ExploreProductShimmer extends StatelessWidget {
  const ExploreProductShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 5.0, color: Colors.grey[300]!))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ClipOval(
                  child: Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                horizontalSpaceSmall,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor: shimmerBaseColor,
                            highlightColor: shimmerHighlightColor,
                            child: Container(
                              width: double.infinity,
                              height: 10,
                              color: Colors.white,
                            ),
                          ),
                          verticalSpaceTiny,
                          Shimmer.fromColors(
                            baseColor: shimmerBaseColor,
                            highlightColor: shimmerHighlightColor,
                            child: Container(
                              width: double.infinity,
                              height: 8,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceTiny,
          Expanded(
            child: Shimmer.fromColors(
              baseColor: shimmerBaseColor,
              highlightColor: shimmerHighlightColor,
              child: Container(
                  width: Get.size.width,
                  height: Get.size.width,
                  color: Colors.white),
            ),
          ),
          verticalSpaceTiny,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: shimmerBaseColor,
                            highlightColor: shimmerHighlightColor,
                            child: Container(
                              height: 10,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                          verticalSpaceTiny,
                          Shimmer.fromColors(
                            baseColor: shimmerBaseColor,
                            highlightColor: shimmerHighlightColor,
                            child: Container(
                              height: 10,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Shimmer.fromColors(
                            baseColor: shimmerBaseColor,
                            highlightColor: shimmerHighlightColor,
                            child: Container(
                              width: double.infinity,
                              height: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Divider(
                  color: Colors.grey[400],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          margin: EdgeInsets.only(left: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          height: 14,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Container(
                      height: 25,
                      child: VerticalDivider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: Container(
                          height: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceSmall,
            ],
          ),
        ],
      ),
    );
  }
}
