import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  final String appBarTitle;
  final Widget body;
  InfoScreen(this.appBarTitle, this.body);

  @override
  _InfoScreenState createState() =>
      new _InfoScreenState(this.appBarTitle, this.body);
}

class _InfoScreenState extends State<InfoScreen> {
  String appBarTitle;
  Widget body;

  _InfoScreenState(this.appBarTitle, this.body);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdfedfe),
      appBar: AppBar(
        title: Text(
          '${this.appBarTitle}',
          style: TextStyle(
              fontFamily: "Hind", fontSize: 22, color: Color(0xffdfedfe)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff1E3E65),
      ),
      body: SingleChildScrollView(
        child: new Center(
          child: new Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: this.body,
          ),
        ),
      ),
    );
  }
}
