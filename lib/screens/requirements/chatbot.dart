import 'package:bubble/bubble.dart';
import 'package:covid_19_app/shared/loading.dart';
import 'package:covid_19_app/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

/// Chatbox to interact in the app
class Chatbot extends StatefulWidget {
  /// The name of the user wich will be interacting with the Chatbot
  final name;

  Chatbot({@required this.name});

  @override
  _ChatbotState createState() => _ChatbotState(this.name);
}

class _ChatbotState extends State<Chatbot> {
  /// The name of the user wich will be interacting with the Chatbot
  final name;
  _ChatbotState(this.name);

  /// Dialogflow object
  Dialogflow dialogflow;
  bool holaSended;

  /// To knows if dialogflow object has been fetched
  bool dialogFlowFetched;

  /// Input for the users questions
  final messageInsert = TextEditingController();

  /// List of messages
  List<Map> messages = List();

  void initState() {
    super.initState();
    dialogflow = null;
    dialogFlowFetched = false;
    holaSended = false;
  }

  /// It makes questions to the Chatbot
  void makeQuestion(query) async {
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    var responses = aiResponse.getListMessage();

    var messageUtils = renderAnswer(responses);

    setState(() {
      messages.insert(0, {
        "data": 0,
        "message": messageUtils["message"],
        "options": messageUtils["options"]
      });
    });
  }

  setupChatbot() {
    // If there is no DialogFlow it must be fetched
    AuthGoogle(fileJson: "assets/eli-osjukx-f28e600af05e.json")
        .build()
        .then((authGoogle) {
      setState(() {
        dialogflow = Dialogflow(
            authGoogle: authGoogle, language: Language.spanishLatinAmerica);
        dialogFlowFetched = true;
      });

      if (dialogFlowFetched == true && holaSended == false) {
        makeQuestion("hola");
        setState(() {
          holaSended = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dialogFlowFetched == false) setupChatbot();

    return dialogFlowFetched == false
        ? Loading()
        : Container(
            child: Column(
              children: <Widget>[
                Flexible(
                    child: ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) => renderChatBubble(
                            messages[index]["message"].toString(),
                            messages[index]["data"],
                            messages[index]["options"]))),
                Divider(
                  height: 5.0,
                  color: Color(0xff0066d0),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                        controller: messageInsert,
                        decoration: InputDecoration.collapsed(
                            hintText: "Escribe tu mensaje...",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 18.0)),
                      )),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.send,
                              size: 30.0,
                              color: Color(0xff0066d0),
                            ),
                            onPressed: () {
                              if (messageInsert.text.isEmpty) {
                                print("empty message");
                              } else {
                                setState(() {
                                  messages.insert(0, {
                                    "data": 1,
                                    "message": messageInsert.text,
                                    "options": null,
                                  });
                                });
                                makeQuestion(messageInsert.text);
                                messageInsert.clear();
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget renderChatBubble(
      String message, int data, List<Widget> optionalButtons) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
        radius: Radius.circular(15.0),
        color: data == 0 ? Color(0xff0066d0) : Color(0xff439aff),
        elevation: 0.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(
                    data == 0 ? "assets/bot.png" : "assets/user.png"),
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Lato"),
                    ),
                    if (optionalButtons != null)
                      SizedBox(
                        height: 10.0,
                      ),
                    if (optionalButtons != null)
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: optionalButtons),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String createChipsMenu(data) {
    var respuesta = "";

    data["options"].forEach((element) {
      respuesta += "\n > " + element["text"];
    });

    return respuesta;
  }

  renderAnswer(List responses) {
    String finalMessage;
    List<Widget> options;

    print(">> " + responses.toString());
    String caso;
    // Trivial unique test case:
    // If it is Hola case
    try {
      // CASO 1
      finalMessage =
          (responses[1]["payload"]["richContent"][0][0]["text"][0].toString())
              .replaceAll('%NombreUsuario%', this.name);

      options = renderOptions(
          responses[1]["payload"]["richContent"][1][0]["options"]);
      caso = "CASO 1";
    } catch (e) {
      // CASO 2
      print("Error con el caso 1: " + e.toString());
      try {
        finalMessage = responses[1]["payload"]["richContent"].forEach(
          (element) {
            var data = element[0];
            if (data["type"] == "description") {
              finalMessage = data["text"][0];
            } else if (data["type"] == "chips") {
              finalMessage += "\n" + createChipsMenu(data);
            }
          },
        );
        caso = "CASO 2";
      } catch (e2) {
        // CASO 3
        print("Error con el caso 2: " + e2.toString());
        try {
          finalMessage = responses[0]["text"]["text"][0].toString();
          caso = "CASO 3";
        } catch (e3) {
          print("Error con el caso 3: " + e3.toString());
          try {
            finalMessage =
                responses[0]["payload"]["richContent"][0][0]["text"][0];

            //finalMessage += responses[0]["payload"]["richcontent"][0][1]
            //        ["options"]
            //    .toString();
            // TODO Send to a botton generator
            options = renderOptions(
                responses[0]["payload"]["richContent"][1][0]["options"]);

            caso = "CASO 4";
          } catch (e4) {
            print("Error con el caso 4: " + e4.toString());
            finalMessage = responses.toString();
            caso = "CASO DEFAULT";
          }
        }
      }
    } finally {
      print(caso);
    }
    return {
      "message": finalMessage,
      "options": options,
    };
  }

  List<Widget> renderOptions(data) {
    List<Widget> retorno = [];

    for (var obj in data) {
      print(obj.toString());
      if (obj["link"] == "%DireccionarAContacto%") {
        Toast.show("Solicitud de contacto enviada exitosamente", context);
      } else
        retorno.add(new MaterialButton(
          height: 40.0,
          minWidth: 100.0,
          color: Color(0xffDFEDFE),
          textColor: Color(0xff0066D0),
          child: new Text("${obj["text"]}"),
          splashColor: Colors.white,
          onPressed: () {
            setState(() {
              messages.insert(0, {
                "data": 1,
                "message": "${obj["text"]}",
                "options": null,
              });
            });
            makeQuestion("${obj["text"]}");
          },
        ));
    }

    return retorno;
  }
}
