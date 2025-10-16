import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/ui/controllers/login_provider.dart';
import 'package:task_management_app/ui/screen/forget_password_verify_email_screen.dart';
import 'package:task_management_app/ui/screen/main_nav_bar_holder_screen.dart';
import 'package:task_management_app/ui/screen/signup_screen.dart';
import 'package:task_management_app/ui/widgets/background_screen.dart';
import 'package:task_management_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_management_app/ui/widgets/snack_bar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String name = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LoginProvider _loginProvider = LoginProvider(); //Creating instance LoginProvider

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _loginProvider,
      child: Scaffold(
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
                  'Get Started With',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Email',
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
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.remove_red_eye_rounded,
                      color: Colors.black,
                    ),
                    hintText: 'Password',
                  ),
                  validator: (String? value) {
                    if ((value?.length ?? 0) <= 6) {
                      return 'Password should more than 6 letters';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Consumer<LoginProvider>(builder: (context, loginProvider, _) {
                  return Visibility(
                    visible: loginProvider.loginInProgress == false,
                    replacement: CenteredProgressIndicator(),
                    child: FilledButton(
                        onPressed: () => _onTapLoginScreen(),
                        child: Icon(
                          Icons.arrow_circle_right_outlined,
                          size: 40,
                        )),
                  );
                }),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: TextButton(
                      onPressed: () => _onTapForgetPasswordScreen(),
                      child: Text(
                        'Forget Password ?',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?"),
                    TextButton(
                        onPressed: () => _onTapSignUpButton(),
                        child: Text('Sign Up'))
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void _onTapForgetPasswordScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgetPasswordVerifyEmailScreen()));
  }

  void _onTapLoginScreen() {
    if (_formkey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    final bool isSuccess = await _loginProvider.login(
        _emailController.text.trim(), _passwordController.text);

    if (isSuccess) {
      Navigator.pushNamedAndRemoveUntil(
          context, MainNavBarHolderScreen.name, (predicate) => false);
    } else {

      showSnackBarMessage(context, _loginProvider.errorMessage!);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// LoginScreen ক্লাসের কাজ
//
// LoginScreen একটি StatefulWidget।
//
// এখানে একটি Form আছে যেখানে Email এবং Password ইনপুট নেওয়া হচ্ছে।
//
// লগইন বাটন চাপলে API তে রিকোয়েস্ট যাবে।
//
// লগইন সফল হলে User Data + Token লোকাল স্টোরেজে সেভ হবে (AuthController এর মাধ্যমে)।
//
// তারপর MainNavBarHolderScreen এ নিয়ে যাবে।
//
// ভুল হলে Snackbar এ Error Message দেখাবে।
// 2. UI গঠন (build মেথড)
//
// BackgroundScreen → পুরো লগইন পেজের ব্যাকগ্রাউন্ড ডিজাইন।
//
// Form → Email + Password Input, বাটন ইত্যাদি রাখা হয়েছে।
//
// Email InputField → EmailValidator দিয়ে ইমেইল ভ্যালিডেশন করে।
//
// Password InputField → obscureText: true → পাসওয়ার্ড লুকানো যায়, ৬ অক্ষরের বেশি হতে হবে।
//
// Login Button → চাপ দিলে _onTapLoginScreen() কল হয়।
//
// Forget Password → অন্য স্ক্রিনে যায়।
//
// Sign Up → নতুন একাউন্ট তৈরির স্ক্রিনে নিয়ে যায়।
// 3. Helper Functions
// _onTapSignUpButton()
//
// 👉 SignUp Screen এ নিয়ে যায়।
//
// _onTapForgetPasswordScreen()
//
// 👉 Forget Password Verify Email Screen এ নিয়ে যায়।
//
// _onTapLoginScreen()
//
// 👉 ফর্ম ভ্যালিড কিনা চেক করে → যদি ঠিক থাকে _login() ফাংশন কল করে।

// 4. _login() ফাংশন
// লগইন শুরু হলে প্রগ্রেস ইন্ডিকেটর দেখানো হয়।
// ইউজারের দেওয়া ইমেইল + পাসওয়ার্ড রিকোয়েস্ট বডিতে রাখা হচ্ছে।
// API তে POST রিকোয়েস্ট যাচ্ছে।
//
// ApiResponse এ isSuccess, responseData, errorMessage থাকবে।
// ✅ যদি সফল হয়:
//
// API থেকে পাওয়া ডেটা → UserModel বানানো হয়।
//
// AuthController.saveUserData() দিয়ে লোকাল স্টোরেজে Token + User Data সেভ করা হয়।
//
// তারপর ইউজারকে MainNavBarHolderScreen এ নিয়ে যাওয়া হয়।
//
// ❌ যদি ব্যর্থ হয়:
//
// _logInProgress = false করা হয় (প্রগ্রেস ইন্ডিকেটর বন্ধ)।
//
// SnackBar দিয়ে Error Message দেখানো হয়।
// 🔑 সারসংক্ষেপ
//
// LoginScreen → লগইন UI + API কল।
//
// Email & Password Validation → ভুল ইনপুট আটকানো।
//
// _login() → API কল → Response চেক → Success হলে ডেটা সেভ + স্ক্রিন পরিবর্তন।
//
// AuthController.saveUserData() → লোকাল স্টোরেজে ইউজারের ডেটা ও টোকেন সেভ করে রাখে।
//
// Navigator.pushAndRemoveUntil → সফল হলে ব্যাক বাটন প্রেস করলে আর লগইন স্ক্রিনে ফেরা যাবে না।
