import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19_app/screens/protocols/protocol_utils.dart';
import 'package:covid_19_app/utils/dbutils.dart';
import 'package:covid_19_app/screens/widgets_utils/toast.dart';
import 'package:flutter/material.dart';


class HouseDashboard extends StatefulWidget {
  final stream;

  HouseDashboard(this.stream);

  @override
  _HouseDashboardState createState() =>
      new _HouseDashboardState(this.stream);
}

class _HouseDashboardState extends State<HouseDashboard> {
  final stream;

  _HouseDashboardState(this.stream);

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
                color: Color(0xff1e3e65),
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
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mi Hogar',
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
            padding: const EdgeInsets.only(top: 45.0),
          ),
          ProtocolUtils().buildTitle({'text':"Actualmente en tu hogar", 'category':1}),
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

  showUserData(DocumentSnapshot doc) {
    Toast.show(doc.data.toString(), context);
  }
}
