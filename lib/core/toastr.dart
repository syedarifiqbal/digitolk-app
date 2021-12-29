import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toastr {
  String message;

  Toastr({required this.message});

  void show() {
    Fluttertoast.showToast(
      msg: this.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
