import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidzo/screens/home.dart';
import 'package:kidzo/screens/update_profile.dart';

class AfterLoginPage extends StatefulWidget {
  final String userPhoneNumber;
  AfterLoginPage({required this.userPhoneNumber});
  @override
  _AfterLoginPageState createState() => _AfterLoginPageState();
}

class _AfterLoginPageState extends State<AfterLoginPage> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('userData').doc(widget.userPhoneNumber).get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){

            return Scaffold(body : Center(child : CircularProgressIndicator()));
          }
          else if(snapshot.hasData && !snapshot.data!.exists){
            return UpdateProfilePage();
          }
          else{
            return HomePage();
          }
    });
  }
}
