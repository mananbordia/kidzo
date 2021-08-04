import 'package:flutter/material.dart';
import 'package:kidzo/models/messageData.dart';

class InputWidget extends StatefulWidget {
  var addMessage;
  InputWidget({required this.addMessage});

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  TextEditingController inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              alignment: Alignment.topLeft,
              // color: MyColors.primaryBGColor,
              child: IconButton(
                icon: Icon(Icons.face), onPressed: () {},
              ),
            ),
          ),
          Flexible(
            child: Container(
              color: Colors.white,
              child: TextField(
                controller: inputController,
                // style:
                //     TextStyle(color: Colors.white, fontSize: 15.0),
                decoration: InputDecoration.collapsed(hintText: 'Type Something'),
                minLines: 1,
                maxLines: 10,
              ),
            ),
          ),
          Material(
            child: Container(
              child: IconButton(
                icon: Icon(Icons.send),
                // color: MyColors.primaryColor,
                onPressed: _sendMessage,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    if(inputController.text.trim().isNotEmpty){
      String msgContent = inputController.text.trim();
      await widget.addMessage(msgContent);
      inputController.clear();
    }
  }
}
