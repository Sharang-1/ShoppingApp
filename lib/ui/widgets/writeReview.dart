// import 'package:compound/ui/widgets/busy_button.dart';
// import 'package:compound/ui/widgets/expansion_list.dart';
import 'package:compound/viewmodels/reviews_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';
import 'input_field.dart';

class WriteReviewWidget extends StatefulWidget {
  final String id;
  final bool isSeller;
  final Function onSubmit;
  WriteReviewWidget(this.id, {this.isSeller = false, this.onSubmit});
  @override
  _WriteReviewWidget createState() => new _WriteReviewWidget();
}

class _WriteReviewWidget extends State<WriteReviewWidget> {
  _WriteReviewWidget();

  double selectedRating;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ReviewsViewModel>.withConsumer(
        viewModel: ReviewsViewModel(),
        builder: (
          context,
          model,
          child,
        ) =>
            AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              child: !model.isFormVisible
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              model.toggleFormVisibility();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: backgroundWhiteCreamColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                      width: 1.5, color: textIconOrange)
                                  // side: BorderSide(
                                  //     color: Colors.black, width: 0.5)
                                  ),
                            ),
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    color: textIconOrange,
                                    size: 16,
                                  ),
                                  horizontalSpaceSmall,
                                  CustomText(
                                    "Write Review",
                                    isBold: true,
                                    fontSize: 16,
                                    color: textIconOrange,
                                  )
                                ]))),
                      ],
                    )
                  : (model.isBusyWritingReview
                      ? CircularProgressIndicator()
                      : Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(curve15),
                          ),
                          child: Container(
                            height: 202,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: InputField(
                                    controller: textController,
                                    placeholder: 'Write a Review',
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  unratedColor: Colors.grey[400],
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    selectedRating = rating;
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          backgroundColor: logoRed,
                                        ),
                                        child: new CustomText(
                                          "Submit",
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          await model.writeReiew(
                                              widget.id,
                                              selectedRating,
                                              textController.text,
                                              isSellerReview: widget.isSeller);
                                          textController.text = "";
                                          if (widget.onSubmit != null)
                                            widget.onSubmit();
                                        },
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      new TextButton(
                                        child: new CustomText(
                                          "Cancel",
                                          color: Colors.white,
                                        ),
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          backgroundColor: Colors.grey[400],
                                        ),
                                        onPressed: () {
                                          model.toggleFormVisibility();
                                          textController.text = "";
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ))),
            ));
  }
}
