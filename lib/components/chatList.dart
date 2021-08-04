import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidzo/models/messageData.dart';
import 'package:kidzo/services/authentication.dart';
import 'package:kidzo/services/database.dart';

import 'messageItem.dart';

class ChatList extends StatefulWidget {
  String groupId;
  ChatList({required this.groupId});
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController listScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
        stream: DatabaseService.getAllMessages(widget.groupId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child : CircularProgressIndicator());
          }else if(snapshot.hasData && snapshot.data != null){
            String currentUser = AuthService.getCurrentUserPhoneNumber();
            return ListView(
              reverse: true,
              children: snapshot.data!.docs.map((DocumentSnapshot doc){
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                MessageData msgData =  MessageData.fromJson(data);
                return Padding(padding: EdgeInsets.all(10), child: ChatItem(msgData: msgData, sentByCurrentUser: msgData.sender == currentUser,));
              }).toList(),
            );
          }else{
            return Text("Something Went Wrong");
          }
        }
    ));
  }
}
