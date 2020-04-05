import 'package:flutter/material.dart';

class NetworkImageWithPlaceholder extends StatelessWidget {
  const NetworkImageWithPlaceholder({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: AssetImage("assets/images/tile_ui_placeholder.jpg"),
      image: NetworkImage(
        "http://52.66.141.191/api/photos/" + (name ?? "test.jpg"),
      ),
    );
  }
}
