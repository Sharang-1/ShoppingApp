import 'package:compound/models/CartCountSetUp.dart';
import 'package:compound/models/WhishListSetUp.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/home_view_list.dart';
import 'package:compound/ui/widgets/drawer.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../shared/app_colors.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/cart_icon_badge.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/viewmodels/otp_finished_view_model.dart';
import 'package:compound/viewmodels/loading_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../shared/shared_styles.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/productPageArg.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/cart_local_store_service.dart';
import 'package:compound/services/whishlist_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class loader extends StatefulWidget {
  @override
  _loaderState createState() => _loaderState();
}

class _loaderState extends State<loader> with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.pushNamed(context, HomeViewRoute)
        );
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<loadModel>.withConsumer(
    viewModel: loadModel(),
    onModelReady: (model) => model.init(2, false, false),
    builder: (context, model, child) => Scaffold(
    backgroundColor: backgroundWhiteCreamColor,
    body:Center(
    child: Container(
    child: FittedBox(
    child: Image.asset("assets/images/loading.gif", height: 900),
    fit: BoxFit.cover,
    ),))));
  }

}
