import 'package:compound/models/reviews.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
// import 'package:compound/ui/widgets/busy_button.dart';
// import 'package:compound/ui/widgets/expansion_list.dart';
// import 'package:compound/ui/widgets/input_field.dart';
import 'package:compound/viewmodels/reviews_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ReviewWidget extends StatelessWidget {
  ReviewWidget({this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ReviewsViewModel>.withConsumer(
        viewModel: ReviewsViewModel(),
        builder: (
          context,
          model,
          child,
        ) =>
            ListTileTheme(
                contentPadding: EdgeInsets.all(0),
                child: ExpansionTile(
                    title: Text(
                      "Ratings & Reviews",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: model.reviews?.ratingAverage != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.green,
                                  avatar: Text(
                                    model.reviews.ratingAverage.rating != null
                                        ? '${model.reviews.ratingAverage.rating}'
                                        : "0",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  labelPadding: EdgeInsets.all(0),
                                  label: Icon(Icons.star,
                                      size: 16, color: Colors.white),
                                ),
                                Text(
                                    model.reviews.ratingAverage.person != null
                                        ? "${model.reviews.ratingAverage.person} Ratings"
                                        : "0 Ratings",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                                Text(
                                    model.reviews.ratingAverage.total != null
                                        ? "${model.reviews.ratingAverage.total} Reviews"
                                        : "0 Reviews",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey))
                              ])
                        // : Container()
                        : Container(),
                    initiallyExpanded: false,
                    onExpansionChanged: (bool expanded) {
                      if (expanded && model.reviews == null) {
                        model.showReviews(id);
                      }
                    },
                    children: <Widget>[
                      if (model.busy) LinearProgressIndicator(),
                      if (!model.busy)
                        if (model.reviews?.items?.length == 0)
                          Text("No Reviews"),
                      if (model.reviews != null &&
                          model.reviews.items.length > 0)
                        ...model.reviews.items.map((Review r) {
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
                      radius: 20,
                      foregroundColor: Colors.white,
                      child: Text(
                        "DZ",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(r.userId != null
                                      ? r.userId
                                      : "Unknown User"),
                                  verticalSpaceTiny,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RatingBarIndicator(
                                        rating: r.rating != null
                                            ? r.rating.toDouble()
                                            : 0,
                                        itemCount: 5,
                                        itemSize: 15,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text(
                                        (r.modified.split(" "))[0],
                                        textAlign: TextAlign.end,
                                      )
                                    ],
                                  )
                                ])))
                  ],
                ),
                verticalSpaceSmall,
                Text(
                  r.description != null ? r.description : "No Description",
                  textAlign: TextAlign.justify,
                ),
                verticalSpaceSmall,
              ],
            )));
  }
}
