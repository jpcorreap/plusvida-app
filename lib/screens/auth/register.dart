import 'package:covid_19_app/screens/widgets_utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:covid_19_app/utils/authutils.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var _selected = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
  String repeatPassword = '';
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
                      color: Color(0xff1E3E65),
                      colorBlendMode: BlendMode.hardLight,
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Image(
                          image: new AssetImage("assets/home_hospital.gif"),
                          width: 150.0,
                        ),
                        new Text(
                          "Registro de usuario",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 27),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        new Form(
                          key: _formKey,
                          child: new Theme(
                            data: new ThemeData(
                                primaryColor: Colors.white,
                                inputDecorationTheme: new InputDecorationTheme(
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontFamily: "Lato"))),
                            child: new Container(
                              padding: const EdgeInsets.fromLTRB(
                                  60.0, 20.0, 60.0, 0.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                        labelText: "Ingrese un correo"),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) =>
                                        val.isEmpty ? 'Ingrese un email' : null,
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                  ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                      labelText: "Ingrese una contraseña",
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (val) => val.length < 6
                                        ? 'Ingrese una contraseña de 6 o más caracteres'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    obscureText: true,
                                  ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                      labelText: "Repita la contraseña",
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (val) => val.length < 6
                                        ? 'Ingrese una contraseña de 6 o más caracteres'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => repeatPassword = val);
                                    },
                                    obscureText: true,
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _selected,
                                        onChanged: (bool value) {
                                          setState(
                                            () {
                                              _selected = value;
                                            },
                                          );
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              elevation: 16,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(30.0),
                                                child: ListView(
                                                  children: <Widget>[
                                                    Center(
                                                      child: Text(
                                                        "Terminos y condiciones",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              Color(0xff1e3e65),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi blandit tortor vel urna convallis lobortis. Aliquam hendrerit congue lorem, in vulputate tellus rutrum sit amet. Phasellus viverra sollicitudin tempor.\n\nSuspendisse quis tincidunt lorem. Maecenas vitae tellus ex. Nulla ipsum magna, facilisis sed fermentum ac, commodo ut purus. Integer at leo quam. Pellentesque malesuada lectus suscipit, lobortis nisi quis, blandit ante. Nulla lacinia lectus eu blandit dictum.\n\nQuisque tellus nibh, maximus non enim nec, ultrices cursus sapien. In eleifend nisi sem, non tristique odio eleifend et. Aenean cursus purus vel elit vulputate, ut euismod leo ullamcorper. Cras ac magna diam. Suspendisse semper egestas dictum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.", textAlign: TextAlign.justify,),
                                                    SizedBox(height: 20),

                                                    new MaterialButton(
                                                      height: 40.0,
                                                      minWidth: 100.0,
                                                      color: Color(0xfff42f63),
                                                      textColor: Colors.white,
                                                      child:
                                                          new Text("Regresar"),
                                                      splashColor:
                                                          Colors.redAccent,
                                                      onPressed: () => {
                                                        Navigator.pop(
                                                            context, "Cancel")
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        child: Text(
                                          "Acepto términos y condiciones.",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                  ),
                                  new MaterialButton(
                                    height: 50.0,
                                    minWidth: 200.0,
                                    color: Color(0xfff42f63),
                                    textColor: Colors.white,
                                    child: new Text(
                                      "Registrarse",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: "Lato"),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        if (_selected == false) {
                                          setState(() {
                                            error =
                                                "Debe aceptar términos y condiciones";
                                          });
                                        }
                                        else if (password != repeatPassword) {
                                          setState(() {
                                            error =
                                                "Las contraseñas no coinciden";
                                          });
                                        } else {
                                          setState(() => loading = true);
                                          dynamic result = await _auth
                                              .registerWithEmailAndPassword(
                                                  email, password);
                                          if (result == null) {
                                            setState(() {
                                              error =
                                                  'Correo electrónico ya en uso';
                                              loading = false;
                                            });
                                          }
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
                                                text: '¿Ya tiene cuenta? ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Lato")),
                                            TextSpan(
                                                text: 'Inicie sesión',
                                                style: TextStyle(
                                                  color: Colors.white,
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
