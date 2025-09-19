import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/data/services/api_caller.dart';
import 'package:task_management_app/data/utils/urls.dart';
import 'package:task_management_app/ui/widgets/background_screen.dart';
import 'package:task_management_app/ui/widgets/snack_bar_message.dart';

import '../widgets/centered_progress_indicator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _signUpInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                "Join With Us",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
                validator: (String? value) {
                  String inputText = value ?? ' ';
                  if (EmailValidator.validate(inputText) == false) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _firstNameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "First Name",
                ),
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter a first name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _lastNameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Last Name",
                ),
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter a last name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Mobile",
                ),
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter a mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                ),
                validator: (String? value) {
                  if ((value?.length ?? 0) <= 6) {
                    return 'Enter a password more than 6 letters';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              Visibility(
                visible: _signUpInProgress == false,
                replacement: CenteredProgressIndicator(),
                child: FilledButton(
                    onPressed: () => _onTapSubmitButton(),
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 40,
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Have account ?'),
                  TextButton(
                      onPressed: _onTapSignInButton, child: Text("Sign In"))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void _onTapSubmitButton() {
    if (_formkey.currentState!.validate()) {
      ///Register this user
      _signUp();
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  Future<void> _signUp() async {
    _signUpInProgress = true;
    setState(() {});

    ///Make Api Data
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
    "firstName": _firstNameController.text.trim(),
    "lastName": _lastNameController.text.trim(),
    "mobile": _mobileController.text.trim(),
    "password": _passwordController.text,
  };
    
    ///Network calling
   final ApiResponse response = await ApiCaller.postRequest(
       url: Urls.registrationUrl,
     body: requestBody
   );

   _signUpInProgress = false;
   setState(() {

   });
   if(response.isSuccess){
     _clearTextFields();
     showSnackBarMessage( context,"Registration success! Please Login");
   }else{
     showSnackBarMessage(context, response.errorMessage!);
   }
  }

  void _clearTextFields(){
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}


