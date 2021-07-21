import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../locator.dart';
import '../../services/api/api_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class WriteReviewBottomsheet extends StatefulWidget {
  final String id;
  final bool isSeller;
  final bool fromProductList;
  final Function onSubmit;

  WriteReviewBottomsheet(this.id,
      {this.isSeller = false, this.fromProductList = false, this.onSubmit});

  @override
  _WriteReviewBottomsheetState createState() => _WriteReviewBottomsheetState();
}

class _WriteReviewBottomsheetState extends State<WriteReviewBottomsheet> {
  final textController = TextEditingController();

  final APIService _apiService = locator<APIService>();
  bool isBusyWritingReview = false;
  bool isFormVisible = false;
  double selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "Write a Review",
                  fontSize: titleFontSize + 2,
                  isBold: true,
                ),
                IconButton(
                  tooltip: "Close",
                  iconSize: 28,
                  icon: Icon(CupertinoIcons.clear_circled_solid),
                  color: Colors.grey[600],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          (isBusyWritingReview
              ? Center(
                  child: Image.asset(
                    "assets/images/loading_img.gif",
                    height: 50,
                    width: 50,
                  ),
                )
              : Container(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    backgroundColor: logoRed,
                                  ),
                                  child: new CustomText(
                                    "Submit",
                                    fontSize: titleFontSize,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await writeReview(widget.id, selectedRating,
                                        textController.text,
                                        isSellerReview: widget.isSeller);
                                    textController.text = "";
                                    if (widget.onSubmit != null)
                                      await widget.onSubmit();
                                    NavigationService.back();
                                  },
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                )),
        ],
      ),
    );
  }

  Future writeReview(String key, double ratings, String description,
      {isSellerReview = false}) async {
    setState(() => isBusyWritingReview = true);

    var _ = await _apiService.postReview(key, ratings, description,
        isSellerReview: isSellerReview);

    setState(() => isBusyWritingReview = false);
  }
}
