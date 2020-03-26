// import 'package:dio/dio.dart';

// class AppException implements Exception {
//   final _message;
//   final _prefix;
  
// AppException([this._message, this._prefix]);
  
// String toString() {
//     return "$_prefix$_message";
//   }
// }

// class FetchDataException extends AppException {
//   FetchDataException([String message])
//       : super(message, "Error During Communication: ");
// }

// class BadRequestException extends AppException {
//   BadRequestException([message]) : super(message, "Invalid Request: ");
// }

// class UnauthorisedException extends AppException {
//   UnauthorisedException([message]) : super(message, "Unauthorised: ");
// }

// class InvalidInputException extends AppException {
//   InvalidInputException([String message]) : super(message, "Invalid Input: ");
// }

// class ApiBaseHelper {
  
// final String _baseUrl = "http://api.themoviedb.org/3/";
  
// Future<dynamic> get(String url) async {
//     var responseJson;
//     try {
//       final response = await http.get(_baseUrl + url);
//       responseJson = _returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
// }

// dynamic _returnResponse(http.Response response) {
//   switch (response.statusCode) {
//     case 200:
//       var responseJson = json.decode(response.body.toString());
//       print(responseJson);
//       return responseJson;
//     case 400:
//       throw BadRequestException(response.body.toString());
//     case 401:
//     case 403:
//       throw UnauthorisedException(response.body.toString());
//     case 500:
//     default:
//       throw FetchDataException(
//           'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
//   }
  
// }