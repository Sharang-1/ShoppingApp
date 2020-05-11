import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/viewmodels/otp_finished_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/circular_progress_indicator.dart';
import '../shared/shared_styles.dart';

class otpFinishedScreen1 extends StatelessWidget {
  final bool fromCart;

  const otpFinishedScreen1({Key key, this.fromCart}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<OtpFinishedScreenModel>.withConsumer(
      viewModel: OtpFinishedScreenModel(),
      onModelReady: (model) => model.init(1, fromCart),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            Stack(alignment: Alignment.center, children: <Widget>[
              fromCart && model.displaySymbol
                  ? Icon(
                      Icons.check,
                      color: Colors.green[800],
                      size: MediaQuery.of(context).size.width * 0.2,
                    )
                  : Image.asset(
                      'assets/images/logo_red.png',
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.width / 2.5,
                    ),
              CircularProgressIndicatorWidget(
                fromCart: fromCart ? true : false,
              )
            ]),
            verticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
              child: Text(
                "Your order has been received \nfor Nike Shoes \n by Nike pvt lmt.",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontFamily: headingFont, color: Colors.grey[700],fontWeight: FontWeight.bold,fontSize: 22),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
