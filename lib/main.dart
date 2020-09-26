import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid_19_app/utils/authutils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:covid_19_app/models/user.dart';
import 'package:covid_19_app/screens/auth/authenticate.dart';
import 'package:covid_19_app/screens/home/start.dart';

/// Main function of the app. It initializes 
void main() => runApp(PlusVidaApp());

class WrapperAuthStart extends StatelessWidget {
  @override
  /// return either Home or Authenticate widget based on user logged
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user == null ? Authenticate() : Start();
  }
}

/// Represents main class of the app
class PlusVidaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: '+Vida',
        theme: ThemeData(fontFamily: 'Lato'),
        home: WrapperAuthStart(),
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('es')],
      ),
    );
  }
}