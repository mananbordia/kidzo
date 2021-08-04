import 'package:flutter/material.dart';
import 'package:kidzo/components/groupTile.dart';
import 'package:kidzo/models/groupData.dart';
import 'package:kidzo/models/messageData.dart';
import 'package:kidzo/services/authentication.dart';
import 'package:kidzo/services/database.dart';
import 'package:kidzo/utils/cSnackbar.dart';
import 'package:kidzo/utils/debugPrint.dart';
import 'package:kidzo/utils/firebaseContent.dart';

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
      body: Column(children  : [Text("Hey Buddy how are you ? "),
        ElevatedButton(onPressed: _createNewGroup, child: Text("Create New Group"),),
        RefreshIndicator(
          onRefresh: (){
            return Future.delayed(Duration(seconds: 1),(){
            setState(() {});
            });
          },
          child: FutureBuilder(
              future: DatabaseService.getAllOwnedGroups(AuthService.getCurrentUserPhoneNumber()),
              builder: (_, AsyncSnapshot<List<GroupData>> groupList){
                if(groupList.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                else{
                  if(groupList.hasData){
                    List<GroupData> gList = groupList.data!;
                    return ListView.builder(itemCount : gList.length,
                      shrinkWrap: true,
                      itemBuilder : (_, index){
                      return GestureDetector(child : CTile(groupData : gList[index]),onLongPress: ()=>_removeGroup(gList[index].groupId) ,);
                    }, );
                  }
                  else{
                    return Text("No Data found.");
                  }
                }
              },
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: AuthService.signOut,
      ),
    );
  }



  void _createNewGroup() async {
    String currentUserPhoneNumber = AuthService.getCurrentUserPhoneNumber();
    var currentUserData = await DatabaseService.getUserData(currentUserPhoneNumber);
    var userOwnedGroupIds = await DatabaseService.getAllOwnedGroupIds(currentUserPhoneNumber);
    print(userOwnedGroupIds);
    // TODO : Change the limit
    if(userOwnedGroupIds.length < fMaxOwnedGroups){
      String groupId = fUuid.v4();
      String groupName = "Alpha Beta";
      GroupData nGroupData = GroupData(groupName: groupName, groupId: groupId, creator: currentUserPhoneNumber, groupMembers: [currentUserPhoneNumber], groupIconUrl: "", description: "This is our first group", messageList: <MessageData>[]);
      await DatabaseService.addNewGroup(nGroupData);
      await currentUserData.addUserToGroup(groupId);
      print(currentUserData.affiliatedGroupIds);
      setState(() {});
      (new CSnackbar()).showSnackbar(context, "New Group was created.");
    }else{
      String msg = "Can't make another group. Max limit reached.";
      print(msg);
      (new CSnackbar()).showSnackbar(context, msg, true);
    }

  }

  _removeGroup(String groupId) async {
    await DatabaseService.removeGroup(groupId);
    setState(() {});
  }
}
