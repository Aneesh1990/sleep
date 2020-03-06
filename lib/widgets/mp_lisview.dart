//import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:sleep_giant/Generic/generic_helper.dart';
import 'package:sleep_giant/Screens/now_playing.dart';
import 'package:sleep_giant/data/song_data.dart';
import 'package:sleep_giant/widgets/mp_circle_avatar.dart';

class MPListView extends StatelessWidget {
  final List<MaterialColor> _colors = Colors.primaries;
  SongData songs;
  final MusicFile snapshot;
  List<Program> list = [];

  MPListView({Key key, this.snapshot}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: snapshot.program == null
          ? Center(child: CircularProgressIndicator())
          : new ListView.builder(
              itemCount: snapshot.program.length,
              itemBuilder: (context, int index) {
                Program s = snapshot.program[index];

                final MaterialColor color = _colors[index % _colors.length];

                return new ListTile(
                  dense: true,
                  leading: new Hero(
                    child: avatar(generic.getImageName(s.avatar, s.avatarToken),
                        s.name + '$index', color),
                    tag: s.name + '$index',
                  ),
                  title: new Text(
                    s.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: new Text(
                    "By ${'Artist'}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    songs = SongData(
                      songs: list,
                    );
                    songs.setCurrentIndex(index);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new NowPlaying(
                                false, songs, s, snapshot, index)));
                  },
                );
              },
            ),
    );
  }
}
