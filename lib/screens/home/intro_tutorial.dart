import 'package:covid_19_app/utils/dbutils.dart';
import 'package:flutter/material.dart';
import 'package:covid_19_app/screens/profiles/create_or_edit_house.dart';
import 'package:covid_19_app/screens/profiles/create_or_edit_profile.dart';
import 'package:covid_19_app/screens/widgets_utils/toast.dart';

/// Clase que muestra el tutorial a alguien que aun no se ha creado una cuenta.
///
/// Necesita un [callback] que sera llamado en cuanto se haya completado satisfactoriamente el tutorial.
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
  /// Callback que sera llamado cuando se complete el tutorial.
  final callback;
  _IntroTutorialState({@required this.callback});

  /// Almacena la informacion de la casa creada.
  var houseData;

  /// Pagina actual de navegacion, iniciando en 0.
  int _currentIndexPage;

  /// Representa si ya se ha creado una cuenta en el tutorial.
  bool hasCreatedAccount;

  /// Reference to database
  DbUtils db = new DbUtils();

  bool willBeCabezaDeHogar;

  String houseID;

  /// Inicializa el estado de la clase.
  initState() {
    super.initState();
    this._currentIndexPage = 0;
    houseData = null;
    hasCreatedAccount = false;
    willBeCabezaDeHogar = false;
    houseID = "";
  }

  generateRichText(title, description, numberPage) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: '\n$title\n',
                style: TextStyle(
                    color: Color(0xff1E3E65),
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                    fontFamily: "Hind")),
            TextSpan(
              text: '\n\n$description',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: "Lato",
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            TextSpan(
                text: '\n\n\n$numberPage/4',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  /// Decides wich screen display according to selected index.
  Widget choosePage(context) {
    List<Widget> widgetsList = [];

    switch (_currentIndexPage) {
      case 0:
        {
          widgetsList.add(generateRichText(
              '¡Bienvenido a +Vida!',
              'Para usar la app tendrás que vincularte a un hogar e ingresar tus datos personales.',
              '1'));
        }
        break;
      case 1:
        {
          widgetsList.add(generateRichText(
              'Tu usuario te facilita la vida',
              'Desde tu hogar podrás crear y administrar múltiples cuentas.\n\n¡Todo en un mismo lugar!',
              '2'));
        }
        break;
      case 2:
        {
          widgetsList.add(generateRichText(
              'Configuración de Tu Hogar',
              'Al gestionar Tu Hogar, facilitas enormemente el trabajo de los profesionales de la salud.\n\n¡Comienza creando un hogar o uniéndote a uno!',
              '3'));
        }
        break;
      case 3:
        {
          widgetsList.add(generateRichText(
              'Creación de cuenta',
              '¡Muy bien!\n\nAhora solo falta un último paso, crear tu primera cuenta:',
              '4'));
        }
        break;
      default: // IntroTutorial
        {
          widgetsList.add(Text("Default"));
        }
        break;
    }

    // Crea los botones de navegacion.
    widgetsList.add(SizedBox(
      height: 30.0,
    ));
    widgetsList.add(createNavButtons());

    return Center(
      child: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: widgetsList),
      ),
    );
  }

  /// Builds the navbar buttons based on the current page.
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
            onPressed: () => setState(
              () {
                _currentIndexPage = _currentIndexPage - 1;
              },
            ),
          ),
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
            child: new Text("Crear Hogar"),
            splashColor: Colors.redAccent,
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HouseForm(
                    callback: persistHouseData,
                  ),
                ),
              ),
            },
          ),
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
            onPressed: () => {showJoin()},
          ),
        if (_currentIndexPage == 3)
          new MaterialButton(
            height: 40.0,
            minWidth: 80.0,
            color: Color(0xfff42f63),
            textColor: Colors.white,
            child: new Text(
                hasCreatedAccount == false ? "Crear cuenta" : "Ir a mi inicio"),
            splashColor: Colors.redAccent,
            onPressed: () {
              if (hasCreatedAccount == false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileForm(
                      userData: null,
                      callback: onAccountSuccedCreated,
                      willBeCabezaDeHogar: this.willBeCabezaDeHogar,
                      casaID: this.houseID,
                    ),
                  ),
                );
              } else {
                this.callback();
              }
            },
          ),
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
            child: new Text("¡Entendido!"),
            splashColor: Colors.redAccent,
            onPressed: () => setState(() {
              _currentIndexPage = _currentIndexPage + 1;
            }),
          ),
        if (_currentIndexPage == 3)
          SizedBox(
            width: 10.0,
          ),
      ],
    );
  }

  TextEditingController _casaExistente = TextEditingController();

  /// Displays a dialog to login into a House.
  void showJoin() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 16,
          child: Container(
            height: 270.0,
            width: 300.0,
            margin: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                    "Ingresa el identificador de la casa",
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
                  controller: _casaExistente,
                  decoration: new InputDecoration(
                    labelText: "Identificador",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: new TextStyle(
                    fontFamily: "Lato",
                  ),
                ),
                SizedBox(height: 60),
                new MaterialButton(
                  height: 40.0,
                  color: Color(0xfff42f63),
                  textColor: Colors.white,
                  child: new Text("Buscar"),
                  splashColor: Colors.redAccent,
                  onPressed: () async {
                    Navigator.pop(context);
                    db.getHouse(_casaExistente.text).get().then(
                      (doc) {
                        if (doc.data == null) {
                          Toast.show(
                              "No se encontró un hogar con ese identificador.",
                              this.context);
                        } else {
                          db
                              .updateHouseOfAccount(_casaExistente.text)
                              .then((value) => this.setState(() {
                                    _currentIndexPage = _currentIndexPage + 1;
                                    Toast.show(
                                        "Correo y contraseña vinculadas a la casa ${_casaExistente.text}",
                                        this.context);
                                    setState(() {
                                      this.willBeCabezaDeHogar = false;
                                      this.houseID = _casaExistente.text;
                                    });
                                  }));
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// Callback for succed account created
  void onAccountSuccedCreated(cabezaDeHogarID) {
    Toast.show("Cuenta creada exitosamente", context);

    if (cabezaDeHogarID != null)
      db.createHouse(cabezaDeHogarID, houseData).then((value) {});

    setState(() {
      this.hasCreatedAccount = true;
    });
    this.callback();
  }

  /// Callback for new house created.
  ///
  /// [_newHouseData] contains data of new created house.
  void persistHouseData(_newHouseData) {
    // La casa no se puede persistir aqui porque se necesita el documento de la persona cabeza de hogar
    this.setState(
      () {
        this.houseData = _newHouseData;
        _currentIndexPage = _currentIndexPage + 1;
        this.willBeCabezaDeHogar = true;
      },
    );
    Toast.show("Información validada. Cree una cuenta para persistir el hogar.",
        context);
    Navigator.pop(context, "Cancel");
    print("SE TIENE INFO DE LA CASA " + this.houseData.toString());
  }

  /// Builds this tutorial.
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
}
