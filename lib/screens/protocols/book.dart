import 'package:covid_19_app/screens/protocols/protocol_utils.dart';
import 'package:flutter/material.dart';

class Book extends StatefulWidget {
  final data;
  final context;

  Book({Key key, this.data, this.context}) : super(key: key);

  @override
  _BookState createState() => _BookState(this.data, this.context);
}

class _BookState extends State<Book> {
  final data;
  final context;
  List pages;

  _BookState(this.data, this.context);

  int index;

  void initState() {
    super.initState();
    index = 0;
    pages = ProtocolUtils().buildPages(data["book"], data["title"]);

/*
    List<Widget> widgets = [
      SizedBox(height: 20.0),
      ProtocolUtils().buildTitle({"text": data["title"], "category": 1}),
      //Text("\n\n${data["book"]}"),
    ];

    ProtocolUtils().buildBook(widgets, data["book"], pages);
    widgets.add(Text("PÁG ${index + 1}", style: TextStyle(fontSize: 25.0)));
    widgets.add(createNavButtons());
    widgets.add(SizedBox(height: 6.0));
    */

    print("\n\n>>> Entró a crear un libro nuevooo: " + data["title"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          new Center(
            child: new Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  child: showPage(index),
                )),
          ),
          if( pages.length > 1 )
          createNavButtons()
        ],
      ),
    );
  }

  showPage(int index) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(15),
        child: Column(children: pages[index]));
  }

  Widget createNavButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (index != 0)
          new MaterialButton(
              height: 40.0,
              minWidth: 90.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Anterior"),
              splashColor: Colors.redAccent,
              onPressed: () => setState(() {
                    index = index - 1;
                  })),
        Text("        ${index + 1}/${pages.length}        "),
        if (index > 0 && index < pages.length)
          SizedBox(
            width: 10.0,
          ),
        if (index < pages.length - 1)
          new MaterialButton(
              height: 40.0,
              minWidth: 90.0,
              color: Color(0xfff42f63),
              textColor: Colors.white,
              child: new Text("Siguiente"),
              splashColor: Colors.redAccent,
              onPressed: () => setState(() {
                    index = index + 1;
                  })),
      ],
    );
  }
}
