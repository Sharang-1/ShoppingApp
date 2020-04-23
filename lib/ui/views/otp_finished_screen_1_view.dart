import 'package:compound/viewmodels/otp_finished_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/circular_progress_indicator.dart';
class otpFinishedScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<OtpFinishedScreenModel>.withConsumer(
      viewModel: OtpFinishedScreenModel(),
      onModelReady: (model) => model.init(1),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Image.asset(
              'assets/images/logo_red.png',
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
            ),
            CircularProgressIndicatorWidget()
          ]),
        ),
      ),
    );
  }
}
