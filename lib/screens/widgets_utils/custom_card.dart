import "package:flutter/material.dart";

/// Custom card class
class CustomCard {
  create(text, onTapFunction) {
    return GestureDetector(
        onTap: onTapFunction,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Color(0xff439AFF),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            alignment: Alignment.center,
            width: 250.0,
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: "Lato",
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ));
  }
}
