import 'package:compound/models/products.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';

class ProductTileUI extends StatelessWidget {
  final Product data;

  const ProductTileUI({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photo = data.photo ?? null;
    final photos = photo != null ? photo.photos ?? null : null;
    final String originalPhotoName =
        photos != null ? photos[0].originalName ?? null : null;
    final String productName = data.name ?? "No name";
    final double productDiscount = data.discount ?? 0.0;
    final double productPrice = data.price ?? 0.0;
    final double productOldPrice = data.oldPrice ?? 0.0;
    final productRatingObj = data.rating ?? null;
    final productRatingValue =
        productRatingObj != null ? productRatingObj.rate : 0.0;
    String getTruncatedString(int length, String str) {
      return str.length <= length ? str : '${str.substring(0, length)}...';
    }

    // print("Image : ::::::::::::::::::::::::::::::::");
    // print("http://52.66.141.191/api/photos/" + originalName.toString());
    // print("http://52.66.141.191/api/photos/" + name.toString());

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NetworkImageWithPlaceholder(name: originalPhotoName),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(getTruncatedString(20, productName)),
                Text('Ratings: ${productRatingValue.toString()}',
                    style: TextStyle(color: Colors.grey, fontSize: 10.0)),
                Row(
                  children: <Widget>[
                    Text('Rs.${productPrice.toString()}'),
                    SizedBox(
                      width: 5.0,
                    ),
                    // if (productOldPrice != 0.0)
                    Text(
                      'Rs.${productOldPrice.toString()}',
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                Text('${productDiscount.toString()}%'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
