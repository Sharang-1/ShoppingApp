import 'package:compound/models/products.dart';
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
    final originalName = photos != null ? photos[0].originalName ?? null : null;
    final name = photos != null ? photos[0].name ?? null : null;

    // print("Image : ::::::::::::::::::::::::::::::::");
    // print("http://52.66.141.191/api/photos/" + originalName.toString());
    // print("http://52.66.141.191/api/photos/" + name.toString());
    return Card(
      child: Stack(
        children: <Widget>[
          FadeInImage(
            placeholder: AssetImage("assets/images/tile_ui_placeholder.jpg"),
            image: NetworkImage(
              "http://52.66.141.191/api/photos/" + (originalName ?? "test.jpg"),
            ),
          ),
          Container(height: 20, child: Text("Testing"),)
        ],
      ),
    );
  }
}
