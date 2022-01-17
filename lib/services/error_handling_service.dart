import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/internet_connection.dart';
import 'dialog_service.dart';

class ErrorHandlingService {
  InternetConnectionStatus _connectionStatus =
      InternetConnectionStatus.NotConnected;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> listener;
  bool isDialogOpen = false;

  InternetConnectionStatus get connectionStatus => _connectionStatus;

  Future<void> init() async {
    try {
      listener =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch (e) {
      Fimber.e(e.toString());
    }
  }

  void dispose() => listener.cancel();

  Future<void> _updateConnectionStatus(ConnectivityResult status) async {
    if (status == ConnectivityResult.mobile) {
      _connectionStatus = InternetConnectionStatus.Connected;
      DialogService.popDialog();
      isDialogOpen = false;
      Fimber.i("Internet Connected");
      return;
    } else if (status == ConnectivityResult.wifi) {
      _connectionStatus = InternetConnectionStatus.Connected;
      DialogService.popDialog();
      isDialogOpen = false;
      Fimber.i("Internet Connected");
      return;
    } else {
      _connectionStatus = InternetConnectionStatus.NotConnected;
      if (!isDialogOpen) {
        await DialogService.showCustomDialog(
            AlertDialog(
              title: Text("No Internet Connection"),
              content: Image.asset(
                'assets/images/no_internet.jpg',
                height: 300,
                width: 300,
              ),
            ),
            barrierDismissible: false,
            routeSettings: null);
        isDialogOpen = true;
      }
      Fimber.i("Internet Disconnect");
      return;
    }
  }

//App Errors
  Map<Errors, AppError> appErrors = {
    Errors.NoInternetConnection:
        AppError(errorCode: 101, errorMsg: "No Internet Connection"),
    Errors.PoorConnection:
        AppError(errorCode: 102, errorMsg: "Poor Internet Connection"),
    Errors.CouldNotLoadImage:
        AppError(errorCode: 201, errorMsg: "Could Not Load An Image"),
    Errors.CouldNotAddToCart:
        AppError(errorCode: 601, errorMsg: "Could Not Add To Cart"),
    Errors.CouldNotPlaceAnOrder:
        AppError(errorCode: 611, errorMsg: "Could Not Place An Order"),
  };

  void showError(Errors error, {String msg = ''}) {
    if (appErrors[error]?.errorMsg != null)
      Get.snackbar(appErrors[error]!.errorMsg!.capitalize!, msg,
          snackPosition: SnackPosition.BOTTOM);
  }
}

//Application Error Class
class AppError {
  final int? errorCode; //used to identify error
  final String? errorMsg; //msg to be displayed

  @override
  AppError({this.errorCode, this.errorMsg}); //constructor
}

//Errors Enumerations
enum Errors {
  //Network Related Errors
  NoInternetConnection,
  PoorConnection,

  //Image Related Errors
  CouldNotLoadImage,

  //Product Related Errors

  //Seller Related Errors

  //Cart and Order Related Errors
  CouldNotAddToCart,
  CouldNotPlaceAnOrder
}
