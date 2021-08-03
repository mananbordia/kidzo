import 'package:flutter/material.dart';

class CSnackbar{
  showSnackbar(BuildContext context, String msg, [bool isError = false]){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.blue));
  }
}