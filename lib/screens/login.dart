import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum LoginPageState{
  SHOW_ENTER_PHONE_NUMBER_STATE,
  SHOW_ENTER_OTP_STATE,
  SHOW_VERIFICATION_IN_PROGRESS_STATE
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
  late String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: _getPage()
    );
  }

  _getPage(){
    if(pageState == LoginPageState.SHOW_ENTER_OTP_STATE){
      return _getEnterOtpForm();
    }
    else if(pageState == LoginPageState.SHOW_ENTER_PHONE_NUMBER_STATE){
      return _getEnterPhoneNumberForm();
    }
    else if(pageState == LoginPageState.SHOW_VERIFICATION_IN_PROGRESS_STATE){
      return _getVerificationInProgressScreen();
    }
  }

  _getEnterPhoneNumberForm() {
    return Column(
      children: [
        Row(
            children: [
              Container(child: Text("+91-"),width: 30,),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
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
        ),]),
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
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6)
          ],
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
        ElevatedButton(onPressed: _loginInUsingSmsCode, child: Text("Verify")),
        TextButton(onPressed: (){
          setState(() {
            pageState = LoginPageState.SHOW_ENTER_PHONE_NUMBER_STATE;
          });
        }, child: Text("Change Number"))
      ],
    );
  }

  _getVerificationInProgressScreen(){
    return Column(
      children: [
        CircularProgressIndicator(),
        Text("Please be patient we are verifying your phone number."),
      ],
    );
  }

  // For verifying phone number
  _verifyPhoneNumber() async {

    String userPhoneNumber = "+91"+_phoneController.text.trim();
    print(userPhoneNumber);
    // TODO : Add some checks here

    await _auth.verifyPhoneNumber(
        timeout: Duration(seconds: 10),
        //+911234567890
        phoneNumber: userPhoneNumber,
        // When verification is automatically done
        verificationCompleted: (credential) async {
          print("Verified Successfully : $credential");
          try {
            await _signInViaPhoneAuthCredentials(credential);
          }catch(e){
            print("Something went wrong : $e");
            setState(() {
              pageState = LoginPageState.SHOW_ENTER_PHONE_NUMBER_STATE;
            });
          }
        },
        // When phone number is wrong or anything fails
        verificationFailed: (e) async {
          print("Something went wrong : $e");
        },
        // When code is sent to user
        codeSent: (verificationId, forceResendToken) async {
          // Show OTP Page
          setState(() {
            pageState = LoginPageState.SHOW_VERIFICATION_IN_PROGRESS_STATE;
          });
          print("Code Sent : $verificationId , $forceResendToken");
        },
        // After timeout
        codeAutoRetrievalTimeout: (verificationId) async {
          print("Auto Code Retrieval Timeout");
          setState(() {
            _verificationId = verificationId;
            pageState = LoginPageState.SHOW_ENTER_OTP_STATE;
          });
        });
  }

  Future<void> _loginInUsingSmsCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: _otpController.text.trim());
    // TODO : Add some checks here

    await _signInViaPhoneAuthCredentials(credential);
  }

  _signInViaPhoneAuthCredentials(PhoneAuthCredential credential) async {
    try{
      await _auth.signInWithCredential(credential);
      print("User Signed In successfully.");
    } on FirebaseAuthException catch(e){
      print("Something went wrong : $e");
    }
  }
}
