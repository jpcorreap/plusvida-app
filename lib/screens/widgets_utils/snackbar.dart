import 'package:flutter/material.dart';

class Snackbar {
  static void show(String msg, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
      msg,
      style: TextStyle(fontSize: 18.0),
    )));
  }
}
