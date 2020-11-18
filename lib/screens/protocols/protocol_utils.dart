import 'package:flutter/material.dart';

class ProtocolUtils {
  Container buildTitle(data) {
    Text retornar;

    switch (data["category"]) {
      case 1:
        retornar = Text(
          "${data["text"]}\n",
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff1E3E65)),
          textAlign: TextAlign.center,
        );
        break;
      case 2:
        retornar = Text(
          "${data["text"]}",
          style: TextStyle(fontSize: 20.0, fontFamily: "Lato"),
          textAlign: TextAlign.center,
        );
        break;
      case 3:
        retornar = Text(
          "${data["text"]}",
          style: TextStyle(
            fontSize: 23.0,
            fontFamily: "Lato",
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
        break;
      case 4:
        retornar = Text(
          "${data["text"]}",
          style: TextStyle(fontSize: 20.0, fontFamily: "Lato"),
          textAlign: TextAlign.center,
        );
        break;
    }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0), child: retornar);
  }

  Widget buildText(data) {
    return Text(
      "\n${data["text"]}\n",
      style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff1E3E65)),
      textAlign: TextAlign.center,
    );
  }

  Container buildSimpleText(data, bool fullWidth) {
    return Container(
        width: !fullWidth ? 300 : 140,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            "${data["text"]}",
            style: TextStyle(fontSize: 15, fontFamily: "Lato"),
            textAlign: TextAlign.left,
          ),
        ));
  }

  Container buildBoldText(data) {
    return Container(
        width: 240,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "${data["text"]}",
            style: TextStyle(
                fontSize: 15, fontFamily: "Lato", fontWeight: FontWeight.bold),
            textAlign: TextAlign.justify,
          ),
        ));
  }

  List<List> buildPages(bookData, categoryName) {
    List<List> pages = [];

    bookData.forEach((page) {
      List<Widget> newPage = buildPage(page, categoryName);
      pages.add(newPage);
    });

    return pages;
  }

  List<Widget> renderChildren(children) {
    List<Widget> anexar = [];
    for (var child in children) {
      anexar.add(buildItem(child, true));
    }
    return anexar;
  }

  buildRow(data) {
    return Row(
      children: renderChildren(data["children"]),
    );
  }

  buildImportant(data) {
    List<Widget> widgets = [];

    for (var child in data["children"]) {
      widgets.add(buildItem(child, false));
    }

    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text("IMPORTANTE",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 25.0,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.normal)),
        ),
        Container(
          color: Color(0xffDFEDFE),
          child: Column(
            children: widgets,
          ),
        ),
      ]),
    );
  }

  Container buildImage(data) {
    print(data);
    return new Container(
        margin: EdgeInsets.only(left: 10.0),
        width: 100.0,
        height: 100.0,
        child: Image.network(data["src"]));
  }

  Widget buildItem(item, bool fullWidth) {
    Widget retornar = Text("${item.toString()}\n\n");

    if (item["type"] == "title") {
      retornar = buildTitle(item);
    } else if (item["type"] == "row") {
      retornar = buildRow(item);
    } else if (item["type"] == "image") {
      retornar = buildImage(item);
    } else if (item["type"] == "text") {
      retornar = buildSimpleText(item, fullWidth);
    } else if (item["type"] == "bold") {
      retornar = buildBoldText(item);
    } else if (item["type"] == "important") {
      retornar = buildImportant(item);
    }

    return retornar;
  }

  List<Widget> buildPage(page, categoryName) {
    List<Widget> pageWidgets = [
      SizedBox(height: 20.0),
      ProtocolUtils().buildTitle({"text": categoryName, "category": 1}),
    ];

    try {
      for (var item in page) {
        Widget agregar = buildItem(item, false);

        pageWidgets.add(agregar);
        pageWidgets.add(SizedBox(
          height: 20.0,
        ));
      }
    } on Exception catch (e) {
      print("ERROR CON LA PÁGINA " + page.toString());
      print(e);
      pageWidgets = [Text("Error con la página ${page.toString()}")];
    }

    return pageWidgets;
  }
}
