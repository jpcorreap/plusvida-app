import 'package:covid_19_app/screens/protocol/subcategory.dart';
import 'package:flutter/material.dart';

class Protocol extends StatefulWidget {
  final protocolData;
  final context;

  Protocol({Key key, this.protocolData, this.context}) : super(key: key);

  @override
  _ProtocolState createState() =>
      _ProtocolState(this.protocolData, this.context);
}

class _ProtocolState extends State<Protocol> {
  final protocolData;
  final context;

  _ProtocolState(this.protocolData, this.context);

  final newData = [
    {
      "name": "Jabón",
      "image": "assets/icons/design_icons/jabon.png",
      "description":
          "El jabón afecta la membrana lipídica del virus, por lo que se recomienda su uso. Puede utilizar el jabón de su agrado."
    },
    {
      "name": "Desinfectante",
      "image": "assets/icons/design_icons/alcohol_70.png",
      "description":
          "Existen distintos tipos de desinfectante, se recomienda usarlos con precaución debido a que algunos pueden generar irritación en los ojos, piel o mucosas. Se recomienda para la limpieza de pisos hipoclorito de uso doméstico."
    },
    {
      "name": "Alcohol al 70%",
      "image": "assets/icons/design_icons/alcohol_70.png",
      "description":
          "Se debe aplicar para la desinfección como se detalla en el apartado de desinfección de la casa."
    },
    {
      "name": "Alcohol glicerinado",
      "image": "assets/icons/design_icons/alcohol_glicerinado.png",
      "description":
          "Se puede usar para el lavado de manos en los momentos que no se cuente con agua y jabón y las manos están visualmente limpias."
    }
  ];

  var index;

  Card generateListItem(String info) {
    return Card(
      child: GestureDetector(
        onTap: () => showSubcategory(info),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                info,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return index != 0
        ? Subcategory(title: 'Recursos necesarios para la desinfección')
        : Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              generateListItem("Recursos necesarios para\nla desinfección"),
              generateListItem("Subcategoría genérica 2"),
              generateListItem("Subcategoría genérica 3"),
              generateListItem("Subcategoría genérica 4"),
              generateListItem("Subcategoría genérica 5"),
              generateListItem("Subcategoría genérica 6"),
              SizedBox(
                height: 20.0,
              ),
            ],
          );
  }

  showSubcategory(String info) {
    print("Se va a cambiar el estado");
    setState(() {
      this.index = 1;
    });
  }

  Widget chooseScreen(user, context) {
    return Center(child: Text("$index", style: TextStyle(fontSize: 20.0)));
  }

  Widget createNavButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (index != 0)
          new MaterialButton(
              height: 40.0,
              minWidth: 90.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Anterior"),
              splashColor: Colors.redAccent,
              onPressed: () => setState(() {
                    index = index - 1;
                  })),
        if (index > 0 && index < 10)
          SizedBox(
            width: 10.0,
          ),
        if (index != 10)
          new MaterialButton(
              height: 40.0,
              minWidth: 90.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Siguiente"),
              splashColor: Colors.redAccent,
              onPressed: () => setState(() {
                    index = index - 1;
                  })),
      ],
    );
  }
}
