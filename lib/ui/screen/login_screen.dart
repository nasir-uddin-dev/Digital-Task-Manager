import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/user_model.dart';
import 'package:task_management_app/data/services/api_caller.dart';
import 'package:task_management_app/data/utils/urls.dart';
import 'package:task_management_app/ui/controllers/auth_controller.dart';
import 'package:task_management_app/ui/screen/forget_password_verify_email_screen.dart';
import 'package:task_management_app/ui/screen/main_nav_bar_holder_screen.dart';
import 'package:task_management_app/ui/screen/signUp_screen.dart';
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

  bool _logInProgress = false;

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
              Visibility(
                visible: _logInProgress == false,
                replacement: CenteredProgressIndicator(),
                child: FilledButton(
                    onPressed: () => _onTapLoginScreen(),
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 40,
                    )),
              ),
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
    _logInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    };

    final ApiResponse response =
        await ApiCaller.postRequest(url: Urls.loginUrl, body: requestBody);

    if (response.isSuccess && response.responseData['status'] == 'success') {

      UserModel model = UserModel.fromJson(response.responseData['data']);
      String accessToken = response.responseData['token'];
       await AuthController.saveUserData(model, accessToken);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainNavBarHolderScreen()),
          (predicate) => false);
    } else {
      _logInProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
