import 'package:covid_19_app/screens/home/intro_tutorial.dart';
import 'package:covid_19_app/screens/profiles/create_or_edit_profile.dart';
import 'package:covid_19_app/utils/authutils.dart';
import 'package:covid_19_app/utils/dbutils.dart';
import 'package:covid_19_app/screens/widgets_utils/loading.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

Card buildProfile(userID, username, routeToHome) {
  return Card(
      child: Column(
    children: <Widget>[
      Text(
        username,
        style: TextStyle(fontSize: 25.0),
      ),
      FlatButton(
        child: const Text('Elegir'),
        onPressed: routeToHome,
      ),
    ],
  ));
}

class _StartState extends State<Start> {
  List userIds;
  List usernames;
  int currentState;

  DbUtils db = new DbUtils();

  void initState() {
    super.initState();
    currentState = 0; // At beginning it sets loading state
    fetchStartData();
  }

  final AuthService _auth = AuthService();

  fetchStartData() {
    //Navigator.pop(context, "Cancel");
    db.getProfileInfo().then((data) {
      print("Actualización de estado en Start.dart");
      
      setState(() {
        if (data != null) {
          userIds = data["usersIDs"];
          print(data["usersIDs"]);
          usernames = data["usernames"];

          setState(() {
            if (userIds.length == 0)
              currentState = 1; // 1 means it has fetched data
            else
              currentState = 2; // 2 means there is accounts associated
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentState == 0)
      return Loading();
    else if (currentState == 1) return IntroTutorial(callback: fetchStartData);

    return new Scaffold(
      backgroundColor: Color(0xffdfedfe),
      appBar: AppBar(
        title: Text('Mis cuentas',
            style: TextStyle(
                color: Color(0xffdfedfe), fontSize: 21, fontFamily: "Hind")),
        backgroundColor: Color(0xff1e3e65),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.person,
              color: Color(0xffdfedfe),
            ),
            label: Text('Cerrar sesión',
                style: TextStyle(color: Color(0xffdfedfe), fontFamily: "Hind")),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  "Elija una cuenta",
                  style: TextStyle(
                    fontFamily: "Hind",
                    fontSize: 35.0,
                    color: Color(0xff1e3e65),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            userIds.length != 0
                ? Expanded(
                    child: ListView.builder(
                        itemCount: userIds.length,
                        itemBuilder: (context, index) {
                          return buildProfile(
                              userIds[index],
                              usernames[index],
                              () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Home(userIds[index])),
                                    )
                                  });
                        }))
                : {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IntroTutorial()),
                    )
                  },

            /*new MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text(
                    "Actualizar",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  splashColor: Colors.redAccent,
                  onPressed: fetchStartData,
                ),
              ],
            ),*/
            new MaterialButton(
              height: 40.0,
              minWidth: 100.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text(
                "Agregar una cuenta",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              splashColor: Colors.redAccent,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileForm(
                    userData: null,
                    callback: fetchStartData,
                    willBeCabezaDeHogar: false,
                  ),
                ),
              ),
            ),
            new SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
