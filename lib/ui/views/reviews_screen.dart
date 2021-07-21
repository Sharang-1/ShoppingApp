import 'package:flutter/material.dart';

import '../../models/reviews.dart';
import '../shared/shared_styles.dart';
import '../widgets/reviews.dart';

class ReviewsScreen extends StatelessWidget {
  final Reviews reviews;
  const ReviewsScreen({Key key, @required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Ratings & Reviews",
          style: TextStyle(
            fontFamily: headingFont,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...reviews.items.map((e) => reviewCard(e)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
