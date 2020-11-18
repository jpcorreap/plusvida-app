import 'package:covid_19_app/screens/widgets_utils/loading.dart';
import 'package:covid_19_app/utils/dbutils.dart';
import 'package:covid_19_app/screens/widgets_utils/toast.dart';
import 'package:flutter/material.dart';

class DailyCheck extends StatefulWidget {
  final String userID;
  final callback;

  DailyCheck({@required this.userID, @required this.callback});

  @override
  _DailyCheckState createState() =>
      new _DailyCheckState(this.userID, this.callback);
}

class _DailyCheckState extends State<DailyCheck> {
  final userID;
  final callback;

  _DailyCheckState(this.userID, this.callback);

  bool fetched;
  var preguntas;

  DbUtils db = new DbUtils();

  var responses;

  final myController = TextEditingController();

  int parsearAInt(pregunta) {
    return int.parse(pregunta.toString());
  }

  bool calcularBooleano(text) {
    print("Se va a ir a llamar a " + text.toString());
    int response = parsearAInt(text);
    if (response == 0)
      return false;
    else
      return true;
  }

  void sendResults() {
    var aPersistir = {'fecha': getDate(), 'riesgo': 0};
    int riesgo = 0;
    for (var pregunta in preguntas) {
      print(pregunta);
      if (pregunta["disponibilidad"]) {
        String nombreCorto = pregunta['nomCorto'];
        aPersistir[nombreCorto] = false;
        aPersistir[nombreCorto] = calcularBooleano(responses[nombreCorto]);
        riesgo = riesgo + parsearAInt(pregunta['peso']);
      }
    }

    aPersistir['riesgo'] = riesgo;
    print(aPersistir);
    db.createDailyCheck(aPersistir, userID).then((value) => {});
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

  void initState() {
    super.initState();
    fetched = false;
    responses = {};
  }

  @override
  Widget build(BuildContext context) {
    if (fetched == false) {
      db.getDailyCheckQuestions().get().then((document) => setState(() {
            preguntas = document.data["preguntas"];
            fetched = true;
          }));
    }

    return fetched == false
        ? Loading()
        : Scaffold(
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
              margin: EdgeInsets.all(30.0),
              child: Column(children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                ),
                new Text("Hoy ${getDate()}, usted:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1e3e65),
                        fontSize: 16)),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new Column(
                  children: renderQuestions(preguntas),
                ),
                new SizedBox(
                  height: 20.0,
                ),
                new MaterialButton(
                    height: 40.0,
                    minWidth: 100.0,
                    color: Color(0xfff42f63),
                    textColor: Colors.white,
                    child: new Text("Enviar"),
                    splashColor: Colors.redAccent,
                    onPressed: () {
                      this.callback();
                      Toast.show("Chequeo diario enviado", context);
                      sendResults();
                      Navigator.pop(context);
                    }),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
              ]),
            )));
  }

  List<Widget> renderQuestions(preguntas) {
    List<Widget> lista = [];

    for (var pregunta in preguntas) {
      if (pregunta["disponibilidad"] == true) {
        lista.add(new SizedBox(
          height: 20.0,
        ));
        lista.add(Text(
          '${pregunta["pregunta"]}',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xff1e3e65),
              fontSize: 16),
        ));

        lista.add(new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Radio(
              value: 1,
              groupValue: responses[pregunta["nomCorto"]],
              onChanged: (value) => setState(() {
                print(
                    "Nuevo valor para ${responses[pregunta["nomCorto"]]}: $value");
                responses[pregunta["nomCorto"]] = value;
              }),
            ),
            new Text(
              'Sí',
              style: new TextStyle(fontSize: 16.0),
            ),
            new Radio(
              value: 0,
              groupValue: responses[pregunta["nomCorto"]],
              onChanged: (value) => setState(() {
                responses[pregunta["nomCorto"]] = value;
              }),
            ),
            new Text(
              'No',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ));
        lista.add(new Divider(height: 10.0, color: Color(0xff0066D0)));
      }
    }

    return lista;
  }
}
