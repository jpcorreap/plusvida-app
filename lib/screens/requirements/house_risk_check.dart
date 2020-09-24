import 'package:covid_19_app/services/dbutils.dart';
import 'package:flutter/material.dart';

class HouseCheck extends StatefulWidget {
  final String userID;

  HouseCheck(this.userID);

  @override
  _HouseCheckState createState() => new _HouseCheckState(this.userID);
}

class _HouseCheckState extends State<HouseCheck> {
  String userID;

  _HouseCheckState(this.userID);

  DbUtils db = new DbUtils();

  int _sizeCasa = 0;
  int _cuidador = 0;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(
            'Riesgo de hogar',
            style: TextStyle(fontFamily: "Hind"),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff1E3E65),
        ),
        body: SingleChildScrollView(
            child: new Container(
          margin: EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 30.0),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            new Text(
              '¿Cuenta con alguna persona que lo cuide?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _cuidador,
                  onChanged: (value) => setState(() {
                    _cuidador = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _cuidador,
                  onChanged: (value) => setState(() {
                    _cuidador = value;
                  }),
                ),
                new Text(
                  'No',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            new Divider(height: 10.0, color: Color(0xff0066D0)),
            new Text(
              '¿Cuál es el tamaño de su hogar?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'Menor a 40 metros cuadrados',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _sizeCasa,
                  onChanged: (value) => setState(() {
                    _sizeCasa = value;
                  }),
                ),
                new Text(
                  'De 40 a 60 metros cuadrados',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                new Radio(
                  value: 1,
                  groupValue: _sizeCasa,
                  onChanged: (value) => setState(() {
                    _sizeCasa = value;
                  }),
                ),
                new Text(
                  'Mayor a 60 metros cuadrados',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                new Radio(
                  value: 2,
                  groupValue: _sizeCasa,
                  onChanged: (value) => setState(() {
                    _sizeCasa = value;
                  }),
                ),
              ],
            ),
            new Divider(height: 10.0, color: Color(0xff0066D0)),
            new Padding(
              padding: new EdgeInsets.all(8.0),
            ),
            new MaterialButton(
              height: 40.0,
              minWidth: 100.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Enviar"),
              splashColor: Colors.redAccent,
              onPressed: () => {},
            ),
            new Padding(
              padding: new EdgeInsets.all(8.0),
            ),
          ]),
        )));
  }
}
