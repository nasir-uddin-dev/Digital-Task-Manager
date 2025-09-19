import 'package:flutter/material.dart';
import 'package:task_management_app/ui/screen/splash_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            )
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              fixedSize: Size.fromWidth(double.maxFinite),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
