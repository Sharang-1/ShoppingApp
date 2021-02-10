import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:compound/viewmodels/dynamic_content_view_model.dart';
import 'package:compound/ui/shared/app_colors.dart';
// import 'package:compound/ui/widgets/circular_progress_indicator.dart';

class DynamicContentLoadingView extends StatefulWidget {
  final data;

  DynamicContentLoadingView({this.data});

  @override
  _DynamicContentLoadingViewState createState() =>
      _DynamicContentLoadingViewState();
}

class _DynamicContentLoadingViewState extends State<DynamicContentLoadingView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DynamicContentViewModel>.withConsumer(
      viewModel: DynamicContentViewModel(),
      onModelReady: (model) => model.init(context, data: widget.data),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: Center(
          child: Container(
            child: FittedBox(
              child: Image.asset("assets/images/loading.gif", height: 900),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
