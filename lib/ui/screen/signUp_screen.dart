import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/data/services/api_caller.dart';
import 'package:task_management_app/data/utils/urls.dart';
import 'package:task_management_app/ui/widgets/background_screen.dart';
import 'package:task_management_app/ui/widgets/snack_bar_message.dart';

import '../widgets/centered_progress_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/signUp';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
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
                      if (value
                          ?.trim()
                          .isEmpty ?? true) {
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
                      if (value
                          ?.trim()
                          .isEmpty ?? true) {
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
                      if (value
                          ?.trim()
                          .isEmpty ?? true) {
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
    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, "Registration success! Please Login");
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  void _clearTextFields() {
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
//
// 1. ভ্যারিয়েবল ডিফাইন
// _formKey → ফর্মের ভ্যালিডেশন কন্ট্রোল করতে ব্যবহার হয়।
//
// প্রতিটি TextEditingController → ইনপুট ফিল্ড কন্ট্রোল করার জন্য।
//
// _signUpInProgress → রেজিস্ট্রেশন চলার সময় Progress Indicator দেখাতে ব্যবহৃত হয়।
//
// 2. UI গঠন (build মেথড)
//
// BackgroundScreen → ব্যাকগ্রাউন্ড ডিজাইন।
//
// Form → ইনপুট ফিল্ডগুলো ভ্যালিডেশন সহকারে রাখা হয়েছে।
//
// Email Field → EmailValidator দিয়ে ইমেইল ভ্যালিড চেক করা হয়।
//
// First Name & Last Name Field → খালি থাকলে error দেখাবে।
//
// Mobile Field → খালি থাকলে error দেখাবে।
//
// Password Field → ৬ অক্ষরের বেশি হতে হবে।
//
// Sign Up Button → চাপলে _onTapSubmitButton() কল হয়।
//
// Sign In Button → চাপলে Navigator.pop() দিয়ে আগের LoginScreen এ ফিরে যাবে।
//
// 3. Helper Functions
// _onTapSubmitButton()
//
// 👉 ফর্ম ভ্যালিড হলে _signUp() ফাংশন কল করে।
//
// _onTapSignInButton()
//
// 👉 লগইন স্ক্রিনে ফিরে যেতে Navigator.pop(context) ব্যবহার করছে।

// 4. _signUp() ফাংশন
// সাইনআপ শুরু হলে Progress Indicator দেখায়।
// ইউজারের দেওয়া ইনপুটগুলো JSON ম্যাপ হিসেবে প্রস্তুত করা হয়।
// ApiCaller.postRequest() এর মাধ্যমে রেজিস্ট্রেশন API তে POST রিকোয়েস্ট পাঠায়।
// রেসপন্স পাওয়ার পর Progress Indicator বন্ধ করে।
//
// ✅ যদি সফল হয়:
//
// সব ইনপুট ফিল্ড খালি করা হয়।
//
// Snackbar এ "Registration success! Please Login" দেখায়।
//
// ❌ যদি ব্যর্থ হয়:
//
// Snackbar এ error message দেখায়।
// 5. _clearTextFields()
//
// 👉 সব ইনপুট ফিল্ড ক্লিয়ার করে দেয়, যাতে নতুন করে ফিলাপ করা যায়।
//
// 6. dispose()
//
// 👉 সব TextEditingController মেমোরি থেকে রিমুভ করা হয় (Memory leak ঠেকাতে)।
//
// 🔑 সারসংক্ষেপ
//
// SignUpScreen → নতুন ইউজার রেজিস্ট্রেশন ফর্ম।
//
// ভ্যালিডেশন সহ Email, Name, Mobile, Password নেয়।
//
// _signUp() → API তে ডেটা পাঠায়।
//
// সফল হলে → ফিল্ড ক্লিয়ার + success মেসেজ।
//
// ব্যর্থ হলে → error message Snackbar এ দেখায়।
//
// Sign In Button → লগইন স্ক্রিনে ফিরে যাওয়ার জন্য।


