import 'package:flutter/material.dart';
import 'package:covid_19_app/screens/auth/sign_in.dart';
import 'package:covid_19_app/screens/auth/register.dart';

/// Screen wich manages and allow switching between register and sign in.
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
