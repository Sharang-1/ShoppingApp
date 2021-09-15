import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../services/navigation_service.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
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
            child: Image.asset("assets/images/new_loading.gif"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
