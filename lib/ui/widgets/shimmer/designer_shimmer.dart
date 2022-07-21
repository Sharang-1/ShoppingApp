import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/app_colors.dart';
import '../../shared/ui_helpers.dart';

class DesignerShimmer extends StatelessWidget {
  final bool isID3;
  const DesignerShimmer({this.isID3 = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0, bottom: 10, right: 0),
      height: 200.0,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, style: BorderStyle.solid),
        ),
      ),
      width: MediaQuery.of(context).size.width - 40,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical :5, horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black38,
                              width: 0.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Shimmer.fromColors(
                              baseColor: shimmerBaseColor,
                              highlightColor: shimmerHighlightColor,
                              child: Container(
                                width: 48,
                                height: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        horizontalSpaceSmall,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: shimmerBaseColor,
                                highlightColor: shimmerHighlightColor,
                                child: Container(
                                  width: 120,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ),
                              verticalSpaceSmall,
                              Shimmer.fromColors(
                                baseColor: shimmerBaseColor,
                                highlightColor: shimmerHighlightColor,
                                child: Container(
                                  width: 120,
                                  height: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: Container(
                          width: 50,
                          height: 10,
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 5,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      verticalSpaceSmall,
                      Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: Container(
                          color: Colors.white,
                          width: 50,
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpaceSmall,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        color: Colors.white,
                        width: 60,
                        height: 10,
                      ),
                    ),
                    if (!isID3)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(
                            width: 40,
                            height: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (!isID3) verticalSpaceSmall,
              if (!isID3)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                    (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Shimmer.fromColors(
                            baseColor: shimmerBaseColor,
                            highlightColor: shimmerHighlightColor,
                            child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        verticalSpaceTiny,
                        Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(
                            height: 12,
                            width: 60,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
