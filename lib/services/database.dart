import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kidzo/models/groupData.dart';
import 'package:kidzo/models/messageData.dart';
import 'package:kidzo/models/userData.dart';
import 'package:kidzo/utils/firebaseContent.dart';

class DatabaseService{
  static Future<UserData> getUserData(String phoneNumber) async {
    UserData userData = await userDataRef.doc(phoneNumber).get().then((value) => UserData.fromJson(value.data() as Map<String, dynamic>));
    // DebugPrinter.print("Fetching user : ${userData.name}");
    return userData;
  }

  static Future<bool> checkIfUserInGroup(String phoneNumber, String groupId) async {
  //  TODO : Implement 2 checks : Having only one now
    List<String> affiliatedGroupIds = await getAffiliatedGroupIds(phoneNumber);
    return affiliatedGroupIds.contains(groupId);
  }

  static Future<String> getUserName(String phoneNumber) async {
    return await getUserData(phoneNumber).then((value) => value.name);
  }
  static addNewGroup(GroupData groupData) async {
    await groupDataRef.doc(groupData.groupId).set(groupData.toJson());
  }

  // TODO : Instead of deleting -> deactivate
  static removeGroup(String groupId) async {
    List<String> allGroupMembers = await getAllGroupUserPhoneNumber(groupId);
    for(var phoneNumber in allGroupMembers){
      await removeUserFromGroup(phoneNumber, groupId);
    }
    await groupDataRef.doc(groupId).delete();
  }

  static addNewUser(UserData userData) async {
    await userDataRef.doc(userData.phoneNumber).set(userData.toJson());
  }

  static Future<bool> addUserToGroup(String phoneNumber, String groupId) async {
    if(await checkIfUserInGroup(phoneNumber, groupId)){
      return false;
    }
    else {
      await userDataRef.doc(phoneNumber).update(
          {'affiliatedGroupIds': FieldValue.arrayUnion([groupId])});
      await groupDataRef.doc(groupId).update(
          {'groupMembers': FieldValue.arrayUnion([phoneNumber])});
      return true;
    }
  }

  static Future<bool> removeUserFromGroup(String phoneNumber, String groupId) async {
    if(await checkIfUserInGroup(phoneNumber, groupId)){
      await userDataRef.doc(phoneNumber).update(
          {'affiliatedGroupIds': FieldValue.arrayRemove([groupId])});
      await groupDataRef.doc(groupId).update(
          {'groupMembers': FieldValue.arrayRemove([phoneNumber])});
      return true;
    }else{
      return false;
    }
  }

  static Future<GroupData> getGroupData(String groupId) async {
    GroupData groupData = await groupDataRef.doc(groupId).get().then((value) => GroupData.fromJson(value.data() as Map<String, dynamic>));
    // DebugPrinter.print("Fetching user : ${groupData.groupName}");
    return groupData;
  }

  static Future<List<String>> getAllGroupUserPhoneNumber(String groupId) async {
    List<String> allGroupUserPhoneNumber = await getGroupData(groupId).then((value) => (value.groupMembers));
    return allGroupUserPhoneNumber;
  }

  static Future<List<GroupData>> getAffiliatedGroupDataList(String phoneNumber) async {
    List<String> affiliatedGroupIds = await getAffiliatedGroupIds(phoneNumber);
    List<GroupData> affiliatedGroupDataList = <GroupData>[];
    for(var groupId in affiliatedGroupIds){
        var groupData = await getGroupData(groupId);
        affiliatedGroupDataList.add(groupData);
    }
    return affiliatedGroupDataList;
  }

  static Future<List<String>> getAffiliatedGroupIds(String phoneNumber) async {
    UserData userData = await getUserData(phoneNumber) ;
    return userData.affiliatedGroupIds;
  }

  static Future<List<GroupData>> getAllOwnedGroups(String phoneNumber) async {
    List<GroupData> allOwnedGroups = await groupDataRef.where('creator',isEqualTo : phoneNumber).get().then((value) => (value.docs.map((e) => GroupData.fromJson(e.data() as Map<String, dynamic>)).toList()));
    return allOwnedGroups;
  }


  static Future<List<String>> getAllOwnedGroupIds(String phoneNumber) async {
    List<String> allOwnedGroupIds = await groupDataRef.where('creator',isEqualTo : phoneNumber).get().then((value) => (value.docs.map((e) => e['groupId'].toString()).toList()));
    return allOwnedGroupIds;
  }

  static Future<List<String>> getAllUserPhoneNumber() async {
    // TODO : make it less expensive
    List<String> allUserPhoneNumber = await userDataRef.get().then((value) => (value.docs).map((e) => e.id).toList());
    return allUserPhoneNumber;
  }

  static Stream<QuerySnapshot> getAllMessages(String groupId) {
      return messageDataRef.doc(groupId).collection("messages").orderBy('sentAt',descending: true).snapshots();
  }

  static addMessage(String groupId, MessageData msgData) async {
    await messageDataRef.doc(groupId).collection("messages").add(msgData.toJson());
  }


}