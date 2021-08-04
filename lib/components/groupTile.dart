import 'package:flutter/material.dart';
import 'package:kidzo/models/groupData.dart';
import 'package:kidzo/services/database.dart';

import 'cGroup.dart';

class CTile extends StatelessWidget {
  final GroupData groupData;
  const CTile({Key? key, required this.groupData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(groupData.groupName), subtitle: _getSubTitle(), onTap: () => _openGroup(context),  );
  }

  _getSubTitle() {
    return FutureBuilder(future: DatabaseService.getUserName(groupData.creator), builder: (ctx, snapshot) {
      if(snapshot.connectionState==ConnectionState.waiting) {
          return CircularProgressIndicator();
      }else if(snapshot.hasData && snapshot.data != null){
          return Text(snapshot.data.toString() + "'s Group");
      }else{
        return Text("Something went wrong");
      }
    }, );
  }

  void _openGroup(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (ctx)=> GroupPage(groupData: groupData)));
  }
}
