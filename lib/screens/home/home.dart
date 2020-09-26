import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19_app/screens/daily_check.dart';
import 'package:covid_19_app/screens/emocionometro.dart';
import 'package:covid_19_app/screens/frecuent_questions.dart';
import 'package:covid_19_app/screens/info_screen.dart';
import 'package:covid_19_app/screens/my_patients.dart';
import 'package:covid_19_app/screens/protocols/protocol.dart';
import 'package:covid_19_app/screens/widgets_utils/toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:covid_19_app/screens/multiple_profiles.dart';
import 'package:covid_19_app/screens/secure_transit.dart';
import 'package:covid_19_app/screens/profiles/view_profile.dart';
import 'package:covid_19_app/utils/authutils.dart';
import 'package:covid_19_app/utils/dbutils.dart';
import 'package:flutter/material.dart';
import '../chatbot.dart';

/// The Firestore Authentication Services.
final AuthService _auth = AuthService();

/// The connection to DataBase.
final DbUtils db = new DbUtils();

/// Roles of the current user. It could contains paciente, profSalud or admin.
List roles = [];

/// [Stream] to the current user data.
Stream<DocumentSnapshot> userSnapshot;

/// Main Home menu of the app, once user has been signed and chosen an account.
class Home extends StatelessWidget {
  /// ID of the current user.
  final String userID;

  /// Initializes this Home Widget, setting the [userSnapshot] to the current user account.
  /// 
  /// Requires [userID] for the app to know which are the current account chosen.
  Home(this.userID) {
    userSnapshot = db.getUserSnapshot(this.userID);
    print("home.dart tiene un userSnapshot para el usuario " + userID);
  }

  @override
  Widget build(BuildContext context) {
    print("En New Home se trajo el uID " + userID);
    return MaterialApp(
      title: "Inicio",
      home: HomeState(this.userID),
    );
  }
}

class HomeState extends StatefulWidget {
  final String userID;
  HomeState(this.userID);

  @override
  _HomeState createState() => _HomeState(this.userID);
}

class _HomeState extends State<HomeState> {
  final String userID;
  String name;

  _HomeState(this.userID);

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Creates one of the options in a screen
  Row createMenuOption(text, icon, screen, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 6.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff439aff)),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 35.0,
              color: Color(0xff439aff),
            ),
          ),
        ),
      ],
    );
  }

  generateInfoDialog(data) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 16,
          child: Container(
            width: 300.0,
            height: 320.0,
            margin: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                new Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset("assets/design_icons/jabon.png"),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    data["name"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff1e3e65),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  data["description"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff1e3e65),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 15),
                new MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Regresar"),
                  splashColor: Colors.redAccent,
                  onPressed: () => {Navigator.pop(context, "Cancel")},
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // This function decides wich widgets display according to selected index by the user
  Widget chooseWidgets(user, context) {
    Widget retornar;

    switch (_selectedIndex) {
      case 0:
        {
          retornar = Chatbot(
            name: this.name,
          );
        }
        break;
      case 1: // It depends on user role
        {
          if (roles.contains("profSalud")) {
            retornar = new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mis pacientes",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        fontFamily: "Hind",
                        color: Color(0xff1e3e65),
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  new SizedBox(
                    height: 70.0,
                  ),
                  createMenuOptionWithSVG(
                      "Ver chequeos diarios",
                      "assets/icons/chequeo_diario.svg",
                      PatientHistory(db.getMyPatients(userID)),
                      context),
                  createMenuOptionWithSVG(
                      "Ver mis pacientes",
                      "assets/icons/chequeo_diario.svg",
                      MultipleProfiles(db.getMyPatients(userID)),
                      context)
                ]);
          } else if (roles.contains("paciente"))
            retornar = new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Necesito información\nacerca de...",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontFamily: "Hind",
                      color: Color(0xff1e3e65),
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                new SizedBox(
                  height: 70.0,
                ),
                createMenuOption("Preguntas frecuentes",
                    Icons.perm_device_information, FAQ(), context),
                createMenuOption("Tránsito seguro en casa", Icons.home,
                    SecureTransit(), context),
                createMenuOptionWithSVG(
                    "Protocolo LyD",
                    "assets/icons/paciente/protocolo.svg",
                    InfoScreen(
                      "Protocolo Limpieza y Desinfección",
                      Protocol(protocolData: {
                        'title': 'Protocolo Limpuieza y Desinfección',
                        'subcategories': [
                          'Subcategoría 1',
                          'Subcategoría 2',
                          'Subcategoría 3'
                        ]
                      }),
                    ),
                    context)
              ],
            );
        }
        break;
      case 3: // Notifications option
        {
          retornar = Text(
            "Las notificaciones aún no están implementadas.",
            style: TextStyle(fontSize: 30.0),
          );
        }
        break;
      case 4: // Profile option
        {
          retornar = new Center(
            child: SingleChildScrollView(
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Profile(userSnapshot),
                    /*new MaterialButton(
                    color: Color(0xfff42f63),
                    textColor: Colors.white,
                    child: new Text("Solicitar perfil de colaborador"),
                    splashColor: Colors.redAccent,
                    onPressed: () => showToast(
                        "Se ha enviado una solicitud de aprobación al administrador",
                        gravity: Toast.BOTTOM)),*/
                    new SizedBox(
                      height: 10.0,
                    ),
                  ]),
            ),
          );
        }
        break;
      default: // Home
        {
          retornar = new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¡Bienvenido(a) ${user['primNombre']}${user['segNombre'] != "" ? " " + user['segNombre'] : ""}!",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                    fontFamily: "Hind", color: Color(0xff1e3e65), fontSize: 40),
              ),
              new SizedBox(
                height: 10.0,
              ),
              Text(
                "Cuidándote cuidas a todos",
                style: TextStyle(fontSize: 20.0),
              ),
              new SizedBox(
                height: 50.0,
              ),
              createMenuOption("Chequeo diario", Icons.check_box,
                  DailyCheck(userID), context),
              // Show users protocol
              //createMenuOption("Mis protocolos", Icons.short_text,
              //Protocol(userSnapshot), context),
              createMenuOption("Emocionómetro", Icons.insert_emoticon,
                  FavoriteWidget(), context),
            ],
          );
        }
        break;
    }
    return retornar;
  }

  getOptionBasedOnRole() {
    if (roles.contains("profSalud"))
      return BottomNavigationBarItem(
          icon: Icon(Icons.people, color: Colors.white),
          backgroundColor: Color(0xff439aff),
          title: Text('Mis pacientes'));
    else if (roles.contains("admin"))
      return BottomNavigationBarItem(
          icon: Icon(Icons.info, color: Colors.white),
          backgroundColor: Color(0xff439aff),
          title: Text('Administrador'));
    else
      return BottomNavigationBarItem(
          icon: Icon(Icons.info, color: Colors.white),
          backgroundColor: Color(0xff439aff),
          title: Text('Información'));
  }

  createMenuOptionWithSVG(String text, String ruta, screen, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 6.0),
                child: Text(text,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff439aff),
                    )),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: SvgPicture.asset(
                ruta,
                color: Color(0xff439aff),
              )),
            ))
      ],
    );
  }

  createBodyDemo() {
    String str =
        "Antes de hacer la limpieza o desinfección se deben lavar las manos. Luego de secarlas se debe colocar guantes. Después de hacer la limpieza quitarse los guantes (si son desechables botarlos y sino lavarlos) y lavarse las manos. Se debe evitar el contacto con ojos, nariz y boca. type: titel_2 1.1 Recursos necesarios para la desinfección type: titel_3 1.1.1 Elementos de limpieza Jabón: El jabón afecta la membrana lipídica del virus, por lo que se recomienda su uso. Puede utilizar el jabón de su agrado. Desinfectante: Existen distintos tipos de desinfectante, se recomienda usarlos con precaución debido a que";
    return Text(str);
  }

  // Final build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdfedfe),
      appBar: AppBar(
        title: Text('Hospital COVID-19',
            style: TextStyle(
                color: Color(0xffdfedfe), fontSize: 21, fontFamily: "Hind")),
        backgroundColor: Color(0xff1e3e65),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.person,
              color: Color(0xffdfedfe),
            ),
            label: Text('Cerrar sesión',
                style: TextStyle(color: Color(0xffdfedfe), fontFamily: "Hind")),
            onPressed: () async {
              await _auth.signOut();
              Toast.show(
                  "Ya cerró sesión pero hay que darle al botón de back por algo que desconozco. Att Juan Pablo.",
                  context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset("assets/background_home.png"),
          StreamBuilder(
            stream: db.getUserSnapshot(userID),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("Loading...");
              // Convert AsyncSnapshot to DocumentSnapshot and then
              // create a map that can be changed and updated.
              final Map<String, dynamic> doc = snapshot.data.data;
              //return Text(userDoc.toString());
              roles = doc["roles"];
              name = doc["primNombre"] +
                  (doc["segNombre"] != "" ? " " + doc["segNombre"] : "");
              return new Container(
                  padding: EdgeInsets.all(16.0),
                  child: chooseWidgets(doc, context));
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.white),
            backgroundColor: Color(0xff439aff),
            title: Text('Chat'),
          ),
          getOptionBasedOnRole(),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            backgroundColor: Color(0xff439aff),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.white),
            backgroundColor: Color(0xff439aff),
            title: Text('Notificaciones'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            backgroundColor: Color(0xff439aff),
            title: Text('Mi perfil'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
