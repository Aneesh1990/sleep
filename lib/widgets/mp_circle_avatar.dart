import 'package:flutter/material.dart';

Widget avatar(String f, String title, MaterialColor color) {
  return new Material(
    borderRadius: new BorderRadius.circular(20.0),
    elevation: 3.0,
    child: f != null
        ? new Image.network(
            f,
            fit: BoxFit.cover,
          )
        : new CircleAvatar(
            child: new Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            backgroundColor: color,
          ),
  );
}
