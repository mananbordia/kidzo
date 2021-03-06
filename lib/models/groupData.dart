import 'package:kidzo/models/messageData.dart';

class GroupData{
  String groupName;
  String groupId;
  // Phone numbers of group members
  List<String> groupMembers;
  String creator;
  String groupIconUrl;
  String description;

  GroupData({required this.groupName, required this.groupId, required this.creator, required this.groupMembers, required this.groupIconUrl, required this.description});

  GroupData.fromJson(Map<String, dynamic> data):
      this(
        groupName : data['groupName'],
        groupId : data['groupId'],
        creator : data['creator'],
        groupMembers : data['groupMembers'].length == 0 ? [] : data['groupMembers'].map<String>((e) => e.toString()).toList(),
        groupIconUrl : data['groupIconUrl'],
        description : data['description'],
      );

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupName'] = this.groupName;
    data['groupId'] = this.groupId;
    data['creator'] = this.creator;
    data['groupMembers']  = this.groupMembers;
    data['groupIconUrl'] = this.groupIconUrl;
    data['description'] = this.description;
    return data;
  }

}