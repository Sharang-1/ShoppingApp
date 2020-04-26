import 'package:compound/models/reviews.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/busy_button.dart';
import 'package:compound/ui/widgets/expansion_list.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:compound/viewmodels/reviews_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ReviewWidget extends StatelessWidget {
  String productId;
  ReviewWidget(@required productId);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ReviewsViewModel>.withConsumer(
        viewModel: ReviewsViewModel(),
        builder: (context, model, child) => ExpansionTile(
              title: Text("Reviews"),
              initiallyExpanded: false,
              onExpansionChanged: (bool expanded) {
                if(expanded && model.reviews == null){
                  model.showReviews(productId);
                }
              },
              children: <Widget>[
                if(model.busy)
                  LinearProgressIndicator(),
                if(!model.busy)
                  if(model.reviews?.items?.length == 0)
                    Text("No Reviews"),
                  if(model.reviews !=null && model.reviews.items.length > 0)
                    ...model.reviews.items.map((Review r) {
                      return Text(r.rating.toString());
                    }),
              ],
            ));
  }
}
