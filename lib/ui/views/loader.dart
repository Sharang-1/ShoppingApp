import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../services/navigation_service.dart';

// ignore: camel_case_types
class loader extends StatefulWidget {
  @override
  _loaderState createState() => _loaderState();
}

// ignore: camel_case_types
class _loaderState extends State<loader> with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1),
        () => NavigationService.offAll(HomeViewRoute));
  }

  @override
  Widget build(BuildContext context) {
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
