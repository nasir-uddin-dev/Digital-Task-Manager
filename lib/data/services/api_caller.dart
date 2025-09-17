import 'dart:convert';

import 'package:http/http.dart';

class ApiCaller {
  Future<ApiResponse> getRequest({required String url}) async {
    // The result will give future and will be Responsed server .
    // Function parameter is named which is required and This is async Function

    try {
      Uri uri = Uri.parse(
          url); //Uri.parse() মেথড String কে নিয়ে সেটাকে Uri অবজেক্ট বানায়।
      Response response = await get(
          uri); // HTTP GET request পাঠাচ্ছে এবং response take পর্যন্ত অপেক্ষা করছে

      //For showing debugging
      print(url);
      print(response.statusCode);
      print(response.body);
      final int statusCode =
          response.statusCode; // response থেকে HTTP status code নেওয়া

      if (response.statusCode == 200) {
        // status 200 হলে সাধারণত সফল (success)
        //Success
        final decodedData = jsonDecode(response
            .body); // response.body (JSON string) কে Dart object এ convert করা
        return ApiResponse(
            isSuccess: true,
            responseCode: statusCode,
            responseData: decodedData);
      } else {
        //Failed
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: false,
            responseCode: statusCode,
            responseData: decodedData,

        );
      }
    } on Exception catch (e) {
      return ApiResponse(
          isSuccess: false,
          responseCode: -1,
          responseData: null,
          errorMessage: e.toString());
    }
  }
}

//Make Refer Class
//The final keyword in Dart is used to declare a variable that can only be assigned
// once. Once a final variable has been initialized, its value cannot be changed or
// reassigned throughout the program's execution.
//ApiResponse মূলত একটি ডাটা মডেল ক্লাস, যেটা API কল করার পর response কে সহজে ধরে রাখার জন্য ব্যবহার করা হয়।
class ApiResponse {
  final bool isSuccess;
  final int responseCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse(
      {required this.isSuccess,
      required this.responseCode,
      required this.responseData,
      this.errorMessage = "Something went wrong"
      });
}
