import 'package:covid_19_app/screens/requirements/profiles/create_or_edit_house.dart';
import 'package:covid_19_app/screens/requirements/profiles/create_or_edit_profile.dart';
import 'package:covid_19_app/services/auth.dart';
import 'package:covid_19_app/shared/toast.dart';
import 'package:flutter/material.dart';

class IntroTutorial extends StatelessWidget {
  final callback;
  IntroTutorial({this.callback});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroTutorialState(callback: this.callback),
    );
  }
}

class IntroTutorialState extends StatefulWidget {
  final callback;
  IntroTutorialState({this.callback});
  @override
  _IntroTutorialState createState() =>
      _IntroTutorialState(callback: this.callback);
}

class _IntroTutorialState extends State<IntroTutorialState> {
  final callback;
  _IntroTutorialState({@required this.callback});

  var houseData;

  int _currentIndexPage = 0;
  bool hasCreatedAccount;

  initState() {
    super.initState();
    houseData = null;
    hasCreatedAccount = false;
  }

  // This function decides wich screen display according to selected index
  Widget choosePage(context) {
    List<Widget> widgetsList = [];

    switch (_currentIndexPage) {
      case 0:
        {
          widgetsList.add(Text(
            "¡Bienvenido a +Vida!\n\nPara usar la app tendrás que vincularte a una casa e ingresar tus datos personales.\n\n",
            style: TextStyle(
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ));
        }
        break;
      case 1:
        {
          widgetsList.add(Text(
            "Además, con un único correo y contraseña podrás crear y administrar múltiples cuentas.\n\n¡Todo en un mismo lugar!\n\n",
            style: TextStyle(
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ));
        }
        break;
      case 2:
        {
          widgetsList.add(Text(
            "Tu primer paso es vincularte a una Casa.\n\nTodas las Casas tienen un cabeza de hogar.\n\nEsto facilitará el trabajo a los profesionales de la salud.\n\n",
            style: TextStyle(
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ));
        }
        break;
      case 3:
        {
          widgetsList.add(Text(
            "¡Muy bien!\n\nAhora solo falta un último paso, crear tu primera cuenta:\n\n",
            style: TextStyle(
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ));
        }
        break;
      default: // IntroTutorial
        {
          widgetsList.add(Text("PÁGINA default"));
        }
        break;
    }

    widgetsList.add(createNavButtons());

    return Center(
      child: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: widgetsList),
      ),
    );
  }

  // Final build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdfedfe),
      body: Stack(
        children: [
          Image.asset("assets/background_home.png"),
          new Container(
            padding: EdgeInsets.all(16.0),
            child: choosePage(context),
          ),
        ],
      ),
    );
  }

  Widget createNavButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentIndexPage != 0 && _currentIndexPage != 3)
          new MaterialButton(
              height: 40.0,
              minWidth: 90.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Anterior"),
              splashColor: Colors.redAccent,
              onPressed: () => setState(() {
                    _currentIndexPage = _currentIndexPage - 1;
                  })),
        if (_currentIndexPage > 0 && _currentIndexPage < 4)
          SizedBox(
            width: 10.0,
          ),
        if (_currentIndexPage == 2)
          new MaterialButton(
              height: 40.0,
              minWidth: 100.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Crear casa"),
              splashColor: Colors.redAccent,
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HouseForm(
                          callback: cbFunction,
                        ),
                      ),
                    ),
                  }),
        if (_currentIndexPage == 2)
          SizedBox(
            width: 10.0,
          ),
        if (_currentIndexPage == 2)
          new MaterialButton(
            height: 40.0,
            color: Color(0xfff42f63),
            textColor: Colors.white,
            child: new Text("Unirme"),
            splashColor: Colors.redAccent,
            onPressed: () => {Toast.show("Aún no implementado", context)},
          ),
        if (_currentIndexPage == 3)
          new MaterialButton(
              height: 40.0,
              minWidth: 80.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text(hasCreatedAccount == false
                  ? "Crear cuenta"
                  : "Ir a mi inicio"),
              splashColor: Colors.redAccent,
              onPressed: () => {
                    if (hasCreatedAccount == false)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileForm(
                              userData: null,
                              callback: onAccountSuccedCreated,
                              willBeCabezaDeHogar: true,
                            ),
                          ),
                        ),
                      }
                    else
                      {this.callback()}
                  }),
        if (_currentIndexPage == 3)
          SizedBox(
            width: 10.0,
          ),
        if (_currentIndexPage < 2)
          new MaterialButton(
              height: 40.0,
              minWidth: 100.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Siguiente"),
              splashColor: Colors.redAccent,
              onPressed: () => setState(() {
                    _currentIndexPage = _currentIndexPage + 1;
                  })),
        if (_currentIndexPage == 3)
          SizedBox(
            width: 10.0,
          ),
      ],
    );
  }

  showJoin() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 16,
          child: Container(
            height: 300.0,
            width: 300.0,
            margin: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Ingresa el código de la casa",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff1e3e65),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Código",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  keyboardType: TextInputType.number,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 60),
                new MaterialButton(
                    height: 40.0,
                    minWidth: 100.0,
                    color: Color(0xfff42f63),
                    textColor: Colors.white,
                    child: new Text("Buscar"),
                    splashColor: Colors.redAccent,
                    onPressed: () {
                      this.callback();
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  onAccountSuccedCreated() {
    Toast.show("Cuenta creada exitosamente", context);
    Navigator.pop(context, "");
    setState(() {
      this.hasCreatedAccount = true;
    });
    this.callback();
  }

  cbFunction(_newHouseData) {
    print("ENTRÓÓ AL CB");
    Toast.show("Casa creada pero no persistida", context);
    this.setState(
      () {
        this.houseData = _newHouseData;
        _currentIndexPage = _currentIndexPage + 1;
      },
    );
    Navigator.pop(context, "Cancel");
    print(this.houseData);
  }
}
