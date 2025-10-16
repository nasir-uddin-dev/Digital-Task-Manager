import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_management_app/ui/controllers/auth_controller.dart';
import 'package:task_management_app/ui/screen/login_screen.dart';
import 'package:task_management_app/ui/screen/update_profile_screen.dart';

class THAppBar extends StatefulWidget implements PreferredSizeWidget {
  const THAppBar({
    super.key,
    this.fromUpdateProfile,
  });

  final bool? fromUpdateProfile;

  @override
  State<THAppBar> createState() => _THAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _THAppBarState extends State<THAppBar> {
  @override
  Widget build(BuildContext context) {
    final profilePhoto = AuthController.userModel!.photo;
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (widget.fromUpdateProfile ?? false) {
            return;
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdateProfileScreen()));
        },
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(child: Icon(Icons.person)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.userModel!.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  AuthController.userModel!.email,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
            onPressed: _signOut,
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ))
      ],
    );
  }

  Future<void> _signOut() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.name, (predicate) => false);
  }
}
