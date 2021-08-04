import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData{
  String messageContent;
  String sender;
  Timestamp sentAt;

  MessageData({required this.messageContent,required this.sender, required this.sentAt});

  MessageData.fromJson(Map<String, dynamic> data):
      this(
        messageContent: data['messageContent'],
        sender : data['sender'],
        sentAt : data['sentAt'],
      );

  Map<String, dynamic > toJson(){
    Map<String, dynamic > data = Map<String, dynamic >();
    data['messageContent']  = this.messageContent;
    data['sender'] = this.sender;
    data['sentAt'] = this.sentAt;
    return data;
  }
}