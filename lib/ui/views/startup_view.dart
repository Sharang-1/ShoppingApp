import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../viewmodels/startup_view_model.dart';
import '../shared/app_colors.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
      viewModel: StartUpViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: backgroundWhiteCreamColor,
          body: Center(
            child: SvgPicture.asset(
              "assets/svg/dzor_logo.svg",
              color: logoRed,
              width: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.contain,
            ),
          )),
    );
  }
}