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


//Application Error Class
class AppError{
  final int errorCode; //used to identify error
  final String errorMsg; //msg to be displayed

  @override
  AppError({this.errorCode, this.errorMsg}); //constructor
}

//Errors Enumerations
enum Errors{
  //Network Related Errors
  NoInternetConnection,
  PoorConnection,

  //Image Related Errors
  CouldNotLoadImage

  //Product Related Errors

  //Seller Related Errors

}

//App Errors
Map<Errors, AppError> appErrors = {
  Errors.NoInternetConnection : AppError(errorCode: 101, errorMsg: "Oh, No!, There is no Internet Connection"),
  Errors.PoorConnection : AppError(errorCode: 102, errorMsg: "Poor Internet Connection"),
};