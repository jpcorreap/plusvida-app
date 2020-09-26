import 'package:covid_19_app/screens/widgets_utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:covid_19_app/utils/authutils.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
          resizeToAvoidBottomInset: false,
            body: new Container(
              child: new Center(
                child: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image(
                        image: new AssetImage("assets/woman.jpg"),
                        fit: BoxFit.cover,
                        color: Color(0xffDFEDFE),
                        colorBlendMode: BlendMode.hardLight),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Image(
                          image: new AssetImage("assets/home_hospital.gif"),
                          width: 150.0,
                        ),
                        new Text(
                          "Inicio de sesión",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3e65),
                              fontSize: 27),
                        ),
                        Text(
                          "\n" + error,
                          style: TextStyle(color: Colors.red, fontSize: 15.0),
                        ),
                        new Form(
                          key: _formKey,
                          child: new Theme(
                            data: new ThemeData(
                                primaryColor: Color(0xff439AFF),
                                inputDecorationTheme: new InputDecorationTheme(
                                    labelStyle: TextStyle(
                                        color: Color(0xff439AFF),
                                        fontSize: 18.0,
                                        fontFamily: "Lato"))),
                            child: new Container(
                              padding: const EdgeInsets.fromLTRB(
                                  60.0, 10.0, 60.0, 0.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                      labelText: "Correo electrónico",
                                    ),
                                    style: TextStyle(
                                        color: Color(0xff439AFF),
                                        fontWeight: FontWeight.normal),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) =>
                                        val.isEmpty ? 'Ingrese un email' : null,
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                  ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                      labelText: "Contraseña",
                                    ),
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Color(0xff439AFF),
                                        fontWeight: FontWeight.normal),
                                    validator: (val) => val.length < 6
                                        ? 'Ingrese una contraseña de 6 o más caracteres'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    obscureText: true,
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                  ),
                                  new MaterialButton(
                                    height: 50.0,
                                    minWidth: 200.0,
                                    color: Color(0xfff42f63),
                                    textColor: Colors.white,
                                    child: new Text(
                                      "Iniciar sesión",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Lato",
                                          fontSize: 20.0),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(
                                                email, password);
                                        print(result);
                                        if (result == null) {
                                          setState(() {
                                            error = 'Usuario o contraseña incorrectas.';
                                            loading = false;
                                          });
                                        }
                                      }
                                    },
                                    splashColor: Colors.redAccent,
                                  ),
                                  SizedBox(height: 12.0),
                                  GestureDetector(
                                    child: FlatButton.icon(
                                      icon: SizedBox(),
                                      label: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '¿No tiene cuenta? ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "Lato")),
                                            TextSpan(
                                                text: 'Regístrese',
                                                style: TextStyle(
                                                  color: Color(0xff1E3E65),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            TextSpan(
                                                text: '.',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                                      onPressed: () {
                                        widget.toggleView();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
