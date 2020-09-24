import 'package:covid_19_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:covid_19_app/models/user.dart';
import 'package:covid_19_app/screens/authenticate/authenticate.dart';
import 'package:covid_19_app/screens/home/homes.dart';

void main() => runApp(MyApp());

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    /*final AuthService _auth = AuthService();
    return FlatButton.icon(
      icon: Icon(
        Icons.person,
        color: Color(0xffdfedfe),
      ),
      label: Text('Cerrar sesión',
          style: TextStyle(color: Color(0xffdfedfe), fontFamily: "Hind")),
      onPressed: () async {
        await _auth.signOut();
      },
    );*/
    // return either Home or Authenticate widget
    if (user == null) {
      print("Wrapper.dart: no se detectó usuario logueado.");
      return Authenticate();
    } else {
      print("Wrapper.dart se tiene al usuario " + user.uid);
      return Homes();
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'COVID-19 App',
        theme: ThemeData(fontFamily: 'Lato'),
        home: Wrapper(),
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('es')],
      ),
    );
  }
}
