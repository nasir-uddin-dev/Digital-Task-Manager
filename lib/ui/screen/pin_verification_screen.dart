import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_management_app/ui/screen/reset_password_screen.dart';
import 'package:task_management_app/ui/widgets/background_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
 final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _pinVerificationController =
      TextEditingController();

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
                'PIN Verification',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'A 6 digit verification pin will send to your email address',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(
                height: 20,
              ),
              PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 40,
                  fieldWidth: 30,
                  activeFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                //enableActiveFill: true,
                controller: _pinVerificationController,
                appContext: context,
              ),
              SizedBox(
                height: 16,
              ),
              FilledButton(
                  onPressed: () => _onTapPinVerification(),
                  child: Text('Verify')),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Have account ?",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextButton(onPressed: () {}, child: Text('Sign In'))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void _onTapPinVerification() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
  }
  @override
  void dispose() {
    _pinVerificationController.dispose();
    super.dispose();
  }
}
