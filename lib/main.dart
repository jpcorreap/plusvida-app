import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid_19_app/utils/authutils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:covid_19_app/models/user.dart';
import 'package:covid_19_app/screens/auth/authenticate.dart';
import 'package:covid_19_app/screens/home/start.dart';

/// Main function of the app wich initializes the PlusVidaApp class.
void main() => runApp(PlusVidaApp());

/// Wrapper that shows either Authenticate widget for unloged users and Start widget for logged users.
///
/// Returns [Authenticate] or [Start] depending on user situation.
class WrapperAuthStart extends StatelessWidget {
  /// Return either Home or Authenticate widget based on user logged.
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user == null ? Authenticate() : Start();
  }
}

/// Represents parent class of the entire app.
class PlusVidaApp extends StatelessWidget {
  /// Returns a AuthService with a Material App inside wich contains in first place the WrapperAuthStart.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: '+Vida',
        theme: ThemeData(fontFamily: 'Lato'),
        home: WrapperAuthStart(),
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        // Some options will be supported in English and Spanish.
        supportedLocales: [const Locale('en'), const Locale('es')],
      ),
    );
  }
}
