import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class ApiCaller {
  static final Logger _logger =
      Logger(); // Only (singleton-like) logger instance which has been stored Class level
  // If variable starts underscores, it is named private . Anyone can not access this

  static Future<ApiResponse> getRequest({required String url}) async {
    // getRequest: It is required named parameter, async Function that returns Future<ApiResponse>
    try {
      // exception handle for doing try block
      Uri uri = Uri.parse(
          url); //String url converts to Uri object — http package get() expects Uri

      _logRequest(url); //logging: which url will request
      Response response =
          await get(uri); // HTTP GET request sending and waiting  till response
      _logResponse(url, response); // response is doing log (status code ও body)

      final int statusCode =
          response.statusCode; //HTTP status code takes from response

      if (statusCode == 200) {
        // whether statusCode is 200, generally it tells success. It means OK
        // SUCCESS
        final decodedData = jsonDecode(response
            .body); // response.body (JSON string) কে Dart object এ convert করা
        return ApiResponse(
          isSuccess: true, // success
          responseCode: statusCode, // 200
          responseData: decodedData, // Data Decode
        );
      } else {
        // any status code without 200, generally failed/error
        // FAILED
        final decodedData = jsonDecode(response
            .body); //If it mistakes, JSON can come from server, This is being decoded
        return ApiResponse(
          isSuccess: false, // Failed
          responseCode: statusCode, // examples : 400, 404, 500 etc.
          responseData: decodedData['data'], //error message/details that has been sent server
        );
      }
    } on Exception catch (e) {
      // Exception caught, here is catch (Network issue, jsonDecode error etc)
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        //Custom code - indicate happens exception(Nothing HTTP code)
        responseData: null,
        errorMessage: e.toString(), // exception message is given
      );
    }
  }

  static Future<ApiResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    // postRequest: for doing POST, named required `url`, optional `body` (Map)
    try {
      Uri uri = Uri.parse(url); // String URL -> Uri

      _logRequest(url, body: body); // request লগিং (এখানে body সহ)
      Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ); // **POST request is being sent —
      _logResponse(url, response); // response is logged

      final int statusCode = response.statusCode; // HTTP status code

      if (statusCode == 200 || statusCode == 201) {
        // 200 or 201 (created) are being succeed
        // SUCCESS
        final decodedData =
            jsonDecode(response.body); // response.body decode করা
        return ApiResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
        );
      } else {
        // FAILED
        final decodedData = jsonDecode(
            response.body); //In case failing, server is doing decoded JSON
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData['data'],
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  static void _logRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i('URL => $url\n'
        'Request Body : $body');
  } // _logger.i() Logger থেকে info-level log করে; এখানে URL ও body প্রদর্শন করা হচ্ছে

  static void _logResponse(String url, Response response) {
    _logger.i('URL => $url\n'
        'Status Code: ${response.statusCode}\n'
        'Body : ${response.body}');
  } // response থেকে status code ও পুরো body লগ করা হচ্ছে (ডিবাগে খুব সহায়ক)
}

//Make Refer Class
//The final keyword in Dart is used to declare a variable that can only be assigned
// once. Once a final variable has been initialized, its value cannot be changed or
// reassigned throughout the program's execution.
//ApiResponse মূলত একটি ডাটা মডেল ক্লাস, যেটা API কল করার পর response কে সহজে ধরে রাখার জন্য ব্যবহার করা হয়।
class ApiResponse {
  // API response represent করার জন্য একটি simple model ক্লাস
  final bool isSuccess; // সফল কি না
  final int responseCode; // HTTP code বা কাস্টম -1
  final dynamic
      responseData; // সার্ভার থেকে আসা ডেটা (Map, List, String ইত্যাদি) — তাই dynamic
  final String? errorMessage; // exception থাকলে error message (nullable)

  ApiResponse({
    required this.isSuccess,
    required this.responseCode,
    required this.responseData,
    this.errorMessage =
        'Something went wrong', // default value যদি caller কোনোটা না দেয়
  });
}
