import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:kidzo/models/groupData.dart';
import 'package:kidzo/services/authentication.dart';
import 'package:kidzo/services/database.dart';
import 'package:kidzo/utils/cSnackbar.dart';

import 'groupChat.dart';

class GroupPage extends StatefulWidget {
  final GroupData groupData;
  const GroupPage({Key? key, required this.groupData}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  GroupData? _groupData;
  bool showRefresh = true;
  String curUser = AuthService.getCurrentUserPhoneNumber();
  Uri? shareLink;

  @override
  initState() {
    // TODO: implement initState
    _fetchGroupData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showRefresh ? null : AppBar(title: Text(_groupData!.groupName)),
      body: showRefresh ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          Text(_groupData!.description),
          _getListOfMembers(),
          _getListOfMembersNotInGroup(),
          ElevatedButton(
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => GroupChat(groupId: _groupData!.groupId))),
            child: Text("Open Chat"),
          ),
          if(curUser == _groupData!.creator)
            ElevatedButton(
              onPressed: _createDynamicLink,
              child: Text("Create Link"),
            ),

        ],
      ),
    );
  }

  _getListOfMembers() {
    return ListView.builder(itemBuilder: (ctx, index) {
      return ListTile(
        title: Text(_groupData!.groupMembers[index],),
        subtitle: _groupData!.creator == _groupData!.groupMembers[index] ? Text(
            "Creator") : null,
        onLongPress: _groupData!.creator == _groupData!.groupMembers[index]
            ? null
            : () => _removeMemberFromGroup(_groupData!.groupMembers[index]),
      );
    }, itemCount: _groupData!.groupMembers.length,
      shrinkWrap: true,
    );
  }


  _getListOfMembersNotInGroup() {
    return FutureBuilder(builder: (ctx, AsyncSnapshot<List<String>> snapshots) {
      if (snapshots.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshots.hasData) {
        List<String> allUserPhoneNumbers = snapshots.data!;
        allUserPhoneNumbers.removeWhere((element) =>
            _groupData!.groupMembers.contains(element));
        return allUserPhoneNumbers.length == 0 ? Text("") :
        Column(
          children: [
            Text("Contacts you might know"),
            ListView.builder(itemCount: allUserPhoneNumbers.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return ListTile(title: Text(allUserPhoneNumbers[index]),
                  onLongPress: () =>
                      _addMemberToGroup(allUserPhoneNumbers[index]),);
              },),
          ],
        );
      }
      else {
        return Text("Something went wrong");
      }
    },
      future: DatabaseService.getAllUserPhoneNumber(),);
  }

  _addMemberToGroup(String phoneNumber) async {
    if (curUser == _groupData!.creator)
      try {
        bool result = await DatabaseService.addUserToGroup(
            phoneNumber, _groupData!.groupId);
        if (result) {
          _groupData = null;
          await _fetchGroupData();
          (new CSnackbar()).showSnackbar(context, "Contact Added to Group");
        }
        else
          (new CSnackbar()).showSnackbar(
              context, "Contact Already Present in Group");
      } catch (e) {
        (new CSnackbar()).showSnackbar(context, "Something Went Wrong");
      }
    else {
      (new CSnackbar()).showSnackbar(context, "You can't add members", true);
    }
  }

  _removeMemberFromGroup(String phoneNumber) async {
    if (curUser == phoneNumber || curUser == _groupData!.creator)
      try {
        bool result = await DatabaseService.removeUserFromGroup(
            phoneNumber, _groupData!.groupId);
        if (result) {
          _groupData = null;
          await _fetchGroupData();
          if (curUser == phoneNumber) {
            Navigator.pop(context);
          }
          (new CSnackbar()).showSnackbar(context, "Contact Removed from Group");
        }
        else
          (new CSnackbar()).showSnackbar(
              context, "Contact not Present in Group");
      } catch (e) {
        (new CSnackbar()).showSnackbar(context, "Something Went Wrong");
      }
    else {
      (new CSnackbar()).showSnackbar(context, "You can't remove members", true);
    }
  }

  _fetchGroupData() async {
    setState(() {
      showRefresh = true;
    });
    _groupData = await DatabaseService.getGroupData(widget.groupData.groupId);
    setState(() {
      showRefresh = false;
    });
  }

  _createDynamicLink() async {
    if (shareLink == null) {
      DynamicLinkParameters param = DynamicLinkParameters(
          uriPrefix: "https://kidzo.page.link",
          link: Uri.https(
              "kidzoapp.com", "/testapi", {'groupId': _groupData!.groupId}),
          androidParameters: AndroidParameters(
            packageName: 'com.kidzo.kidzo',
          )
      );
      ShortDynamicLink dynamicUri = await param.buildShortLink();
      shareLink = dynamicUri.shortUrl;
    }
    print(shareLink);
  }
}
