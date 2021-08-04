import 'package:flutter/material.dart';
import 'package:kidzo/models/messageData.dart';


class ChatItem extends StatelessWidget {
  MessageData msgData;
  bool sentByCurrentUser;
  ChatItem({required this.msgData, required this.sentByCurrentUser});

  @override
  Widget build(BuildContext context) {
    if (sentByCurrentUser) {
      return Container(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  child: Text(msgData.messageContent),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  width: 200.0),
            ],
          ),
        ],
      ));
    } else {
      return Container(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Text(msgData.messageContent),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  width: 200.0),
            ],
          ),
        ],
      ));
    }
  }
}
