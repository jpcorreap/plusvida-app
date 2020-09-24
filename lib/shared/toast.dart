import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Toast {
  static void show(String msg, BuildContext context) {
    int duration = 6;
    int gravity = 0;
    Color backgroundColor = const Color(0xAA000000);
    Color textColor = Colors.white;
    double backgroundRadius = 20;
    Border border;

    ToastView.dismiss();
    ToastView.createView(msg, context, duration, gravity, backgroundColor,
        textColor, backgroundRadius, border);
  }
}
