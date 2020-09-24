import 'package:covid_19_app/screens/protocol/page.dart';
import 'package:covid_19_app/shared/toast.dart';
import 'package:flutter/material.dart';

var pag = 0;

class Subcategory extends StatelessWidget {
  final title;

  const Subcategory({Key key, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
            alignment: Alignment.center,
            child: new Text(
              "${this.title}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  fontFamily: "Hind", color: Color(0xff1e3e65), fontSize: 30),
            ),
          ),
          Card(
            child: ProtocolPage(),
          ),
          SizedBox(
                height: 30.0,
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new MaterialButton(
                  height: 40.0,
                  minWidth: 90.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Anterior"),
                  splashColor: Colors.redAccent,
                  onPressed: () =>
                      {Toast.show("Aún no implementado", context)}),
              SizedBox(
                width: 30.0,
              ),
              Text("Pág $pag/10"),
              SizedBox(
                width: 30.0,
              ),
              new MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Siguiente"),
                  splashColor: Colors.redAccent,
                  onPressed: () =>
                      {Toast.show("Aún no implementado", context)}),
            ],
          )
        ],
      ),
    );
  }
}
