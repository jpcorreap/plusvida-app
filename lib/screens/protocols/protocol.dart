import 'dart:convert';
import 'package:covid_19_app/screens/protocols/book.dart';
import 'package:covid_19_app/screens/protocols/protocol_utils.dart';
import 'package:covid_19_app/screens/widgets_utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Protocol extends StatefulWidget {
  final protocolName;
  final context;

  Protocol({Key key, this.protocolName, this.context}) : super(key: key);

  @override
  _ProtocolState createState() =>
      _ProtocolState(this.protocolName, this.context);
}

class _ProtocolState extends State<Protocol> {
  final protocolName;
  final context;
  var protocolData;
  bool protocolFetched;

  ProtocolUtils pu = ProtocolUtils();

  int currentBook;
  List<Book> books;

  _ProtocolState(this.protocolName, this.context);

  GestureDetector generateListItem(var title, int index) {
    return GestureDetector(
      onTap: () => setState(() {
        currentBook = index;
      }),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: 300,
            child: pu.buildTitle({"text": title, "category": 2})),
        ),
      ),
    );
  }

  List<Widget> generateProtocolMenu() {
    List<Widget> widgets = [
      SizedBox(height: 50.0),
      pu.buildTitle({"text": protocolData["title"], "category": 1}),
    ];

    int index = 0;

    for (var subcategory in protocolData["subcategories"]) {
      widgets.add(generateListItem(subcategory["title"], index));
      index++;
    }

    widgets.add(SizedBox(
      height: 20.0,
    ));

    return widgets;
  }

  void initState() {
    super.initState();
    currentBook = -1;
    protocolData = null;
    protocolFetched = false;
    books = [];
  }

  @override
  Widget build(BuildContext context) {
    if (protocolFetched == false) {
      rootBundle.loadString(protocolName).then((value) {
        setState(() {
          protocolData = jsonDecode(value);
          for (var subcategory in protocolData["subcategories"]) {
            books.add(new Book(data: subcategory, context: this.context));
          }
          protocolFetched = true;
        });
      });
    }

    return protocolFetched == false
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xffdfedfe),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Stack(children: [
                  new Image.asset("assets/background_home.png"),
                  new Center(
                    child: new Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(children: generateProtocolMenu()),
                    ),
                  ),
                  if (currentBook >= 0)
                  Container(
                    width: 500,
                    height: 700,
                    color: Color(0xffDFEDFE),
                  ),
                  new GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  if (currentBook >= 0)
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 60, 15, 50),
                    child: books[currentBook]),
                  if (currentBook >= 0)
                  Container(
                    width: 500,
                    color: Color(0xffDFEDFE),
                    child: Center(
                        child: new MaterialButton(
                          color: Color(0xfff42f63),
                          textColor: Colors.white,
                          child: new Text("Cerrar"),
                          splashColor: Colors.redAccent,
                          onPressed: () => setState(() {
                            currentBook = -1;
                          }),
                        ),
                      ),
                  ),
                ]),
              ),
            ),
          );
  }
}
