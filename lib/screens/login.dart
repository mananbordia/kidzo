import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum LoginPageState{
  SHOW_ENTER_PHONE_NUMBER_STATE,
  SHOW_ENTER_OTP_STATE
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginPageState pageState = LoginPageState.SHOW_ENTER_PHONE_NUMBER_STATE;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: pageState == LoginPageState.SHOW_ENTER_PHONE_NUMBER_STATE ? _getEnterPhoneNumberForm() : _getEnterOtpForm());
  }

  _getEnterPhoneNumberForm() {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey)),
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Phone Number"),
          controller: _phoneController,
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(onPressed: _verifyPhoneNumber, child: Text("Get OTP"))
      ],
    );
  }

  _getEnterOtpForm() {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey)),
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "OTP"),
          controller: _otpController,
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(onPressed: _verifyPhoneNumber, child: Text("Verify"))
      ],
    );
  }

  // For verifying phone number
  _verifyPhoneNumber() async {
    String userPhoneNumber = _phoneController.text.trim();
    print(userPhoneNumber);
    await _auth.verifyPhoneNumber(
        //+911234567890
        phoneNumber: userPhoneNumber,
        // When verification is automatically done
        verificationCompleted: (credential) async {
          print("Verified Successfully : $credential");
        },
        // When phone number is wrong or anything fails
        verificationFailed: (e) async {
          print("Something went wrong : $e");
        },
        // When code is sent to user
        codeSent: (verificationId, forceResendToken) async {
          // Show OTP Page
          print("Code Sent : $verificationId , $forceResendToken");
          setState(() {
            pageState = LoginPageState.SHOW_ENTER_OTP_STATE;
          });
        },
        // After timeout
        codeAutoRetrievalTimeout: (verificationId) async {
          print("Auto Code Retrieval Timeout");
        });
    //  Add some checks here
  }
}
