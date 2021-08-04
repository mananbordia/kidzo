import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidzo/screens/home.dart';
import 'package:kidzo/screens/update_profile.dart';
import 'package:kidzo/services/authentication.dart';

class AfterLoginPage extends StatefulWidget {
  @override
  _AfterLoginPageState createState() => _AfterLoginPageState();
}

class _AfterLoginPageState extends State<AfterLoginPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('userData').doc(AuthService.getCurrentUserPhoneNumber()).get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){

            return Scaffold(body : Center(child : CircularProgressIndicator()));
          }
          else if(snapshot.hasData && !snapshot.data!.exists){
            return UpdateProfilePage(refresh: _refresh);
          }
          else{
            return HomePage();
          }
    });
  }

  _refresh(){
    setState(() {});
  }
}
