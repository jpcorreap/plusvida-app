import 'dart:convert';

import 'package:covid_19_app/services/dbutils.dart';
import 'package:covid_19_app/shared/autocomplete_input.dart';
import 'package:covid_19_app/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:covid_19_app/shared/loading.dart';

/// Manages user creation, as well user update of their information
/// userID Can be either null for representing a new profile, or a user data to update one.
class HouseForm extends StatefulWidget {
  final callback;
  HouseForm({@required this.callback});

  @override
  _HouseFormState createState() => new _HouseFormState(callback: this.callback);
}

class _HouseFormState extends State<HouseForm> {
  final callback;
  _HouseFormState({@required this.callback});

  // --------------------------------------------
  // Variables required to make this form works
  // --------------------------------------------

  // Reference to database
  DbUtils db = new DbUtils();

  bool registroUtilsFetched;

  // Lists of selectionable autofillable data
  var registroUtils;

  var departamento;
  var municipio;
  var direccion;

  int _cuidador = 0;
  int _sizeCasa = 0;

  TextEditingController _direccionController;

  void dispose() {
    _direccionController.dispose();
    super.dispose();
  }

  formIsValid(contexto) {
    if (_direccionController.text == "") {
      Scaffold.of(contexto).showSnackBar(new SnackBar(
          content: new Text(
        "Debe ingresar una dirección",
        style: TextStyle(fontSize: 18.0),
      )));
      return false;
    }

    return true;
  }

  publishChanges(contexto) {
    if (formIsValid(contexto)) {
      db.createHouse();
    }
  }

  createTextField(controller, keyboardType, decoration) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: keyboardType,
      style: TextStyle(color: Color(0xff1e3e65), fontWeight: FontWeight.normal),
      cursorColor: Color(0xff1e3e65),
      cursorWidth: 2.0,
      decoration: decoration != null ? decoration : null,
    );
  }

  // Sets initial state of this class
  void initState() {
    super.initState();
    registroUtilsFetched = false;
    registroUtils = null;

    municipio = null;
    departamento = null;

    _direccionController = TextEditingController();
  }

  fetchData() {
    db.getAllRegistro().get().then(
          (document) => setState(
            () {
              registroUtils = document.data;
              registroUtilsFetched = true;
            },
          ),
        );
  }

  Widget build(BuildContext context) {
    if (registroUtilsFetched == false) fetchData();

    return registroUtilsFetched == false
        ? Loading()
        : new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/background_home.png"),
                fit: BoxFit.cover,
              ),
              Scaffold(
                appBar: AppBar(
                  title: new Text('Nueva casa',
                      style: TextStyle(
                          color: Color(0xffdfedfe),
                          fontSize: 21,
                          fontFamily: "Hind")),
                  centerTitle: true,
                  backgroundColor: Color(0xff1E3E65),
                ),
                backgroundColor: Color(0xff),
                body: Builder(
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(25.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Departamento *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await showSearch(
                                context: this.context,
                                delegate: DataSearch(
                                  registroUtils["departamentos"],
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  departamento = json.decode(result);
                                  municipio = null;
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                departamento != null
                                    ? departamento["value"]
                                    : "Elegir...",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Municipio *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                final result = await showSearch(
                                  context: this.context,
                                  delegate: DataSearch(
                                    registroUtils["municipios"]
                                        [departamento["id"]],
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    municipio = json.decode(result);
                                  });
                                }
                              } catch (e) {
                                Toast.show("Seleccione primero un departamento",
                                    context);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                municipio != null
                                    ? municipio["value"]
                                    : "Elegir...",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          createTextField(
                            _direccionController,
                            TextInputType.text,
                            new InputDecoration(
                              labelText: "Dirección *",
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          new Text(
                            '¿Alguien en su casa puede cuidar a los demás en caso de necesitarlo?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1e3e65),
                                fontSize: 18),
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
                          SizedBox(
                            height: 20.0,
                          ),
                          new Text(
                            '¿Cuál es el tamaño de su casa?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1e3e65),
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          new Row(children: <Widget>[
                            new Radio(
                              value: 0,
                              groupValue: _sizeCasa,
                              onChanged: (value) => setState(() {
                                _sizeCasa = value;
                              }),
                            ),
                            new Text(
                              'Menor a 40 metros cuadrados',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                          ]),
                          new Row(children: <Widget>[
                            new Radio(
                              value: 1,
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
                          ]),
                          new Row(
                            children: <Widget>[
                              new Radio(
                                value: 2,
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
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          new MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Color(0xfff42f63),
                            textColor: Colors.white,
                            child: new Text("Crear casa"),
                            splashColor: Colors.redAccent,
                            onPressed: () => {
                              callback({
                                "direccion": _direccionController.text,
                                "departamento": departamento,
                                "municipio": municipio,
                              })
                            },
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(8.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
