import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flute_music_player/flute_music_player.dart';

class SongData {
  List<Program> songs;
  int _currentSongIndex = -1;
//  MusicFinder musicFinder;
  SongData({this.songs});

  List<Program> get songsGet => songs;
  int get length => songs.length;
  int get songNumber => _currentSongIndex + 1;

  setCurrentIndex(int index) {
    _currentSongIndex = index;
  }

  int get currentIndex => _currentSongIndex;

  Program get nextSong {
    if (_currentSongIndex < length) {
      _currentSongIndex++;
    }
    if (_currentSongIndex >= length) return null;
    return songs[_currentSongIndex];
  }

  Program get prevSong {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    }
    if (_currentSongIndex < 0) return null;
    return songs[_currentSongIndex];
  }

//  MusicFinder get audioPlayer => musicFinder;
}

//class MusicRecord {
//  // Header members
//
//  final String _name;
//  final List<MusicFile> _program;
//  final int _id;
//
//  MusicRecord(this._name, this._program, this._id);
//  String get name => _name;
//  List<MusicFile> get program => _program;
//}

class MusicFile {
  String documentID;
  String name;
  List<Program> program;

  MusicFile(this.name, this.program);
  MusicFile.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        name = snapshot['name'],
        program = (snapshot['program'] as List).map((i) {
          return Program.fromSnapshot(i);
        }).toList();
}

class Program {
  int id;
  final String name;
  final String songPath;
  final String avatar;
  final int duration;
  final String avatarToken;
  final String songToken;
  String path =
      'https://firebasestorage.googleapis.com/v0/b/zero-gravity-43c3b.appspot.com/o/';

  Program(
      {this.name,
      this.songPath,
      this.avatar,
      this.id,
      this.duration,
      this.avatarToken,
      this.songToken});

  Program.fromSnapshot(Map snapshot)
      : id = snapshot['id'],
        name = snapshot['name'],
        avatar = snapshot['avatar'],
        songPath = snapshot['song_path'],
        duration = snapshot['duration'],
        avatarToken = snapshot['avatar_token'],
        songToken = snapshot['song_token'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['song_path'] = this.songPath;
    data['avatar'] = this.avatar;
    data['id'] = this.id;
    data['avatar_token'] = this.avatarToken;
    data['song_token'] = this.songToken;
    data['duration'] = this.duration;
    return data;
  }
}

class SleepDeckData {
  List<DeckData> decks;
  SleepDeckData({this.decks});
  SleepDeckData.fromSnapshot(DocumentSnapshot snapshot)
      : decks = (snapshot['sleep_deck'] as List).map((i) {
          return DeckData.fromSnapshot(i);
        }).toList();
}

class DeckData {
  int id;
  final String name;
  List<Program> program;

  DeckData({this.name, this.program, this.id});

  DeckData.fromSnapshot(Map snapshot)
      : id = snapshot['id'],
        name = snapshot['name'],
        program = (snapshot['programs'] as List).map((i) {
          return Program.fromSnapshot(i);
        }).toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['programs'] = getJson();
    return data;
  }

  List<Map> getJson() {
    List<Map> list = new List();
    if (program != null && program.isNotEmpty) {
      program.forEach((grp) {
        list.add(grp.toJson());
      });
    }
    return list;
  }
}
