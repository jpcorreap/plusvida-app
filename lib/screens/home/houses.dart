import 'package:covid_19_app/services/auth.dart';
import 'package:covid_19_app/services/dbutils.dart';
import 'package:flutter/material.dart';

final AuthService _auth = AuthService();
final DbUtils db = new DbUtils();
List roles = [];

class HomesDashboard extends StatelessWidget {
  static const String _title = 'Nuevo Home';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomesDashboardState(),
    );
  }
}

class HomesDashboardState extends StatefulWidget {
  HomesDashboardState();

  @override
  _HomesDashboardState createState() => _HomesDashboardState();
}

class _HomesDashboardState extends State<HomesDashboardState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffdfedfe),
        appBar: AppBar(
          title: Text('Hospital COVID-19',
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
                  style:
                      TextStyle(color: Color(0xffdfedfe), fontFamily: "Hind")),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: content()));
  }

  content() {
    return Column(
      children: [
        SizedBox(height: 150),
        Text(
            "¡No perteneces a una casa! Crea o inscríbete a una para continuar",
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center),
        SizedBox(height: 40),
        new MaterialButton(
            height: 40.0,
            minWidth: 100.0,
            color: Color(0xfff42f63),
            textColor: Colors.white,
            child: new Text(
              "Unirse a una casa",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            splashColor: Colors.redAccent,
            onPressed: () => {showJoin()}),
        SizedBox(height: 15),
        new MaterialButton(
          height: 40.0,
          minWidth: 100.0,
          color: Color(0xfff42f63),
          textColor: Colors.white,
          child: new Text(
            "Crear una casa",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          splashColor: Colors.redAccent,
          onPressed: () => {
            showHouseForm(),
          },
        ),
      ],
    );
  }

  showHouseForm() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 16,
          child: Container(
            height: 450.0,
            width: 300.0,
            margin: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Ingresa la siguiente información de tu casa:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff1e3e65),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Dirección",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 20,),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Municipio",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 20,),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Departamento",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                
                SizedBox(height: 60),
                new MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Crear", style: TextStyle(fontSize: 20.0)),
                  splashColor: Colors.redAccent,
                  onPressed: () => {Navigator.pop(context, "Cancel")},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showJoin() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 16,
          child: Container(
            height: 300.0,
            width: 300.0,
            margin: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Ingresa el código de la casa",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff1e3e65),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Código",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 60),
                new MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Buscar"),
                  splashColor: Colors.redAccent,
                  onPressed: () => {Navigator.pop(context, "Cancel")},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
