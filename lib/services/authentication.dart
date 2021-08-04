import 'package:firebase_auth/firebase_auth.dart';
import 'package:kidzo/utils/firebaseContent.dart';

class AuthService{

  static void signOut() {
    print("User Logged Out Successfully.");
    fAuth.signOut();
  }

  static signInViaPhoneAuthCredentials(PhoneAuthCredential credential) async {
    try{
      await fAuth.signInWithCredential(credential);
      print("User Signed In successfully.");
    } on FirebaseAuthException catch(e){
      print("Something went wrong : $e");
    }
  }

  static String getCurrentUserPhoneNumber(){
    print("Fetching Current User's Phone Number");
    return fAuth.currentUser!.phoneNumber!;
  }


  static verifyViaOtp({required String phoneNumber, verificationCompletedFn, codeSentFn, codeAutoRetrievalTimeoutFn}) async {
    await fAuth.verifyPhoneNumber(
        timeout: Duration(seconds: 7),
        //Test : +911234567890  Otp : 123456
        phoneNumber: phoneNumber,
        // When verification is automatically done
        verificationCompleted: (credential) => verificationCompletedFn(credential) ,

        // When phone number is wrong or anything fails
        verificationFailed: (e) {
          print("Something went wrong : $e");
        },
        // When code is sent to user
        codeSent: (verificationId, forceResendToken) => codeSentFn(verificationId, forceResendToken) ,
        // After timeout
        codeAutoRetrievalTimeout: (verificationId) => codeAutoRetrievalTimeoutFn(verificationId));

  }

}