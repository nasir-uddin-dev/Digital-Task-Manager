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
