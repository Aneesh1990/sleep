import 'package:flutter/material.dart';
import 'package:sleep_giant/Generic/generic_helper.dart';
import 'package:sleep_giant/data/song_data.dart';

Widget blurWidget(Program song) {
//  var f = song.avatar == null ? null : new File.fromUri(Uri.parse(song.avatar));
  return new Hero(
    tag: song.songPath,
    child: new Container(
      child: song.avatar != null
          // ignore: conflicting_dart_import
          ? new Image.network(
              generic.getImageName(song.avatar, song.avatarToken),
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            )
          : new Image(
              image: new AssetImage("assets/lady.jpeg"),
              color: Colors.black54,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
            ),
    ),
  );
}
