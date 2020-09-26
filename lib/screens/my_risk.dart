import 'package:flutter/material.dart';

class MyRisk extends StatelessWidget {
  final Stream userStream;

  MyRisk(this.userStream);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffdfedfe),
        appBar: AppBar(
          title: Text(
            'Mi nivel de riesgo',
            style: TextStyle(
                fontFamily: "Hind", fontSize: 25, color: Color(0xffdfedfe)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff1e3e65),
          elevation: 0.0,
        ),
        body: new Container(
          padding: EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: userStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("Loading...");
              // Convert AsyncSnapshot to DocumentSnapshot and then
              // create a map that can be changed and updated.
              final Map<String, dynamic> doc = snapshot.data.data;
              //return Text(userDoc.toString());
              return Column(children: <Widget>[
                Text(
                  "${doc['primNombre']} ${doc['segNombre']}, tu clasificación de riesgo es",
                  style: TextStyle(
                      fontFamily: "Hind",
                      fontSize: 30.0,
                      color: Color(0xff1e3e65)),
                  textAlign: TextAlign.center,
                ),
                generateRiskCard(doc["riesgo"]),
              ]);
            },
          ),
        ));
  }

  generateRiskCard(risk) {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Column(
          children: [
            Text("$risk",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                    color: Color(0xff1e3e65))),
            Container(
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
              child: Text(
                  risk == "Alto"
                      ? "\n\nMucho cuidado, este es el nivel más peligroso lorem ipsum dolor sit amet.\n\n"
                      : risk == "Medio"
                          ? "\n\nEsta es una clasificación moderada, necesitas ser más cuidadoso para que no te asignen el siguiente nivel."
                          : "\n\nNo tiene riesgo asignado",
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xff1e3e65),
                      fontSize: 20.0)),
            ),
          ],
        ));
  }
}
