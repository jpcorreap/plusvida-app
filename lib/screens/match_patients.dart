import 'package:covid_19_app/utils/dbutils.dart';
import 'package:flutter/material.dart';

class MatchPatients extends StatefulWidget {
  //final stream;

  //AdminListOfUsers(this.stream);

  @override
  _MatchPatientsState createState() => new _MatchPatientsState(/*this.stream*/);
}

class _MatchPatientsState extends State<MatchPatients> {
  // final stream;

  _MatchPatientsState(/*this.stream*/);

  DbUtils db = new DbUtils();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Asignación de pacientes',
            style: TextStyle(
                fontFamily: "Hind", fontSize: 20, color: Color(0xffdfedfe)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff1E3E65),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 30.0),
          ),
          Container(
            width: double.infinity,
          ),
          new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 90.0,),
                Text(
                  "Seleccione un profesional de la salud:",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                new DropdownButton<String>(
                  items: <String>['Morita Correa <TipoDoc> <NumDoc>', 'Enfermera 1 <TipoDoc> <NumDoc>', 'Enfermera 2 <TipoDoc> <NumDoc>']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                new SizedBox(height: 50.0,),
                Text(
                  "Seleccione un paciente:",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                new DropdownButton<String>(
                  items: <String>['Juan Pablo Correa <TipoDoc> <NumDoc>', 'Paciente 1 <TipoDoc> <NumDoc>', 'Paciente 2 <TipoDoc> <NumDoc>']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                SizedBox(height: 40.0,),
                new MaterialButton(
                    height: 40.0,
                    minWidth: 100.0,
                    color: Color(0xfff42f63),
                    textColor: Colors.white,
                    child: new Text("Emparejar"),
                    splashColor: Colors.redAccent,
                    onPressed: () => print("Se pulsó en emparejar"),
                  ),
              ])
        ])));
  }

  getFullNameAndID(doc) {
    String name =
        "${doc.data['primNombre']} ${doc.data['segNombre']} ${doc.data['primApellido']} ${doc.data['segApellido']}"
            .trim()
            .replaceAll('  ', ' ');
    return name + ", de ${doc.data['tipoDoc']} número ${doc.data['numDoc']},";
  }
}
