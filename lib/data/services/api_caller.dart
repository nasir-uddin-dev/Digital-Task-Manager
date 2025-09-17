import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class ApiCaller {
  static final Logger _logger = Logger(); //Create a new instance of Logger.

  static Future<ApiResponse> getRequest({required String url}) async {
    // The result will give future and will be Responsed server .
    // Function parameter is named which is required and This is async Function

    try {
      Uri uri = Uri.parse(
          url); //Uri.parse() মেথড String কে নিয়ে সেটাকে Uri অবজেক্ট বানায়।

      _logRequest(url);

      Response response = await get(
          uri); // HTTP GET request পাঠাচ্ছে এবং response take পর্যন্ত অপেক্ষা করছে

      _logResponse(url, response);

      final int statusCode =
          response.statusCode; // response থেকে HTTP status code নেওয়া

      if (statusCode == 200) {
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

  static Future<ApiResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    // The result will give future and will be Responsed server .
    // Function parameter is named which is required and This is async Function

    try {
      Uri uri = Uri.parse(
          url); //Uri.parse() মেথড String কে নিয়ে সেটাকে Uri অবজেক্ট বানায়।

      _logRequest(url, body: body);

      Response response = await post(
          uri); // HTTP GET request পাঠাচ্ছে এবং response take পর্যন্ত অপেক্ষা করছে

      _logResponse(url, response);

      final int statusCode =
          response.statusCode; // response থেকে HTTP status code নেওয়া

      if (statusCode == 200 || statusCode == 201) {
        // status 200 হলে সাধারণত সফল (success) 201 new data created
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

  static void _logRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i('URL => $url\n'
        'Request Body : $body');
  }

  static void _logResponse(String url, Response response) {
    _logger.i('URL => $url\n'
        'Status Code: ${response.statusCode}\n'
        'Body : ${response.body}');
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
      this.errorMessage = "Something went wrong"});
}
