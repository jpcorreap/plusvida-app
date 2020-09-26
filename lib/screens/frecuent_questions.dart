import 'package:covid_19_app/screens/info_screen.dart';
import 'package:flutter/material.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = new TextStyle(
        fontSize: 20.0,
        fontFamily: "Hind",
        fontWeight: FontWeight.bold,
        color: Color(0xff0066d0));

    var datos = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Text("Fuente: coronaviruscolombia.gov.co", style: TextStyle(fontWeight: FontWeight.bold),),
        new SizedBox(
          height: 50.0,
        ),
        new Text(
          "¿Qué es un coronavirus?",
          style: titleStyle,
        ),
        createBodyText(
            "Los coronavirus son una extensa familia de virus que causan infecciones respiratorias que pueden ir desde el resfriado común hasta enfermedades más graves como el síndrome respiratorio de Oriente Medio (MERS) y el síndrome respiratorio agudo severo (SRAS). El coronavirus que se ha descubierto más recientemente causa la enfermedad por coronavirus COVID-19."),
        new SizedBox(
          height: 30.0,
        ),
        new Text(
          "¿Qué es el COVID-19?",
          style: titleStyle,
        ),
        createBodyText("El COVID-19 es la enfermedad infecciosa causada por el coronavirus que se ha descubierto más recientemente. Tanto el nuevo virus como la enfermedad eran desconocidos antes de que estallara el brote en Wuhan (China) en diciembre de 2019."),
        new SizedBox(
          height: 30.0,
        ),
        new Text(
          "¿Porqué se llama COVID-19?",
          style: titleStyle,
        ),
        createBodyText("En el nombre abreviado, “CO” corresponde a “corona”, “VI” a “virus” y “D” a “disease” (“enfermedad”). El COVID-19 es una nueva enfermedad descubierta en el año 2019, causada por un nuevo coronavirus que no se había visto antes en seres humanos."),
        new SizedBox(
          height: 30.0,
        ),
      ],
    );

    return InfoScreen("Preguntas frecuentes", datos);
  }

  createBodyText(String text) {
    return new Text(
      text,
      style: new TextStyle(fontSize: 15.0, color: Color(0xff0066d0)),
      textAlign: TextAlign.justify,
    );
  }
}
