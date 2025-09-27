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

  static Future<void> clearUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}


// 1. saveUserData(UserModel model, String token)
//
// 👉 কাজ: লগইন করার পর ইউজারের তথ্য এবং টোকেন লোকাল স্টোরেজে সেভ করা
//
// SharedPreferences.getInstance() → লোকাল স্টোরেজের ইনস্ট্যান্স নেয়।
//
// sharedPreferences.setString(_accessTokenKey, token) → টোকেনকে "token" নামে সেভ করে।
//
// sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson())) → ইউজারের ডেটা UserModel → Map → json করে "user" নামে সেভ করে।
//
// তারপর ক্লাসের মেমোরিতে (accessToken, userModel) সেট করা হয়।
//
// 📌 উদাহরণ: লগইন সফল হলে ইউজারের তথ্য + টোকেন এখানে সেভ হবে।
//
// 2. getUserData()
//
// 👉 কাজ: অ্যাপ চালু/রিস্টার্ট হওয়ার পর লোকাল স্টোরেজ থেকে আগের ইউজারের ডেটা আবার লোড করা।
//
// প্রথমে "token" কী দিয়ে টোকেন নেয়।
//
// যদি টোকেন পাওয়া যায়, তাহলে "user" কী দিয়ে আগের userData JSON আনা হয়।
//
// UserModel.fromJson(jsonDecode(userData!)) → JSON থেকে আবার UserModel বানানো হয়।
//
// এরপর userModel এবং accessToken মেমোরিতে সেট করা হয়।
//
// 📌 অর্থ: অ্যাপ চালু হলে ইউজার আগেই লগইন করা ছিল কিনা তা জানার জন্য দরকার।
//
// 3. isUserAlreadyLoggedIn()
//
// 👉 কাজ: ইউজার আগেই লগইন করা আছে কিনা চেক করা।
//
// লোকাল স্টোরেজ থেকে "token" নেয়া হয়।
//
// যদি টোকেন থাকে → true রিটার্ন করে।
//
// না থাকলে → false রিটার্ন করে।
//
// 📌 ব্যবহার:
//
// SplashScreen বা Main স্ক্রিনে এই ফাংশন কল করে দেখা যাবে সরাসরি হোম পেজে পাঠাতে হবে, নাকি লগইন স্ক্রিনে পাঠাতে হবে।
//
// 4. clearUserData()
//
// 👉 কাজ: লগআউট করার সময় লোকাল স্টোরেজ থেকে সব ডেটা মুছে ফেলা।
//
// sharedPreferences.clear() → পুরো লোকাল স্টোরেজ ক্লিয়ার করে দেয়।
//
// ফলে টোকেন বা ইউজারের কোনো ডেটা আর থাকবে না।
//
// 📌 ব্যবহার: লগআউট বোতামে চাপ দিলে এই ফাংশন কল করতে হবে।
//
// 🔑 সারসংক্ষেপ
//
// saveUserData() → লগইন সফল হলে টোকেন + ইউজারের ডেটা সেভ করে।
//
// getUserData() → অ্যাপ চালুর সময় আগের লগইন ডেটা লোড করে।
//
// isUserAlreadyLoggedIn() → আগের লগইন সেশন আছে কিনা চেক করে।
//
// clearUserData() → লগআউট করলে সব ডেটা মুছে ফেলে।