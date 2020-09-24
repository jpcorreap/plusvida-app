import 'package:flutter/material.dart';

class ProtocolPage extends StatelessWidget {
  final data;

  const ProtocolPage({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 125.0,
              child: Image.asset("assets/design_icons/jabon.png"),
            ),
            SizedBox(
              width: 15.0,
            ),
            Container(
              width: 125.0,
              child: Image.asset("assets/design_icons/desinfectante.png"),
            ),
          ],
        ),
        SizedBox(
          height: 25.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 125.0,
              child: Image.asset("assets/design_icons/alcohol_70.png"),
            ),
            SizedBox(
              width: 15.0,
            ),
            Container(
              width: 125.0,
              child: Image.asset("assets/design_icons/alcohol_glicerinado.png"),
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }
}
