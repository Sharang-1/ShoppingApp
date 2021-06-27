import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/state_manager.dart';

import '../../controllers/reviews_controller.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';
import 'input_field.dart';

class WriteReviewWidget extends StatefulWidget {
  final String id;
  final bool isSeller;
  final bool fromProductList;
  final Function onSubmit;

  WriteReviewWidget(this.id,
      {this.isSeller = false, this.fromProductList = false, this.onSubmit});
  @override
  _WriteReviewWidget createState() => new _WriteReviewWidget();
}

class _WriteReviewWidget extends State<WriteReviewWidget> {
  _WriteReviewWidget();

  double selectedRating;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewsController>(
      init: ReviewsController(),
      builder: (controller) => AnimatedSwitcher(
        duration: Duration(milliseconds: 50),
        child: Obx(
          () => !controller.isFormVisible.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          controller.toggleFormVisibility();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: widget.fromProductList
                              ? textIconOrange
                              : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  width: 1.5, color: textIconOrange)),
                        ),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(children: <Widget>[
                              Icon(
                                Icons.edit,
                                color: widget.fromProductList
                                    ? backgroundWhiteCreamColor
                                    : textIconOrange,
                                size: 16,
                              ),
                              horizontalSpaceSmall,
                              CustomText(
                                "Write Review",
                                isBold: true,
                                fontSize: 16,
                                color: widget.fromProductList
                                    ? backgroundWhiteCreamColor
                                    : textIconOrange,
                              )
                            ]))),
                  ],
                )
              : (controller.isBusyWritingReview.value
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: logoRed,
                                    ),
                                    child: new CustomText(
                                      "Submit",
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await controller.writeReiew(widget.id,
                                          selectedRating, textController.text,
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      controller.toggleFormVisibility();
                                      textController.text = "";
                                    },
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                    )),
        ),
      ),
    );
  }
}
