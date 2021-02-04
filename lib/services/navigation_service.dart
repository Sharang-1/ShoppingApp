import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  pop() {
    return _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments, bool popNavbar = false}) {
    if(popNavbar)
      pop();
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateReplaceTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndRemoveUntil(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }
}
