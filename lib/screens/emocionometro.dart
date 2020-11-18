import 'package:covid_19_app/screens/protocols/protocol.dart';
import 'package:flutter/material.dart';

class Emocionometro extends StatefulWidget {
  @override
  _EmocionometroState createState() => _EmocionometroState();
}

class _EmocionometroState extends State<Emocionometro>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  //Animation<Offset> _offsetAnimation;

  var color;
  String text;

  @override
  void initState() {
    super.initState();
    color = Colors.white;
    text = "";
    /*_controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));*/
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child:
            /*SlideTransition(
          position: _offsetAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [*/
            Column(
          children: [
            SizedBox(
              height: 120.0,
            ),
            GestureDetector(
              onTap: () {
                changeDescription("Abrumado", Colors.orange);
              },
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Colors.red,
                child: Image.asset("assets/emocionometro/girl_1/abrumado.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeDescription("Aterrado", Colors.lightGreen);
              },
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Colors.green,
                child: Image.asset("assets/emocionometro/girl_1/aterrado.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeDescription("Muy_mal", Colors.yellowAccent);
              },
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Colors.yellow,
                child: Image.asset("assets/emocionometro/girl_1/muy_mal.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeDescription("Triste", Colors.lightBlueAccent);
              },
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Color(0xff0238e0),
                child: Image.asset("assets/emocionometro/girl_1/triste.png"),
              ),
            ),
            /*GestureDetector(
              onTap: () => changeDescription("feliz"),
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Colors.green,
                child: Image.asset("assets/emocionometro/girl_1/feliz.png"),
              ),
            ),
            GestureDetector(
              onTap: () => changeDescription("bien"),
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Color(0xff01bdfd),
                child: Image.asset("assets/emocionometro/girl_1/bien.png"),
              ),
            ),
            GestureDetector(
              onTap: () => changeDescription("verde"),
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Color(0xff01afed),
                child: Image.asset("assets/emocionometro/girl_1/abrumado.png"),
              ),
            ),
            GestureDetector(
              onTap: () => changeDescription("muy mal"),
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Color(0xff027fd5),
                child: Image.asset("assets/emocionometro/girl_1/muy_mal.png"),
              ),
            ),
            GestureDetector(
              onTap: () => changeDescription("triste"),
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Color(0xff035fdc),
                child: Image.asset("assets/emocionometro/girl_1/triste.png"),
              ),
            ),
            GestureDetector(
              onTap: () => changeDescription("impotente"),
              child: Container(
                width: 100.0,
                height: 60.0,
                color: Color(0xff0238e0),
                child: Image.asset("assets/emocionometro/girl_1/impotente.png"),
              ),
            ),*/
            Text(
              "\n$text\n",
              style: TextStyle(fontSize: 40.0),
            ),
            new MaterialButton(
              height: 40.0,
              minWidth: 100.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Ver recomendaciones"),
              splashColor: Colors.redAccent,
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Protocol(
                            protocolName:
                                "assets/emocionometro/emociones/" + text.toLowerCase() + ".json")))
              },
            )
          ],
        ),
      ),
    );
  }

  changeDescription(String newState, Color newColor) {
    setState(() {
      this.text = newState;
      this.color = newColor;
    });
  }
}
