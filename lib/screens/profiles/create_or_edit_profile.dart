import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:covid_19_app/utils/dbutils.dart';
import 'package:covid_19_app/screens/widgets_utils/autocomplete_input.dart';
import 'package:covid_19_app/screens/widgets_utils/snackbar.dart';
import 'package:covid_19_app/screens/widgets_utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:covid_19_app/screens/widgets_utils/loading.dart';

/// Manages user creation, as well user update of their information
/// userData Can be either null for representing a new profile, or a user data to update one.
class ProfileForm extends StatefulWidget {
  final userData;
  final callback;
  final willBeCabezaDeHogar;
  ProfileForm(
      {@required this.userData,
      @required this.callback,
      @required this.willBeCabezaDeHogar});

  @override
  _ProfileFormState createState() => new _ProfileFormState(
      userData: this.userData,
      callback: this.callback,
      willBeCabezaDeHogar: this.willBeCabezaDeHogar);
}

class _ProfileFormState extends State<ProfileForm> {
  final userData;
  final callback;
  final willBeCabezaDeHogar;
  _ProfileFormState(
      {@required this.userData,
      @required this.callback,
      @required this.willBeCabezaDeHogar});

  // --------------------------------------------
  // Variables required to make this form works
  // --------------------------------------------
  DateTime selectedDate = DateTime.now();

  // Reference to database
  DbUtils db = new DbUtils();

  // Booleans to handle multiple fetches
  bool epsUtilsFetched;
  bool registroUtilsFetched;

  // Lists of selectionable autofillable data
  var epsUtils;
  var registroUtils;

  // Current date (for date picker)
  final currentDate = DateTime.parse(new DateTime.now().toString());
  bool dateSelected;

  // List to know wich Comorbilidades are selected
  List<bool> comorbilidadesBool = List.generate(6, (_) => false);

  // Objects with selectionable data by the user
  var tipoEPS;
  var departEPS;
  var eps;
  var comorbilidades;
  var discapacidad;
  var nacionalidad;
  var tipoDoc;
  var genero;
  var numTelefono;
  var etnia;

  // Controllers for user inputs
  TextEditingController _primNombreController;
  TextEditingController _segNombreController;
  TextEditingController _primApellidoController;
  TextEditingController _segApellidoController;
  TextEditingController _numDocController;
  TextEditingController _numTelefonoController;

  // ----------------------------
  // Auxiliar functions required
  // ----------------------------
  void dispose() {
    _primNombreController.dispose();
    _segNombreController.dispose();
    _primApellidoController.dispose();
    _segApellidoController.dispose();
    _numTelefonoController.dispose();
    _numDocController.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(currentDate.year, 12));
    if (picked != null && picked != selectedDate)
      setState(
        () {
          selectedDate = picked;
          dateSelected = true;
        },
      );
  }

  getSelectedComorbilidades() {
    var list = [];
    for (var i = 0; i < comorbilidadesBool.length; i++) {
      if (comorbilidadesBool[i]) {
        list.add(registroUtils["comorbilidades"][i]);
      }
    }
    return list;
  }

  formIsValid(contexto) {
    if (userData != null) {
      callback();
      return true;
    }

    if (_primNombreController.text == "") {
      Snackbar.show("Debe ingresar un nombre", contexto);
      return false;
    }

    if (_primApellidoController.text == "") {
      Snackbar.show("Debe ingresar un apellido", contexto);
      return false;
    }

    if (genero == null) {
      Snackbar.show("Debe seleccionar un género", contexto);
      return false;
    }

    if (userData == null && (tipoDoc == null || _numDocController.text == "")) {
      Snackbar.show("Debe diligenciar un documento váldo", contexto);
      return false;
    }

    if (nacionalidad == null) {
      Snackbar.show("Debe ingresar una nacionalidad", contexto);
      return false;
    }

    if (dateSelected == false) {
      Snackbar.show("Debe elegir una fecha de nacimiento", contexto);
      return false;
    }

    if (eps == null) {
      Snackbar.show("Debe seleccionar una eps", contexto);
      return false;
    }

    if (etnia == null) {
      Snackbar.show("Debe seleccionar una etnia", contexto);
      return false;
    }

    if (discapacidad == null) {
      Snackbar.show("Debe seleccionar una discapacidad", contexto);
      return false;
    }

    print(willBeCabezaDeHogar);
    if (willBeCabezaDeHogar == true) {
      if (tipoDoc["id"] == "TI" ||
          tipoDoc["id"] == "PA" ||
          tipoDoc["id"] == "CN" ||
          tipoDoc["id"] == "RC") {
        Snackbar.show(
            "Como será cabeza de hogar, no puede usar ese tipo de documento de indentidad",
            contexto);
        return false;
      }

      if (_numTelefonoController.text == "") {
        Snackbar.show(
            "Como será cabeza de hogar, debe ingresar un teléfono", contexto);
        return false;
      }

      print(calculateAge(selectedDate));
      if (calculateAge(selectedDate) < 18) {
        Snackbar.show(
            "Como será cabeza de hogar, debe ser mayor de edad", contexto);
        return false;
      }

      return true;
    }
  }

  publishChanges(contexto) {
    if (formIsValid(contexto)) {
      // If it is a new user it means must be created since scratch
      if (userData == null) {
        print("Validando si existe un usuario con el documento '" +
            tipoDoc["id"].toString() +
            _numDocController.text +
            "'...");
        db.getUser(tipoDoc["id"] + _numDocController.text).get().then(
          (doc) {
            print("Se trajo " + doc.data.toString());
            if (doc.data != null) {
              Scaffold.of(contexto).showSnackBar(new SnackBar(
                  content: new Text(
                "Documento de identidad ya en uso",
                style: TextStyle(fontSize: 18.0),
              )));
              return false;
            } else {
              var user = {
                'primNombre': _primNombreController.text,
                'segNombre': _segNombreController.text,
                'primApellido': _primApellidoController.text,
                'segApellido': _segApellidoController.text,
                'genero': genero["value"],
                'nacionalidad': nacionalidad["value"],
                'nacimiento': selectedDate,
                'eps': eps["id"],
                'etnia': etnia["id"],
                'discapacidad': discapacidad["id"],
                'numTelefono': [numTelefono[0], _numTelefonoController.text],
                'comorbilidades': getSelectedComorbilidades(),
                'protocolo': 'NA',
                'roles': ['paciente'],
                'enfermera': 'NA',
                'riesgo': -1,
              };

              if (userData == null) {
                print("\n>> " + user.toString());
                String username =
                    "${user['primNombre']} ${user['segNombre']} ${user['primApellido']} ${user['segApellido']}"
                        .replaceAll('  ', ' ');
                print(
                    "En Profile_form andamos melos y se va a ir a mandar al usuario $username");

                db.createUser(
                    tipoDoc["id"] +
                        _numDocController.text
                            .replaceAll(" ", "")
                            .toUpperCase(),
                    user,
                    username);

                callback();
              } else {
                /*db.updateUser(
                  tipoDoc["id"] + _numDocController.text, user
                );*/
                print("DEBERÍA ACTUALIZAAAR");
              }
            }
          },
        );
      }
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    numTelefono[0] = countryCode.toString().substring(1);
  }

  // This code was taken from https://medium.com/@viveky259259/age-calculator-in-flutter-97853dc8486f
  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  generateCheckbox(index) {
    return Checkbox(
      value: comorbilidadesBool[index],
      onChanged: (bool value) {
        setState(
          () {
            comorbilidadesBool[index] = value;
          },
        );
      },
    );
  }

  createTextField(controller, keyboardType, decoration) {
    return TextField(
      controller: controller,
      autofocus: controller == _primNombreController,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: keyboardType,
      style: TextStyle(color: Color(0xff1e3e65), fontWeight: FontWeight.normal),
      cursorColor: Color(0xff1e3e65),
      cursorWidth: 2.0,
      decoration: decoration != null ? decoration : null,
    );
  }

  // This functions indicates if all three documents are been fetched
  bool isDataFetched() {
    if (epsUtilsFetched == true && registroUtilsFetched == true) {
      return true;
    }
    return false;
  }

  // Sets initial state of this class
  void initState() {
    super.initState();

    // Init of all text controllers
    _primNombreController = TextEditingController();
    _segNombreController = TextEditingController();
    _primApellidoController = TextEditingController();
    _segApellidoController = TextEditingController();
    _numTelefonoController = TextEditingController();
    _numDocController = TextEditingController();

    // At begining, nothing has been fetched
    epsUtilsFetched = false;
    registroUtilsFetched = false;

    // If there is an existing user
    if (userData != null) {
      print("\n USUARIO PREVIO EXISTENTE: " + userData.toString());
      _primNombreController.text = userData["primNombre"];
      _segNombreController.text = userData["segNombre"];
      _primApellidoController.text = userData["primApellido"];
      _segApellidoController.text = userData["segApellido"];

      numTelefono = userData["numTelefono"];
      _numTelefonoController.text = userData["numTelefono"][1];

      comorbilidades = userData["comorbilidades"];

      dateSelected = true;
      selectedDate = userData['nacimiento'].toDate();
      nacionalidad = {"id": "", "value": userData["nacionalidad"]};

      eps = {"id": userData["eps"], "value": "PENDIENTE ACTUALIZAR"};
      tipoEPS = null;
      departEPS = null;
      genero = {"id": "", "value": userData["genero"]};
    } else {
      print("ES UN NUEVO USUARIOOO AAH");
      genero = null;
      dateSelected = false;
      eps = null;
      numTelefono = ["57", ""];
      nacionalidad = null;
      comorbilidades = null;
      discapacidad = null;
      nacionalidad = null;
      tipoDoc = null;
    }
  }

  void fetchData() {
    if (epsUtilsFetched == false) {
      db.getEPSs().get().then((document) => setState(() {
            epsUtils = document.data;
            epsUtilsFetched = true;
          }));
    }
    if (registroUtilsFetched == false) {
      db.getAllRegistro().get().then((document) => setState(() {
            registroUtils = document.data;
            registroUtilsFetched = true;

            for (var i = 0; i < registroUtils["comorbilidades"].length; i++) {
              if (userData["comorbilidades"]
                  .contains(registroUtils["comorbilidades"][i])) {
                comorbilidadesBool[i] = true;
              }
            }
          }));
    }
  }

  // Build this widget, showing either Loading or form
  Widget build(BuildContext context) {
    if (isDataFetched() == false) fetchData();

    return isDataFetched() == false
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
                  title: new Text(
                      userData == null
                          ? 'Nueva cuenta'
                          : 'Edición de ${userData["id"]}',
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
                          createTextField(
                            _primNombreController,
                            TextInputType.text,
                            new InputDecoration(
                              labelText: "Primer nombre *",
                            ),
                          ),
                          createTextField(
                            _segNombreController,
                            TextInputType.text,
                            new InputDecoration(
                              labelText: "Segundo nombre",
                            ),
                          ),
                          createTextField(
                              _primApellidoController,
                              TextInputType.text,
                              new InputDecoration(
                                labelText: "Primer apellido *",
                              )),
                          createTextField(
                            _segApellidoController,
                            TextInputType.text,
                            new InputDecoration(
                              labelText: "Segundo apellido",
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Género *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await showSearch(
                                context: this.context,
                                delegate: DataSearch(registroUtils["generos"]),
                              );

                              if (result != null) {
                                setState(
                                  () {
                                    genero = json.decode(result);
                                  },
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                genero != null
                                    ? "${genero["value"]}"
                                    : "Elegir...",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          if (userData ==
                              null) // If there is an existing user, he wont be able to change their doc info
                            SizedBox(
                              height: 20.0,
                            ),
                          if (userData ==
                              null) // If there is an existing user, he wont be able to change their doc info
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tipo de documento *",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 15.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          if (userData ==
                              null) // If there is an existing user, he wont be able to change their doc info
                            GestureDetector(
                              onTap: () async {
                                final result = await showSearch(
                                  context: this.context,
                                  delegate:
                                      DataSearch(registroUtils["documentos"]),
                                );

                                if (result != null) {
                                  setState(
                                    () {
                                      tipoDoc = json.decode(result);
                                      _numDocController.text = "";
                                    },
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  tipoDoc != null
                                      ? tipoDoc["value"]
                                      : "Elegir...",
                                  style: TextStyle(fontSize: 18.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          if (userData ==
                              null) // If there is an existing user, he wont be able to change their doc info
                            createTextField(
                              _numDocController,
                              // Based on doctype, numDoc will be either text or numeric
                              tipoDoc != null &&
                                      (tipoDoc["id"] == 'CD' ||
                                          tipoDoc["id"] == 'PA')
                                  ? TextInputType.text
                                  : TextInputType.number,
                              new InputDecoration(
                                labelText: "Número de documento *",
                              ),
                            ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "País de origen *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await showSearch(
                                context: this.context,
                                delegate:
                                    DataSearch(registroUtils["nacionalidades"]),
                              );
                              if (result != null) {
                                setState(
                                  () {
                                    nacionalidad = json.decode(result);
                                  },
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                nacionalidad != null
                                    ? nacionalidad["value"]
                                    : "Elegir...",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Fecha de nacimiento *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                dateSelected
                                    ? "${selectedDate.toLocal()}".split(' ')[0]
                                    : "Elegir...",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "EPS *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tipo de EPS *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await showSearch(
                                  context: this.context,
                                  delegate: DataSearch([
                                    {"id": "G", "value": "Gubernamental"},
                                    {"id": "O", "value": "Otra"},
                                  ]));
                              if (result != null) {
                                setState(() {
                                  tipoEPS = json.decode(result);
                                  departEPS = null;
                                  eps = null;
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(16, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                tipoEPS != null
                                    ? tipoEPS["value"]
                                    : "Elegir...",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          if (tipoEPS != null && tipoEPS["id"] == "G")
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Departamento EPS *",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 15.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          if (tipoEPS != null && tipoEPS["id"] == "G")
                            GestureDetector(
                              onTap: () async {
                                final result = await showSearch(
                                    context: this.context,
                                    delegate: DataSearch(
                                        registroUtils["departamentos"]));
                                if (result != null) {
                                  setState(() {
                                    departEPS = json.decode(result);
                                    eps = null;
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(16, 2, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  departEPS != null
                                      ? departEPS["value"]
                                      : "Elegir...",
                                  style: TextStyle(fontSize: 18.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          if (tipoEPS != null)
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Nombre EPS *",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 15.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          if (tipoEPS != null)
                            GestureDetector(
                              onTap: () async {
                                final result = await showSearch(
                                    context: this.context,
                                    delegate: DataSearch(departEPS != null
                                        ? epsUtils["gubernamentales"]
                                            [departEPS["id"]]
                                        : epsUtils["otras"]));
                                if (result != null) {
                                  setState(() {
                                    eps = json.decode(result);
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(16, 2, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  eps != null ? eps["value"] : "Elegir...",
                                  style: TextStyle(fontSize: 18.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Etnia *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await showSearch(
                                context: this.context,
                                delegate: DataSearch(registroUtils["etnias"]),
                              );
                              if (result != null) {
                                setState(() {
                                  etnia = json.decode(result);
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                etnia != null ? etnia["value"] : "Elegir...",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Discapacidad *",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await showSearch(
                                context: this.context,
                                delegate:
                                    DataSearch(registroUtils["discapacidades"]),
                              );
                              if (result != null) {
                                setState(() {
                                  discapacidad = json.decode(result);
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                discapacidad != null
                                    ? discapacidad["value"]
                                    : "Elegir...",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Número de teléfono " + (true ? "*" : ""),
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                child: CountryCodePicker(
                                  onChanged: _onCountryChange,
                                  initialSelection: 'CO',
                                  favorite: ['+57', 'CO'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                ),
                              ),
                              Container(
                                child: TextField(
                                  controller: _numTelefonoController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                ),
                                width: 200.0,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Comorbilidades",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: comorbilidadesBool[0],
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      comorbilidadesBool[0] = value;
                                    },
                                  );
                                },
                              ),
                              Text(registroUtils["comorbilidades"][0]),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: comorbilidadesBool[1],
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      comorbilidadesBool[1] = value;
                                    },
                                  );
                                },
                              ),
                              Text(registroUtils["comorbilidades"][1]),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: comorbilidadesBool[2],
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      comorbilidadesBool[2] = value;
                                    },
                                  );
                                },
                              ),
                              Text(registroUtils["comorbilidades"][2]),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: comorbilidadesBool[3],
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      comorbilidadesBool[3] = value;
                                    },
                                  );
                                },
                              ),
                              Text(registroUtils["comorbilidades"][3]),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: comorbilidadesBool[4],
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      comorbilidadesBool[4] = value;
                                    },
                                  );
                                },
                              ),
                              Text(registroUtils["comorbilidades"][4]),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: comorbilidadesBool[5],
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      comorbilidadesBool[5] = value;
                                    },
                                  );
                                },
                              ),
                              Text(registroUtils["comorbilidades"][5]),
                            ],
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new MaterialButton(
                                    height: 40.0,
                                    minWidth: 100.0,
                                    color: Color(0xfff42f63),
                                    textColor: Colors.white,
                                    child: new Text(userData == null
                                        ? "Crear"
                                        : "Actualizar"),
                                    splashColor: Colors.redAccent,
                                    onPressed: () => publishChanges(context)),
                                SizedBox(
                                  width: 30.0,
                                ),
                                new MaterialButton(
                                  height: 40.0,
                                  minWidth: 100.0,
                                  color: Color(0xfff42f63),
                                  textColor: Colors.white,
                                  child: new Text("Cancelar"),
                                  splashColor: Colors.redAccent,
                                  onPressed: () =>
                                      Navigator.pop(context, "Cancel"),
                                ),
                              ]),
                          if (userData != null)
                            GestureDetector(
                              child: FlatButton.icon(
                                icon: SizedBox(),
                                label: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '¿Desea ser colaborador? ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Lato")),
                                      TextSpan(
                                          text: 'Solicítelo aquí',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      TextSpan(
                                          text: '.',
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  Toast.show("Aún no implementado.", context);
                                },
                              ),
                            ),
                          SizedBox(
                            width: 20.0,
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
