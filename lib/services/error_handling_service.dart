import 'dart:async';
import 'package:compound/models/internet_connection.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fimber/fimber.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:catcher/catcher.dart';

// CatcherOptions debugOptions = CatcherOptions(
//   DialogReportMode(),
//   [
//     EmailManualHandler(
//       ["admin@dzor.in"],
//       emailTitle: "Dzor App Exception",
//     ),
//     ConsoleHandler()]
// );

// CatcherOptions  releaseOptions = CatcherOptions(
//   PageReportMode(),
//   [
//     EmailManualHandler(
//       ["admin@dzor.in"],
//       emailTitle: "Dzor App Exception",
//     ),
//     ConsoleHandler(),
//   ]
// );

class ErrorHandlingService {
  InternetConnectionStatus _connectionStatus =
      InternetConnectionStatus.NotConnected;
  StreamSubscription<DataConnectionStatus> listener;
  bool _isDialogShowing = false;

  InternetConnectionStatus get connectionStatus => _connectionStatus;

  Future<void> init() async {
    try {
      listener = DataConnectionChecker()
          .onStatusChange
          .listen(_updateConnectionStatus);
    } catch (e) {
      Fimber.e(e.toString());
    }
  }

  void dispose() => listener.cancel();

  Future<void> _updateConnectionStatus(DataConnectionStatus status) async {
    switch (status) {
      case DataConnectionStatus.connected:
        _connectionStatus = InternetConnectionStatus.Connected;
        if (_isDialogShowing) {
          _isDialogShowing = false;
          Get.back();
        }
        Fimber.i("Internet Connected");
        return;
      case DataConnectionStatus.disconnected:
        _connectionStatus = InternetConnectionStatus.NotConnected;
        // showError(Errors.NoInternetConnection);
        if (!_isDialogShowing) {
          await Get.dialog<AlertDialog>(
              AlertDialog(
                title: Text("No Internet Connection"),
                content: Image.asset(
                  'assets/images/no_internet.png',
                  height: 300,
                  width: 300,
                ),
              ),
              barrierDismissible: true);
          _isDialogShowing = true;
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
      Get.snackbar(appErrors[error].errorMsg.capitalize, msg,
          snackPosition: SnackPosition.BOTTOM);
  }
}

//Application Error Class
class AppError {
  final int errorCode; //used to identify error
  final String errorMsg; //msg to be displayed

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
