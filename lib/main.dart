import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kidzo/screens/afterLogin.dart';
import 'package:kidzo/screens/login.dart';
import 'package:kidzo/utils/firebaseContent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: fAuth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            return AfterLoginPage();
          }
          else{
            return LoginPage();
          }
        },),
    );
  }

}
