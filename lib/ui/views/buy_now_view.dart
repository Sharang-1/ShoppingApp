import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../models/grid_view_builder_filter_models/cartFilter.dart';
import '../../viewmodels/buy_now_view_model.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/CartTileUI.dart';
import '../widgets/custom_stepper.dart';

class BuyNowView extends StatefulWidget {
  BuyNowView({Key key}) : super(key: key);

  @override
  _BuyNowViewState createState() => _BuyNowViewState();
}

class _BuyNowViewState extends State<BuyNowView> {
  CartFilter filter = CartFilter();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BuyNowViewModel>.withConsumer(
      viewModel: BuyNowViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundWhiteCreamColor,
          centerTitle: true,
          title: SvgPicture.asset(
            "assets/svg/logo.svg",
            color: logoRed,
            height: 35,
            width: 35,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        backgroundColor: backgroundWhiteCreamColor,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: screenPadding,
                right: screenPadding,
                top: 10,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  verticalSpace(20),
                  Text(
                    "Cart",
                    style: TextStyle(
                        fontFamily: headingFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 30),
                  ),
                  verticalSpace(10),
                  const CutomStepper(
                    step: 1,
                  ),
                  verticalSpace(20),
                  CartTileUI(
                    index: 1,
                    item: null,
                    onDelete: (int index) async {
                      // await onDelete(index);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
