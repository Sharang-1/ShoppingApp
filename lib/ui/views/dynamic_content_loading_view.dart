import 'package:flutter/material.dart';

import '../../controllers/dynamic_content_controller.dart';

class DynamicContentLoadingView extends StatelessWidget {
  final data;
  final _controller = DynamicContentController();

  DynamicContentLoadingView({this.data});

  @override
  Widget build(BuildContext context) {
    _controller.init(context, data: data);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: FittedBox(
            child: Image.asset("assets/images/loading.gif", height: 900),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
