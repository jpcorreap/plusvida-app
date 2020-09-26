import 'package:flutter/material.dart';
import 'package:covid_19_app/screens/auth/sign_in.dart';
import 'package:covid_19_app/screens/auth/register.dart';

/// Parent widget witch manages and allow switching between [Register] and [SignIn].
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  /// Represents if the user has been signed in or not.
  bool showSignIn = true;
  
  /// Allows change [showSignIn] value
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  /// Builds either [SignIn] widget or [Register] widget.
  @override
  Widget build(BuildContext context) {
    return showSignIn == true
        ? SignIn(toggleView: toggleView)
        : Register(toggleView: toggleView);
  }
}
