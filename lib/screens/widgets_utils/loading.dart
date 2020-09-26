import 'package:flutter/material.dart';

/// Loading class
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffdfedfe),
      child: Center(
        child: Container(
          width: 150.0,
          child: Image.asset("assets/loading.gif"),
        ),
      ),
    );
  }
}
