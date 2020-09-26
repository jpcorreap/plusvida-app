import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19_app/utils/dbutils.dart';
import 'package:flutter/material.dart';

class AdminListOfUsers extends StatefulWidget {
  final stream;

  AdminListOfUsers(this.stream);

  @override
  _AdminListOfUsersState createState() =>
      new _AdminListOfUsersState(this.stream);
}

class _AdminListOfUsersState extends State<AdminListOfUsers> {
  final stream;

  _AdminListOfUsersState(this.stream);

  DbUtils db = new DbUtils();

  String formatRoles(list) {
    List answer = [];

    if (list == null || list.length == 0) {
      return "Sin asignar";
    }

    if (list.contains("admin")) {
      answer.add("Administrador");
    }

    if (list.contains("paciente")) {
      answer.add("Paciente");
    }

    if (list.contains("profSalud")) {
      answer.add("Prof. de la salud");
    }

    return answer.join(" y${'\n'}");
  }

  Card buildInfo(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Primer nombre:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Segundo nombre:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Primer apellido:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Segundo apellido:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Tipo de documento:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Núm. de documento:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Nacionalidad:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Fecha de nacimiento:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Protocolo actual:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                        formatRoles(doc['roles']).contains('\n')
                            ? "Rol:\n"
                            : "Rol:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                  ]),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['primNombre']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['segNombre']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['primApellido']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['segApellido']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['tipoDoc']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['numDoc']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['nacionalidad']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['nacimiento']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${doc.data['protocolo']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text("${formatRoles(doc.data['roles'])}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16))
                ],
              ),
            ]),
            new Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            new MaterialButton(
              height: 40.0,
              minWidth: 100.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Conceder rol"),
              splashColor: Colors.redAccent,
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    elevation: 16,
                    child: Container(
                      height: 300.0,
                      width: 200.0,
                      margin: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              "¿Seguro que desea concederle al usuario ${getFullNameAndID(doc)} el rol de profesional de la salud?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff1e3e65),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          new MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Color(0xfff42f63),
                            textColor: Colors.white,
                            child: new Text("Confirmar"),
                            splashColor: Colors.redAccent,
                            onPressed: () => {
                              db
                                  .hacerProfSalud('RKN0RJjboPn3LiBVFxrU') // Está re machetero, hay que buscar la forma de sacar el ID de la tarjeta seleccionada
                                  .then((value) => print("added")),
                              Navigator.pop(context, "Cancel")
                            },
                          ),
                          new MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Color(0xfff42f63),
                            textColor: Colors.white,
                            child: new Text("Cancelar"),
                            splashColor: Colors.redAccent,
                            onPressed: () => Navigator.pop(context, "Cancel"),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Conceder prof. salud',
            style: TextStyle(
                fontFamily: "Hind", fontSize: 25, color: Color(0xffdfedfe)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff1E3E65),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 30.0),
          ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                            children: snapshot.data.documents
                                .map((info) => buildInfo(info))
                                .toList());
                      } else {
                        return SizedBox();
                      }
                    })
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
