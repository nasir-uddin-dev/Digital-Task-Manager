import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/data/services/api_caller.dart';
import 'package:task_management_app/data/utils/urls.dart';
import 'package:task_management_app/ui/screen/pin_verification_screen.dart';
import 'package:task_management_app/ui/widgets/background_screen.dart';
import 'package:task_management_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_management_app/ui/widgets/snack_bar_message.dart';

class ForgetPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgetPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgetPasswordVerifyEmailScreen> createState() =>
      _ForgetPasswordVerifyEmailScreenState();
}

class _ForgetPasswordVerifyEmailScreenState
    extends State<ForgetPasswordVerifyEmailScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _onTapEmailInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                "Your Email Address",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "A 6 digit verification pin will send to your email address",
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                validator: (String? value) {
                  String inputText = value ?? " ";
                  if (EmailValidator.validate(inputText) == false) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              Visibility(
                visible: _onTapEmailInProgress == false,
                replacement: CenteredProgressIndicator(),
                child: FilledButton(
                    onPressed: () => _onTapEmailAddressScreen(),
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 40,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Have account ? ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void _onTapEmailAddressScreen() {
    if (_formkey.currentState!.validate()) {
      _email();
    }
  }

  ///Calling API for the get request
  Future<void> _email() async {
    _onTapEmailInProgress = true;
    setState(() {});

    // ইমেইল ইনপুট
    final String email = _emailController.text.trim();

    // API Request পাঠানো
    final ApiResponse response = await ApiCaller.getRequest(
      url: "${Urls.emailUrl}?email=$email",
    );

    if (response.isSuccess && response.responseData['status'] == 'success') {
      // Success হলে PIN Verification Screen এ যাবে
      _onTapPinVerificationScreen();
      showSnackBarMessage(context, "Verification PIN sent to your email");
    } else {
      // Error message show
      showSnackBarMessage(context, response.errorMessage ?? "Something went wrong!");
    }

    // Progress বন্ধ করা
    _onTapEmailInProgress = false;
    setState(() {});
  }


  void _onTapPinVerificationScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PinVerificationScreen()));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
