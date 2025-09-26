import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

class AuthController {
  static const String _accessTokenKey = 'token';
  static const String _userModelKey = 'user';

  static String? accessToken;
  static UserModel? userModel;

//লগইন করার পর বা ইউজারের ডেটা নতুনভাবে আসলে এই ফাংশন কল করা হবে।
  static Future<void> saveUserData(UserModel model, String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(
        _userModelKey, jsonEncode(model.toJson()));
    accessToken = token;
    userModel = model;
  }

  //অ্যাপ চালু হলে / রিস্টার্ট হলে ইউজারের আগের ডেটা আবার মেমোরিতে লোড করার জন্য এই ফাংশন ব্যবহার হবে।
  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    if (token != null) {
      String? userData = sharedPreferences.getString(_userModelKey);
      userModel = UserModel.fromJson(jsonDecode(userData!));
      accessToken = token;
    }
  }

 static Future<bool> isUserAlreadyLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }
}
