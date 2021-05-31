import 'package:compound/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../controllers/reviews_controller.dart';
import '../../models/reviews.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';

class ReviewWidget extends StatelessWidget {
  ReviewWidget({Key key, this.id, this.expanded = false, this.isSeller = false})
      : super(key: key);
  final String id;
  final bool expanded;
  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewsController>(
        init: ReviewsController(id: id, isSeller: isSeller),
        builder: (controller) => ListTileTheme(
            contentPadding: EdgeInsets.all(0),
            child: ExpansionTile(
                title: Text(
                  "Ratings & Reviews",
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: controller.reviews?.ratingAverage != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor:
                                  Tools.getColorAccordingToRattings(
                                      controller.reviews.items.isNotEmpty
                                          ? controller?.reviews?.ratingAverage
                                                  ?.rating ??
                                              5
                                          : 5),
                              avatar: Text(
                                controller.reviews.ratingAverage.rating != null
                                    ? '${controller.reviews.ratingAverage.rating}'
                                    : "0",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              labelPadding: EdgeInsets.all(0),
                              label: Icon(Icons.star,
                                  size: 16, color: Colors.white),
                            ),
                            Text(
                              controller.reviews.ratingAverage.person != null
                                  ? "${controller.reviews.ratingAverage.person} Reviews"
                                  : "0 Reviews",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            // Text(
                            //     controller.reviews.ratingAverage.total != null
                            //         ? "${controller.reviews.ratingAverage.total} Reviews"
                            //         : "0 Reviews",
                            //     style: TextStyle(
                            //         fontSize: 14, color: Colors.grey))
                          ])
                    // : Container()
                    : Container(),
                initiallyExpanded: expanded,
                // onExpansionChanged: (bool expanded) {
                //   if (expanded && controller.reviews == null) {
                //     controller.showReviews(id);
                //   }
                // },
                children: <Widget>[
                  if (controller.busy) LinearProgressIndicator(),
                  if (!controller.busy)
                    if (controller.reviews?.items?.length == 0)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No Reviews"),
                      ),
                  if (controller.reviews != null &&
                      controller.reviews.items.length > 0)
                    ...controller.reviews.items.map((Review r) {
                      return _reviewCard(r);
                    })
                ])));
  }

  _reviewCard(Review r) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: lightGrey,
                  radius: 22,
                  foregroundColor: Colors.white,
                  child: Text(
                    ((r?.reviewer?.length ?? 0) > 0)
                        ? r?.reviewer?.first?.name != null
                            ? r?.reviewer?.first?.name
                                ?.substring(0, 1)
                                ?.toUpperCase()
                            : 'U'
                        : 'U',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text((r.userId != null &&
                                      (r?.reviewer?.length ?? 0) > 0)
                                  ? r.reviewer.first.name
                                  : "Unknown User"),
                              verticalSpaceTiny,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RatingBarIndicator(
                                    rating: r?.rating != null
                                        ? r?.rating?.toDouble()
                                        : 0,
                                    itemCount: 5,
                                    itemSize: 15,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  Text(
                                    (r?.modified?.split(" "))[0],
                                    textAlign: TextAlign.end,
                                  )
                                ],
                              )
                            ])))
              ],
            ),
            verticalSpaceSmall,
            Text(
              (r?.description ?? '').isNotEmpty
                  ? r.description
                  : "No Description",
              textAlign: TextAlign.justify,
            ),
            verticalSpaceSmall,
          ],
        ),
      ),
    );
  }
}
