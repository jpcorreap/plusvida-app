import 'package:covid_19_app/utils/dbutils.dart';
import 'package:covid_19_app/screens/widgets_utils/toast.dart';
import 'package:flutter/material.dart';

class DailyCheck extends StatefulWidget {
  final String userID;

  DailyCheck(this.userID);

  @override
  _DailyCheckState createState() => new _DailyCheckState(this.userID);
}

class _DailyCheckState extends State<DailyCheck> {
  String userID;

  _DailyCheckState(this.userID);

  DbUtils db = new DbUtils();

  int _contactoEstrechoCOVID = 0;
  int _fiebreMas38 = 0;
  int _tosSeca = 0;
  int _dolorCabeza = 0;
  int _dificultadRespirar = 0;
  int _recaido = 0;
  int _vomitoDiarrea = 0;
  int _pruebaCOVID = 0;

  final myController = TextEditingController();

  void sendResults() {
    print('Informe del día ${getDate()}:');

    List results = [
      getDate(),
      _contactoEstrechoCOVID == 1,
      _fiebreMas38 == 1,
      _tosSeca == 1,
      _dolorCabeza == 1,
      _dificultadRespirar == 1,
      _recaido == 1,
      _vomitoDiarrea == 1,
      _pruebaCOVID == 1,
      myController.text
    ];

    db.createDailyCheck(results, userID).then((value) => {
          if ((_contactoEstrechoCOVID +
                  _fiebreMas38 +
                  _tosSeca +
                  _dolorCabeza +
                  _dificultadRespirar +
                  _recaido +
                  _vomitoDiarrea +
                  _pruebaCOVID) >=
              3)
            {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    elevation: 16,
                    child: Container(
                      height: 300.0,
                      width: 360.0,
                      margin: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              "¡Alerta! Tiene un riesgo considerable. ¿Desea notificar al personal de salud?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff1e3e65),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          new MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Color(0xfff42f63),
                            textColor: Colors.white,
                            child: new Text("Notificar"),
                            splashColor: Colors.redAccent,
                            onPressed: () => {
                              Navigator.pop(context, "Cancel")
                            },
                          ),
                          new MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Color(0xfff42f63),
                            textColor: Colors.white,
                            child: new Text("No hacer nada"),
                            splashColor: Colors.redAccent,
                            onPressed: () => Navigator.pop(context, "Cancel"),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              )
            }
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  String getDate() {
    var finalDate = "";
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";

    setState(() {
      finalDate = formattedDate.toString();
    });

    return finalDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(
            'Chequeo diario ${getDate()}',
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
            new Text("A día de hoy, usted:",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e3e65),
                    fontSize: 16)),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            new Text(
              '¿Ha tenido contacto estrecho con alguien que haya sido diagnosticado o presentado síntomas de COVID-19 en los últimos dos días?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _contactoEstrechoCOVID,
                  onChanged: (value) => setState(() {
                    _contactoEstrechoCOVID = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _contactoEstrechoCOVID,
                  onChanged: (value) => setState(() {
                    _contactoEstrechoCOVID = value;
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
              '¿Ha tenido fiebre superior a 38 °C?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _fiebreMas38,
                  onChanged: (value) => setState(() {
                    _fiebreMas38 = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _fiebreMas38,
                  onChanged: (value) => setState(() {
                    _fiebreMas38 = value;
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
              '¿Ha presentado tos seca de forma contínua?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _tosSeca,
                  onChanged: (value) => setState(() {
                    _tosSeca = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _tosSeca,
                  onChanged: (value) => setState(() {
                    _tosSeca = value;
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
              '¿Ha presentado dolor de cabeza contínuo?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _dolorCabeza,
                  onChanged: (value) => setState(() {
                    _dolorCabeza = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _dolorCabeza,
                  onChanged: (value) => setState(() {
                    _dolorCabeza = value;
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
              '¿Ha presentado dificultad para respirar o sensación de ahogamiento?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _dificultadRespirar,
                  onChanged: (value) => setState(() {
                    _dificultadRespirar = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _dificultadRespirar,
                  onChanged: (value) => setState(() {
                    _dificultadRespirar = value;
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
              '¿Se ha sentido recaído?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _recaido,
                  onChanged: (value) => setState(() {
                    _recaido = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _recaido,
                  onChanged: (value) => setState(() {
                    _recaido = value;
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
              '¿Ha presentado vómito o diarrea de forma constante?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _vomitoDiarrea,
                  onChanged: (value) => setState(() {
                    _vomitoDiarrea = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _vomitoDiarrea,
                  onChanged: (value) => setState(() {
                    _vomitoDiarrea = value;
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
              '¿Realizó la prueba de COVID-19?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _pruebaCOVID,
                  onChanged: (value) => setState(() {
                    _pruebaCOVID = value;
                  }),
                ),
                new Text(
                  'Sí',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 0,
                  groupValue: _pruebaCOVID,
                  onChanged: (value) => setState(() {
                    _pruebaCOVID = value;
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
            /*new Text(
              '¿Presenta alguna(s) de las siguientes enfermedades o condiciones?: Obesidad, hipertensión, cáncer, diabetes, cardiopatías, enfermedad renal o hepática, enfermedad inmunodepresiva.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xff1e3e65),
                  fontSize: 16),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 20),
              child: TextField(
                decoration: InputDecoration(hintText: 'Enfermedad(es)'),
                controller: myController,
              ),
            ),*/
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
              onPressed: ()=>Toast.show("Pendiente de modificación", context)/*sendResults*/,
            ),
            new Padding(
              padding: new EdgeInsets.all(8.0),
            ),
          ]),
        )));
  }
}
