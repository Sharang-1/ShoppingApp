import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../constants/route_names.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/reviews_controller.dart';
import '../../locator.dart';
import '../../models/reviews.dart';
import '../../services/navigation_service.dart';
import '../../utils/tools.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';
import 'write_review_bottomsheet.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({Key key, this.id, this.isSeller = false, this.onSubmit})
      : super(key: key);
  final String id;
  final bool isSeller;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) => GetBuilder<ReviewsController>(
        init: ReviewsController(id: id, isSeller: isSeller),
        global: false,
        builder: (controller) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (isSeller ? "Ratings & Reviews" : "Item Ratings & Reviews")
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.start,
                ),
                (controller.reviews?.ratingAverage != null) &&
                        ((controller?.reviews?.ratingAverage?.person ?? 0) > 0)
                    ? Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Tools.getColorAccordingToRattings(
                                  controller.reviews.items.isNotEmpty
                                      ? controller?.reviews?.ratingAverage
                                              ?.rating ??
                                          5
                                      : 5,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Text(
                              controller.reviews.ratingAverage.rating != null
                                  ? '${controller.reviews.ratingAverage.rating.toStringAsFixed(1)}'
                                  : "0",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Tools.getColorAccordingToRattings(
                                  controller.reviews.items.isNotEmpty
                                      ? controller?.reviews?.ratingAverage
                                              ?.rating ??
                                          5
                                      : 5,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            controller.reviews.ratingAverage.person != null
                                ? "${controller.reviews.ratingAverage.person} Reviews"
                                : "0 Reviews",
                            style: TextStyle(
                              fontSize: subtitleFontSize - 2,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            Column(
              children: [
                if (controller.busy)
                  LinearProgressIndicator(
                    // color: logoRed,
                    backgroundColor: Colors.white,
                  ),
                if (!controller.busy)
                  if ((controller.reviews?.items?.length ?? 0) == 0)
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomText(
                        "No Reviews Yet",
                        fontSize: subtitleFontSize - 2,
                      ),
                    ),
                if (controller.reviews != null &&
                    controller.reviews.items.length > 0)
                  ...controller.reviews.items
                      .sublist(
                          0,
                          controller.reviews.items.length < 3
                              ? controller.reviews.items.length
                              : 3)
                      .map(
                        (Review r) => reviewCard(r),
                      ),
                Column(
                  children: [
                    verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isSeller &&
                            ((controller?.reviews?.items ?? [])
                                .where((e) =>
                                    e.userId ==
                                    locator<HomeController>()?.details?.key)
                                .toList()
                                .isEmpty))
                          TextButton(
                            onPressed: () => Get.bottomSheet(
                                WriteReviewBottomsheet(
                                  id,
                                  isSeller: isSeller,
                                  onSubmit: onSubmit,
                                ),
                                isScrollControlled: true),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: logoRed,
                              textStyle: TextStyle(
                                fontSize: subtitleFontSize,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                                horizontalSpaceTiny,
                                Text(
                                  "Write Review",
                                ),
                              ],
                            ),
                          ),
                        if ((controller?.reviews?.items?.length ?? 0) > 3)
                          InkWell(
                            onTap: () => NavigationService.to(ReviewScreenRoute,
                                arguments: controller?.reviews),
                            child: CustomText(
                              "View All",
                              color: textIconBlue,
                              fontSize: subtitleFontSize,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}

Widget reviewCard(Review r) => Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      (r.userId != null && (r?.reviewer?.length ?? 0) > 0)
                          ? r?.reviewer?.first?.name?.capitalize ??
                              "Unknown User"
                          : "Unknown User",
                      fontSize: subtitleFontSize,
                      isBold: true,
                    ),
                    verticalSpaceTiny,
                    CustomText(
                      (r?.description ?? '').isNotEmpty
                          ? r.description
                          : "No Description",
                      align: TextAlign.justify,
                      fontSize: subtitleFontSize - 2,
                    ),
                  ],
                ),
              ),
              horizontalSpaceTiny,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBarIndicator(
                    rating: r?.rating != null ? r?.rating?.toDouble() : 0,
                    itemCount: 5,
                    itemSize: 15,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  verticalSpaceTiny,
                  CustomText(
                    (r?.modified?.split(" "))[0],
                    align: TextAlign.end,
                    fontSize: subtitleFontSize - 2,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
