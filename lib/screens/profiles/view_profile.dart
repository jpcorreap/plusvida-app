import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19_app/utils/dbutils.dart';
import 'package:covid_19_app/screens/widgets_utils/toast.dart';
import 'package:flutter/material.dart';
import 'create_or_edit_profile.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final Stream stream;

  Profile(this.stream);

  @override
  _ProfileState createState() => new _ProfileState(this.stream);
}

class _ProfileState extends State<Profile> {
  Stream<DocumentSnapshot> stream;

  _ProfileState(this.stream);

  var phoneNumber = "573052642591";
  var userData;

  DbUtils db = new DbUtils();

  String formatRoles(list) {
    List answer = [];

    if (list == null || list.length == 0) return "Sin asignar";
    if (list.contains("admin")) answer.add("Administrador");
    if (list.contains("paciente")) answer.add("Paciente");
    if (list.contains("profSalud")) answer.add("Prof. salud");

    return answer.join(" y${'\n'}");
  }

  Card buildUsersInfo(doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Text(
              "Perfil de ${doc['primNombre']} ${doc['segNombre']}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Color(0xff1e3e65)),
              textAlign: TextAlign.center,
            ),
            new SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "Primer nombre:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1e3e65),
                          fontSize: 16),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "Segundo nombre:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1e3e65),
                          fontSize: 16),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "Primer apellido:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1e3e65),
                          fontSize: 16),
                    ),
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
                    Text("Género:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("Documento:",
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
                    Text("Nacimiento:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3e65),
                            fontSize: 16)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "Protocolo actual:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1e3e65),
                          fontSize: 16),
                    ),
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
                          fontSize: 16),
                    ),
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
                  Text(
                    '${doc['primNombre']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1e3e65),
                        fontSize: 16),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text(
                    '${doc['segNombre']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1e3e65),
                        fontSize: 16),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text(
                    '${doc['primApellido']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1e3e65),
                        fontSize: 16),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text(
                    '${doc['segApellido']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1e3e65),
                        fontSize: 16),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text('${userData["genero"]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text(userData["id"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text('${doc['nacionalidad']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1e3e65),
                          fontSize: 16)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text(
                    DateTime.parse(doc['nacimiento'].toDate().toString())
                        .toString()
                        .split(" ")[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1e3e65),
                        fontSize: 16),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text(
                    "${doc['protocolo']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1e3e65),
                        fontSize: 16),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  Text(
                    "${formatRoles(doc['roles'])}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1e3e65),
                        fontSize: 16),
                  )
                ],
              ),
            ]),
            new Padding(
              padding: const EdgeInsets.only(top: 15.0),
            ),
            new MaterialButton(
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Editar perfil"),
              splashColor: Colors.redAccent,
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileForm(
                      userData: userData,
                      callback: cbFunction,
                      willBeCabezaDeHogar: false,
                    ),
                  ),
                ),
              },
              onLongPress: () => Toast.show(
                  "Solicitud de colaboración enviada al administrador",
                  context),
            ),
            /*Row(
                                    children: [
                                      SizedBox(
                                        width: 52.0,
                                      ),
                                      new MaterialButton(
                                        color: Color(0xfff42f63),
                                        textColor: Colors.white,
                                        child: new Text("Probar WhatsApp"),
                                        splashColor: Colors.redAccent,
                                        onPressed: _callWhatsApp,
                                        onLongPress: () => Toast.show(
                                            "Solicitud de colaboración enviada al administrador",
                                            context),
                                      ),
                                    ],
                                  ),*/
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Convert AsyncSnapshot to DocumentSnapshot and then
            // create a map that can be changed and updated.
            final user = snapshot.data.data;
            userData = user;
            userData["id"] = snapshot.data.documentID;
            phoneNumber = userData["numTelefono"].toString();
            print(user);
            return buildUsersInfo(user);
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  void _callWhatsApp() async {
    const url = 'https://wa.me/' + '573052642591';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  cbFunction() {
    print("ENTRÓÓ");
    Toast.show(
        "Esto simula que ya se actualizó pero está pendiente validar un par de cuestiones con la información", context);
    Navigator.pop(this.context);
  }
}
