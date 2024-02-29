import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowMessage{

  void showSnack(String str,context)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(str),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  static void showToast(str) {
    Fluttertoast.showToast(
        msg: "$str",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}