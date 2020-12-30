import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:compound/viewmodels/notification_content_view_model.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/widgets/circular_progress_indicator.dart';

class NotificationContentLoadingView extends StatefulWidget {
  final data;

  NotificationContentLoadingView({this.data});

  @override
  _NotificationContentLoadingViewState createState() =>
      _NotificationContentLoadingViewState();
}

class _NotificationContentLoadingViewState
    extends State<NotificationContentLoadingView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NotificationContentViewModel>.withConsumer(
      viewModel: NotificationContentViewModel(),
      onModelReady: (model) => model.init(data: widget.data),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: Center(
          child: CircularProgressIndicatorWidget(),
        ),
      ),
    );
  }
}
