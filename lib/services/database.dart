import 'package:kidzo/models/groupData.dart';
import 'package:kidzo/models/userData.dart';
import 'package:kidzo/utils/firebaseContent.dart';

class DatabaseService{
  static Future<UserData> getUserData(String phoneNumber) async {
    UserData userData = await userDataRef.doc(phoneNumber).get().then((value) => UserData.fromJson(value.data() as Map<String, dynamic>));
    // DebugPrinter.print("Fetching user : ${userData.name}");
    return userData;
  }

  static addNewGroup(GroupData groupData) async {
    await groupDataRef.doc(groupData.groupId).set(groupData.toJson());
  }

  static addNewUser(UserData userData) async {
    await userDataRef.doc(userData.phoneNumber).set(userData.toJson());
  }

  static Future<GroupData> getGroupData(String groupId) async {
    GroupData groupData = await groupDataRef.doc(groupId).get().then((value) => GroupData.fromJson(value.data() as Map<String, dynamic>));
    // DebugPrinter.print("Fetching user : ${groupData.groupName}");
    return groupData;
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

}