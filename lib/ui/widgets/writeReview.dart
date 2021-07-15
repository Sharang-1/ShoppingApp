import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../locator.dart';
import '../../services/api/api_service.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class WriteReviewWidget extends StatefulWidget {
  final String id;
  final bool isSeller;
  final bool fromProductList;
  final Function onSubmit;

  WriteReviewWidget(this.id,
      {this.isSeller = false, this.fromProductList = false, this.onSubmit});

  @override
  _WriteReviewWidgetState createState() => _WriteReviewWidgetState();
}

class _WriteReviewWidgetState extends State<WriteReviewWidget> {
  final textController = TextEditingController();

  final APIService _apiService = locator<APIService>();
  bool isBusyWritingReview = false;
  bool isFormVisible = false;
  double selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return !isFormVisible
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    toggleFormVisibility();
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        widget.fromProductList ? textIconOrange : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 1.5, color: textIconOrange)),
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
        : (isBusyWritingReview
            ? Image.asset(
                "assets/images/loading_img.gif",
                height: 50,
                width: 50,
              )
            : Card(
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 200,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                hintText: 'Write a Review',
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                            ),
                          ),
                          verticalSpaceTiny,
                          RatingBar.builder(
                            initialRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await writeReview(widget.id, selectedRating,
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
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    toggleFormVisibility();
                                    textController.text = "";
                                  },
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ));
  }

  void toggleFormVisibility() {
    setState(() => isFormVisible = !isFormVisible);
  }

  Future writeReview(String key, double ratings, String description,
      {isSellerReview = false}) async {
    setState(() => isBusyWritingReview = true);

    var _ = await _apiService.postReview(key, ratings, description,
        isSellerReview: isSellerReview);

    setState(() => isBusyWritingReview = false);
    toggleFormVisibility();
  }
}
