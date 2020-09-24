import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19_app/services/dbutils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PatientHistory extends StatefulWidget {
  final stream;

  PatientHistory(this.stream);

  @override
  _PatientHistoryState createState() => new _PatientHistoryState(this.stream);
}

class _PatientHistoryState extends State<PatientHistory> {
  final stream;

  _PatientHistoryState(this.stream);

  DbUtils db = new DbUtils();

  Column buildColumn(DocumentSnapshot doc) {
    Random random = new Random();
    var szBox = new SizedBox(height: 12);
    var container = new Container(
        width: 40.0,
        height: 30.0,
        alignment: Alignment.center,
        child: Text(
          random.nextInt(100) < 40 ? " " : "✓",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1e3e65)),
        ),
        color: Colors.white);

    return Column(children: [
      Text(
        "vie 31",
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1e3e65)),
      ),
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      new Container(
          width: 40.0,
          height: 30.0,
          alignment: Alignment.center,
          child: Text(
            "25.9 °C",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff1e3e65),
                fontSize: 10.0),
          ),
          color: Colors.white),
    ]);
  }

  Column buildSpecialColumn(DocumentSnapshot doc) {
    var szBox = new SizedBox(height: 12);
    var container = new Container(
        width: 40.0,
        height: 30.0,
        alignment: Alignment.center,
        child: Text(
          "?",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1e3e65)),
        ),
        color: Colors.white);

    return Column(children: [
      Text(
        "vie 31",
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1e3e65)),
      ),
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
      szBox,
      container,
    ]);
  }

  Row buildDataGrid(DocumentSnapshot document) {
    // Primero hay que partir el array en documentos pequeños
    return Row(children: <Widget>[
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildColumn(document),
      new SizedBox(width: 9),
      buildSpecialColumn(document),
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffdfedfe),
        appBar: AppBar(
          title: Text(
            'Historial de síntomas',
            style: TextStyle(
                fontFamily: "Hind", fontSize: 22, color: Color(0xffdfedfe)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff1E3E65),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
              alignment: Alignment.center,
              child: new Text(
                "Registros de Juan Pablo\nCC 1000123123",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                    fontFamily: "Hind", color: Color(0xff1e3e65), fontSize: 30),
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: new Stack(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: new Container(
                        margin: EdgeInsets.only(left: 103.0),
                        child: buildDataGrid(null),
                      )),
                  new Container(
                    color: Color(0xffdfedfe),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(" "),
                        new SizedBox(height: 10.0),
                        new Text(
                          "Contacto con  \nCOVID-19",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(height: 10.0),
                        new Text(
                          "Tos seca",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(height: 10.0),
                        new Text(
                          "Dolor de\ncabeza",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(height: 10.0),
                        new Text(
                          "Dificultad\npara respirar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(height: 10.0),
                        new Text(
                          "Recaído",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(height: 10.0),
                        new Text(
                          "Vómito\no diarrea",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(height: 10.0),
                        new Text(
                          "Hizo prueba\nCOVID-19",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(height: 10.0),
                        new Text(
                          "Temperatura",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new SizedBox(
              height: 15.0,
            ),
            new Container(
              alignment: Alignment.center,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                new MaterialButton(
                  height: 40.0,
                  minWidth: 60.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Ver enfermedades"),
                  splashColor: Colors.redAccent,
                  onPressed: () => {
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
                                    "\n\nEl usuario registró tener:\n\nProbemas renales y diabetes",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff1e3e65),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  },
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                new MaterialButton(
                  height: 40.0,
                  minWidth: 60.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Asignar protocolo"),
                  splashColor: Colors.redAccent,
                  onPressed: () => {
                    print("Se presionó en Editar"),
                    Navigator.pop(context, "Cancel")
                  },
                )
              ]),
            )
          ],
        )

        /*SingleChildScrollView(
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
                        return Row(
                            children: snapshot.data.documents
                                .map((info) => buildColumn(info))
                                .toList());
                      } else {
                        return SizedBox();
                      }
                    })
              ])
        ]))*/
        );
  }
}
