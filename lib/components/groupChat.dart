import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidzo/models/messageData.dart';
import 'package:kidzo/services/authentication.dart';
import 'package:kidzo/services/database.dart';

import 'chatList.dart';
import 'inputBar.dart';

class GroupChat extends StatefulWidget {
  final String groupId;
  const GroupChat({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat"),),
      body: Column(
        children: <Widget>[
          ChatList(groupId: widget.groupId),
          InputWidget(addMessage: _addMessage),
        ],
      )
    );
  }

  _addMessage(String msgContent) async {
    await DatabaseService.addMessage(widget.groupId, MessageData(messageContent: msgContent, sender: AuthService.getCurrentUserPhoneNumber(), sentAt: Timestamp.now()));
    print("Message Sent");
  }
}
