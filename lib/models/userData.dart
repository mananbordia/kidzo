import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kidzo/services/database.dart';

class UserData{

  String phoneNumber;
  String name;
  int age;
  int kidzoCoins;
  List<String> affiliatedGroupIds;
  Timestamp createdAt;
  Timestamp lastUpdatedAt;
  String profileImgUrl;


  UserData( {required this.profileImgUrl, required this.createdAt, required this.kidzoCoins, required this.phoneNumber,required this.affiliatedGroupIds, required this.name, required this.age, required this.lastUpdatedAt});


  // Refer Github
  UserData.fromJson(Map<String, dynamic> data) :
    this(
      phoneNumber : data['phoneNumber'],
      name : data['name'],
      age : data['age'],
      kidzoCoins : data['kidzoCoins'],
      affiliatedGroupIds : data['affiliatedGroupIds'].length == 0 ? [] : data['affiliatedGroupIds'].map<String>((e) => e.toString()).toList(),
      createdAt : data['createdAt'],
      lastUpdatedAt : data['lastUpdatedAt'],
      profileImgUrl : data['profileImgUrl'],
    );

  // Refer Github
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['name'] = this.name;
    data['age'] = this.age;
    data['kidzoCoins'] = this.kidzoCoins;
    data['affiliatedGroupIds'] = this.affiliatedGroupIds;
    data['createdAt'] = this.createdAt;
    data['lastUpdatedAt'] = this.lastUpdatedAt;
    data['profileImgUrl'] = this.profileImgUrl;
    return data;
  }

  addUserToGroup(String groupId){
    affiliatedGroupIds.add(groupId);
    makeUpdates();

    // TODO : Change it to update user
    DatabaseService.addNewUser(this);
  }

  makeUpdates(){
    lastUpdatedAt = Timestamp.now();
  // TODO :  Do firestore database stuff
  }



  increaseSuperCoin({int amount : 1}){
    kidzoCoins += amount;
    makeUpdates();
  }
  decreaseSuperCoin({int amount : 1}){
    if(kidzoCoins - amount >= 0){
      kidzoCoins -= amount;
      makeUpdates();
    }
    else {
      print("Can't decrease supercoins as it can't take negative value");
    }
  }

}