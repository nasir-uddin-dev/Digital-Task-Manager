import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Center(
          child: Text(
        message,
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ))));
}
