import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  var color;

  @override
  void initState() {
    super.initState();
    color = Colors.black;
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
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
        child: SlideTransition(
          position: _offsetAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => changeColor(Colors.red),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.red,
                ),
              ),
              GestureDetector(
                onTap: () => changeColor(Colors.orange),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.orange,
                ),
              ),
              GestureDetector(
                onTap: () => changeColor(Colors.yellow),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.yellow,
                ),
              ),
              GestureDetector(
                onTap: () => changeColor(Colors.green),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  changeColor(MaterialColor newColor) {
    setState(() {
      this.color = newColor;
    });
  }
}
