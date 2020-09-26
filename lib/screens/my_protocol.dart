import 'package:flutter/material.dart';

class MyProtocol extends StatelessWidget {
  final Stream userMyProtocol;

  MyProtocol(this.userMyProtocol);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffdfedfe),
        appBar: AppBar(
          title: Text(
            'Mi Myprotocolo',
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
            stream: userMyProtocol,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("Loading...");
              // Convert AsyncSnapshot to DocumentSnapshot and then
              // create a map that can be changed and updated.
              final Map<String, dynamic> doc = snapshot.data.data;
              //return Text(userDoc.toString());
              return Column(children: <Widget>[
                Text(
                  "${doc['primNombre']} ${doc['segNombre']},\n tu Myprotocolo es",
                  style: TextStyle(
                      fontFamily: "Hind",
                      fontSize: 30.0,
                      color: Color(0xff1e3e65)),
                  textAlign: TextAlign.center,
                ),
                generateMyProtocolCard(doc["Myprotocolo"]),
              ]);
            },
          ),
        ));
  }

  generateMyProtocolCard(protocol) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        children: [
          Text("$protocol",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                  color: Color(0xff1e3e65))),
          Container(
            margin: EdgeInsets.all(20.0),
            child: new Image(
              image: new AssetImage(protocol == "Casa"
                  ? "assets/home.gif"
                  : "assets/home_hospital.gif"),
              width: 150.0,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
            child: Text(
                protocol == "Casa"
                    ? "Estando en el hogar debes desinfectar los paquetes, además no olvides lorem ipsum dolor sit amet.\n\n"
                    : protocol == "Hospital"
                        ? "En el hospital es donde más cuidadosos hay que estar, ojo con las jeringas."
                        : "No tiene Myprotocolo asignado",
                textAlign: TextAlign.justify,
                overflow: TextOverflow.visible,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xff1e3e65),
                    fontSize: 20.0)),
          ),
        ],
      ),
    );
  }
}
