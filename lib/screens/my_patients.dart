import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19_app/utils/dbutils.dart';
import 'package:covid_19_app/screens/widgets_utils/toast.dart';
import 'package:flutter/material.dart';

import 'multiple_profiles.dart';

class MultipleProfiles extends StatefulWidget {
  final stream;

  MultipleProfiles(this.stream);

  @override
  _MultipleProfilesState createState() =>
      new _MultipleProfilesState(this.stream);
}

class _MultipleProfilesState extends State<MultipleProfiles> {
  final stream;

  _MultipleProfilesState(this.stream);

  DbUtils db = new DbUtils();

  Card buildInfo(DocumentSnapshot doc) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.only(bottom: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              "${doc['primNombre']} ${doc['segNombre']}\n${doc['primApellido']} ${doc['segApellido']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: chooseColor(doc['riesgo']),
              ),
              textAlign: TextAlign.center,
            ),
            new SizedBox(
              height: 10.0,
            ),
            Text("${doc.documentID}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e3e65),
                    fontSize: 20)),
            new SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                new MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Ver datos"),
                  splashColor: Colors.red,
                  onPressed: () => showUserData(doc),
                ),
                new SizedBox(
                  width: 20.0,
                ),
                GestureDetector(
                    child: Container(
                      color: Colors.green,
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                          child: Text("16/09\n0%",
                          textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    ),
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PatientHistory(db.getMyPatients(""))),
                          )
                          //Navigator.pop(context, "Cancel")
                        }),
                GestureDetector(
                    child: Container(
                      color: Colors.orange,
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                          child: Text("17/09\n50%",
                          textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    ),
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PatientHistory(db.getMyPatients(""))),
                          )
                          //Navigator.pop(context, "Cancel")
                        }),
                GestureDetector(
                  child: Container(
                    color: Colors.red,
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                        child: Text("18/09\n100%",
                        textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PatientHistory(db.getMyPatients(""))),
                    )
                    //Navigator.pop(context, "Cancel")
                  },
                ),
              ],
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
            'Mis pacientes',
            style: TextStyle(
                fontFamily: "Hind", fontSize: 25, color: Color(0xffdfedfe)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff1E3E65),
        ),
        backgroundColor: Color(0xffDFEDFE),
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

  chooseColor(int risk) {
    Color color;
    switch (risk) {
      case 2:
        color = Color(0xffcc0303);
        break;
      case 1:
        color = Colors.orange;
        break;
      case 0:
        color = Colors.green;
        break;
      default:
        color = Color(0xff1e3e65);
    }

    return color;
  }

  showUserData(DocumentSnapshot doc) {
    Toast.show(doc.data.toString(), context);
  }
}
