import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_management_app/ui/controllers/auth_controller.dart';
import 'package:task_management_app/ui/screen/login_screen.dart';
import 'package:task_management_app/ui/utility/asset_paths.dart';
import 'package:task_management_app/ui/widgets/background_screen.dart';

import 'main_nav_bar_holder_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    final bool isLoggedIn = await AuthController.isUserAlreadyLoggedIn();
    if (isLoggedIn) {
      await AuthController.getUserData();
      Navigator.pushReplacementNamed(context, MainNavBarHolderScreen.name);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundScreen(
            child: Center(
      child: SvgPicture.asset(
        AssetsPaths.logoSvg,
        height: 40,
      ),
    )));
  }
}


// ১. SplashScreen Widget
//
// এটি একটি StatefulWidget।
//
// অ্যাপ চালু হলে প্রথমে এই স্ক্রিন দেখানো হয়।
//
// সাধারণত লোগো, নাম বা লোডিং অ্যানিমেশন দেখানোর জন্য ব্যবহৃত হয়।
//
// ২. initState() → _moveToNextScreen() কল করা
//
// যখন স্ক্রিনটি প্রথমবার তৈরি হয়, তখন initState() কল হয়।
//
// এখানে _moveToNextScreen() নামের একটি Future ফাংশন চালু করা হয়েছে।
//
// ৩. _moveToNextScreen() ফাংশনের কাজ
//
// Future.delayed(Duration(seconds: 3))
//
// প্রথমে ৩ সেকেন্ড অপেক্ষা করবে (Splash Screen সাধারণত কিছু সময় দেখানো হয়)।
//
// AuthController.isUserAlreadyLoggedIn()
//
// লোকাল স্টোরেজ/শেয়ারড প্রেফারেন্স থেকে দেখে নেবে ইউজার আগে লগইন করা আছে কিনা।
//
// যদি ইউজার আগে থেকেই লগইন থাকে:
//
// AuthController.getUserData() কল করে ইউজারের ডেটা নিয়ে আসবে।
//
// তারপর MainNavBarHolderScreen এ পাঠাবে (অর্থাৎ মেইন অ্যাপ ড্যাশবোর্ড/হোম স্ক্রিনে যাবে)।
//
// যদি ইউজার লগইন করা না থাকে:
//
// সরাসরি LoginScreen এ নিয়ে যাবে।
//
// ৪. UI অংশ (build method)
//
// Scaffold ব্যবহার করা হয়েছে পুরো স্ক্রিনের জন্য।
//
// BackgroundScreen → একটা কাস্টম ব্যাকগ্রাউন্ড (সম্ভবত গ্রেডিয়েন্ট বা ইমেজ দেওয়া)।
//
// Center এ → অ্যাপের লোগো (SVG ফরম্যাটে) দেখানো হচ্ছে SvgPicture.asset() দিয়ে।
//
// AssetsPaths.logoSvg হলো সেই লোগো ফাইলের পাথ।