import 'package:compound/viewmodels/otp_finished_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/circular_progress_indicator.dart';
import '../shared/shared_styles.dart';
import '../shared/app_colors.dart';

class otpFinishedScreen1 extends StatelessWidget {
  final bool fromCart;

  const otpFinishedScreen1({Key key, this.fromCart}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const double subtitleFontSize = subtitleFontSizeStyle - 1;
    return ViewModelProvider<OtpFinishedScreenModel>.withConsumer(
      viewModel: OtpFinishedScreenModel(),
      onModelReady: (model) => model.init(1, fromCart),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Stack(alignment: Alignment.center, children: <Widget>[
              fromCart && model.displaySymbol
                  ? Icon(
                      Icons.check,
                      color: green,
                      size: MediaQuery.of(context).size.width * 0.2,
                    )
                  : SvgPicture.asset(
                      "assets/svg/logo.svg",
                      color: logoRed,
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.width / 2.5,
                    ),
              CircularProgressIndicatorWidget(
                fromCart: fromCart ? true : false,
              )
            ]),
            !fromCart
                ? Container()
                : !model.displaySymbol
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                        child: Column(children: <Widget>[
                          Text(
                            "Your order has been received for",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: headingFont,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: subtitleFontSize),
                          ),
                          Text(
                            "Nike Shoes by Nike pvt lmt.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: headingFont,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: subtitleFontSize),
                          )
                        ]),
                      )
          ]),
        ),
      ),
    );
  }
}
