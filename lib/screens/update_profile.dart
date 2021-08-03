import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kidzo/models/userData.dart';
import 'package:kidzo/screens/home.dart';
import 'package:kidzo/services/authentication.dart';
import 'package:kidzo/services/database.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : Text("Update Profile")),
      body: Column(
        children: [
          TextField(
            controller: _firstNameController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[A-Za-z]"))
              ],
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "First Name")
          ),
          TextField(
            controller: _lastNameController,
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[A-Za-z]"))
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
                  hintText: "Last Name")
          ),
          TextField(
            controller: _ageController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2)
              ],
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
                  hintText: "Age")
          ),
          ElevatedButton(onPressed: _updateUserProfile, child: Text("Save")),
        ],
      ),
    );
  }

  Future<void> _updateUserProfile() async {

    //TODO : Add checks and resolve test part
    String testPhoneNumber = AuthService.getCurrentUserPhoneNumber();
    UserData userData =
    UserData(
        createdAt: Timestamp.now(),
        lastUpdatedAt: Timestamp.now(),
        phoneNumber: testPhoneNumber, age: int.parse(_ageController.text),
        affiliatedGroupIds: <String>[],
        kidzoCoins: 1,
        name: _firstNameController.text + " " + _lastNameController.text,
      profileImgUrl: '',
    );

    // TODO : Handle error case
    await DatabaseService.addNewUser(userData).then((value){
      print("User added");
      return Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=> HomePage()));
    });
  }
}
