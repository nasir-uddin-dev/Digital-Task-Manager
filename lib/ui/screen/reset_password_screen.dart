import 'package:flutter/material.dart';
import 'package:task_management_app/data/services/api_caller.dart';
import 'package:task_management_app/data/utils/urls.dart';
import 'package:task_management_app/ui/screen/login_screen.dart';
import 'package:task_management_app/ui/widgets/background_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _resetPasswordInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                "Set Password",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Minimum length password 8 characters with letter and number combination',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Password",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _confirmController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FilledButton(
                  onPressed: () => _onTapSingInButton(),
                  child: Text("Confirm")),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Have account ?",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextButton(onPressed: () {}, child: Text("Sign In"))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }


  void _onTapSingInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (predicate) => false);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
}
