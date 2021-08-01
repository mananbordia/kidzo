import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : Text("Homepage")),
      body: Text("Hey Buddy how are you ? "),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: _signOut,
      ),
    );
  }

  _signOut() {
    print("User Logged Out Successfully.");
    FirebaseAuth.instance.signOut();
  }
}
