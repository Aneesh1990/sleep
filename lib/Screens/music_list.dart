import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_giant/blocs/musicListBloc/music_list_bloc.dart';
import 'package:sleep_giant/data/song_data.dart';
import 'package:sleep_giant/repositories/user_repository.dart';
import 'package:sleep_giant/widgets/mp_lisview.dart';

class MusicListParent extends StatelessWidget {
  final UserRepository userRepository;
  final SongData songs;
  final String programTypeHeader;
  final MusicFile snapshot;
  const MusicListParent(
      {Key key,
      this.songs,
      this.programTypeHeader,
      this.userRepository,
      this.snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicListBloc(userRepository: userRepository),
      child: RootPage(
        userRepository: userRepository,
        songs: songs,
        snapshot: snapshot,
        programTypeHeader: programTypeHeader,
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  String programTypeHeader;
  UserRepository userRepository;
  MusicFile snapshot;
  SongData songs;
  RootPage(
      {this.userRepository, this.songs, this.snapshot, this.programTypeHeader});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(programTypeHeader),
        backgroundColor: Colors.transparent,
      ),
      // drawer: new MPDrawer(),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/theme_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Scrollbar(
            child: new MPListView(
          snapshot: snapshot,
        )),
      ),
    );
  }

//  SongData getSongs(){
//    List<Song> songs = snapshot.data.forEach((f));
//    return SongData(
//      songs:
//    )
//  }
}
