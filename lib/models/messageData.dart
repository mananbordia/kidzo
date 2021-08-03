class MessageData{
  String messageContent;
  MessageData({required this.messageContent});

  MessageData.fromJson(Map<String, dynamic> data):
      this(
        messageContent: data['messageContent'],
      );

  Map<String, dynamic > toJson(){
    Map<String, dynamic > data = Map<String, dynamic >();
    data['messageContent']  = this.messageContent;
    return data;
  }
}