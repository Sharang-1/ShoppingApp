// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:core';
// import 'package:get/get_connect/http/src/response/response.dart';
// import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';

// class ApiProvider {
//   http.Client apiClient = http.Client();

//   // final ErrorHandlingService _errorHandlingService =
//   //     locator<ErrorHandlingService>();

//   apiService(path, {data, headers, method}) async {
//     headers = {'Content-Type': 'application/json'};
//     var res;
//     if (data == null) {
//       print("i am get and called");
//       res = await apiClient.get(Uri.parse(path));
//     } else if (method == null || method.toLowerCase() == "post") {
//       print(
//           "REQUEST : POST \n REQUEST_URL: $path \n REQUEST_BODY : ${data.toString()} \n REQUEST_HEADER : ${headers.toString()}  ");
//       res = await apiClient.post(
//         Uri.parse(path),
//         body: data,
//         headers: {'Content-Type': 'application/json'},
//       );
//     } else if (method.toLowerCase() == "put") {
//       print(
//           "REQUEST : POST \n REQUEST_URL: $path \n REQUEST_BODY : ${data.toString()} \n REQUEST_HEADER : ${headers.toString()}  ");

//       res = await apiClient.put(Uri.parse(path),
//           body: data, headers: {'Content-Type': 'application/json'});
//     }
//     var newRes = jsonDecode(res.body);

//     print("RESPONSE OF: \n $path converted to json is :\n $newRes");

//     return newRes;
//   }

//   Future signup({name, email, phoneNo}) {
//     print("api provider signup called");

//     return apiService(ApiContants.signup,
//         data: jsonEncode({
//           "username": name,
//           //  "last_name": "singh",
//           "email": email,
//           // "password": "pass",
//           "mobile_number": phoneNo
//         }));
//   }

//   Future signupUpdate({
//     grade,
//     classId,
//   }) async {
//     print("api provider signup called");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? userId = await prefs.getInt(UserId);
//     return apiService(ApiContants.signupUpdate + userId.toString(),
//         data: jsonEncode({"academicboard": grade, "classesId": classId}),
//         method: "put");
//   }

//   Future sendotp(phoneNo) {
//     print("api provider login called");

//     return apiService(ApiContants.sendotp,
//         data: jsonEncode({"mobile_number": phoneNo}));
//   }

//   Future verifyOtp({userId, otp}) {
//     print("api provider login called");

//     return apiService(ApiContants.verifyOtp,
//         data: jsonEncode({"userId": userId, "otp": otp}));
//   }

//   Future fetchAcademicBoard() {
//     print("api provider fetch all academic board called");

//     return apiService(ApiContants.getAcademicBoard);
//   }

//   Future fetchAllClasses() {
//     print("api provider all classes called");

//     return apiService(
//       ApiContants.getAllclasses,
//     );
//   }

//   Future fetchChapterDetails(int subjectId) {
//     print("api provider fetchSubjectDetails called");

//     return apiService(
//       ApiContants.getAllClassChapters + "/" + subjectId.toString(),
//     );
//   }

//   Future fetchSubjectDetails(String subjectId) {
//     print("api provider fetchSubjectDetails called");

//     return apiService(
//       ApiContants.getSubjectChapters + subjectId,
//     );
//   }

//   // Future fetchSubjectCategories(String id) {
//   //   print("api provider  fetchSubjectCategories called");

//   //   return apiService(
//   //     ApiContants.getSubjectCategories + id,
//   //   );
//   // }

//   Future fetchFilteredSubjectCategories({String? boardId, String? classId}) {
//     print("api provider  fetchFilteredSubjectCategories called");

//     return apiService(
//       ApiContants.getFilteredSubjectCategories + boardId! + "/" + classId!,
//     );
//   }
// }
