import 'package:flutter/material.dart';
import '../shared/app_colors.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/locator.dart';
import 'dart:async';

class loader extends StatefulWidget {
  @override
  _loaderState createState() => _loaderState();
}

class _loaderState extends State<loader> with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
    final NavigationService _navigationService = locator<NavigationService>();
    Future.delayed(const Duration(seconds: 1),
        () => _navigationService.navigateReplaceTo(HomeViewRoute));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhiteCreamColor,
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
