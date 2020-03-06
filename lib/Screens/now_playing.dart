import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sleep_giant/Generic/generic_helper.dart';
import 'package:sleep_giant/data/song_data.dart';
import 'package:sleep_giant/widgets/mp_album_ui.dart';
import 'package:sleep_giant/widgets/mp_blur_filter.dart';
import 'package:sleep_giant/widgets/mp_blur_widget.dart';
import 'package:sleep_giant/widgets/mp_control_button.dart';

enum PlayerState { stopped, playing, paused, muted }

class NowPlaying extends StatefulWidget {
  Program _song;
  final SongData songData;
  final bool nowPlayTap;
  MusicFile snapshot;
  int index;
  final bool isSleepDeck;

  NowPlaying(
    this.isSleepDeck,
    this.songData,
    this._song,
    this.snapshot,
    this.index, {
    this.nowPlayTap,
  });

  @override
  _NowPlayingState createState() => new _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
//  MusicFinder audioPlayer;
  String localFilePath;
  AudioPlayer _audioPlayer;
  AudioPlayerState audioPlayerState;
  StreamSubscription _positionSubscription;
  StreamSubscription audioPlayerStateSubscription;
  Duration _duration;
  Duration _position;

  get durationText =>
      _duration != null ? _duration.toString().split('.').first : '';
  get positionText =>
      _position != null ? _position.toString().split('.').first : '';

  bool isMuted = false;

  /////////////

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get isPlaying => _playerState == PlayerState.playing;
  get isPaused => _playerState == PlayerState.paused;

  @override
  initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    audioPlayerStateSubscription?.cancel();
    super.dispose();
  }

//  void onComplete() {
//    setState(() => playerState = PlayerState.stopped);
//    play(widget.songData.nextSong);
//  }

  // <editor-fold desc=" Initialize - Player ">
  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // set atleast title to see the notification bar on ios.
        _audioPlayer.setNotification(
            title: 'Sleep Giant',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    audioPlayerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => audioPlayerState = state);
    });
    play(generic.getSongName(widget._song.songPath, widget._song.songToken));
  }
  // </editor-fold>

  @override
  Widget build(BuildContext context) {
    // print(_playerState);

    Widget _buildPlayer() => new Container(
        padding: new EdgeInsets.all(10.0),
        child: SafeArea(
          child: new Column(mainAxisSize: MainAxisSize.min, children: [
            new Column(
              children: <Widget>[
                new Text(
                  widget._song.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .apply(color: Colors.white),
                ),
                new Text(
                  'Artist',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .apply(color: Colors.white),
                ),
              ],
            ),
            new Row(mainAxisSize: MainAxisSize.min, children: [
              new ControlButton(Icons.fast_rewind, () {
                final position = _position.inMilliseconds - 10000;
                _audioPlayer.seek(Duration(milliseconds: position.round()));
              }),
              new ControlButton(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  isPlaying
                      ? () => pause()
                      : () => play(generic.getSongName(
                          widget._song.songPath, widget._song.songToken))),
              new ControlButton(Icons.fast_forward, () {
                final position = _position.inMilliseconds + 10000;
                _audioPlayer.seek(Duration(milliseconds: position.round()));
              }),
            ]),
            new Slider(
              onChanged: (v) {
                final position = v * _duration.inMilliseconds;
                _audioPlayer.seek(Duration(milliseconds: position.round()));
              },
              value: (_position != null &&
                      _duration != null &&
                      _position.inMilliseconds > 0 &&
                      _position.inMilliseconds < _duration.inMilliseconds)
                  ? _position.inMilliseconds / _duration.inMilliseconds
                  : 0.0,
            ),
            new Row(mainAxisSize: MainAxisSize.min, children: [
              new Text(
                  _position != null
                      ? "${positionText ?? ''} / ${durationText ?? ''}"
                      : _duration != null ? durationText : '',
                  // ignore: conflicting_dart_import
                  style: new TextStyle(fontSize: 24.0, color: Colors.white))
            ]),
            new Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new IconButton(
                    icon: isMuted
                        ? new Icon(Icons.headset, color: Colors.white)
                        : new Icon(Icons.headset_off, color: Colors.white),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        isMuted = !isMuted;
                      });
                      mute(isMuted);
                    }),
                // new IconButton(
                //     onPressed: () => mute(true),
                //     icon: new Icon(Icons.headset_off),
                //     color: Colors.cyan),
                // new IconButton(
                //     onPressed: () => mute(false),
                //     icon: new Icon(Icons.headset),
                //     color: Colors.cyan),
              ],
            ),
          ]),
        ));

    var playerUI = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new AlbumUI(widget._song, _duration, _position),
          new Material(
            child: _buildPlayer(),
            color: Colors.transparent,
          ),
        ]);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: new Container(
        color: Colors.transparent,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[blurWidget(widget._song), blurFilter(), playerUI],
        ),
      ),
    );
  }

  // <editor-fold desc=" Player play handler ">

  Future<int> play(String url) async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result =
        await _audioPlayer.play(url, isLocal: false, position: playPosition);
    if (result == 1)
      setState(() {
        _playerState = PlayerState.playing;
      });

    // TODO implemented for iOS, waiting for android impl
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // default playback rate is 1.0
      // this should be called after _audioPlayer.play() or _audioPlayer.resume()
      // this can also be called everytime the user wants to change playback rate in the UI
      _audioPlayer.setPlaybackRate(playbackRate: 1.0);
    }

    return result;
  }
  // </editor-fold>

  // <editor-fold desc=" Player pause handler ">

  Future<int> pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }
  // </editor-fold>

  // <editor-fold desc=" Player stop handler">

  Future<int> stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }
  // </editor-fold>

  Future<int> mute(bool isMute) async {
    final result = await _audioPlayer.setVolume(isMute ? 0 : 1);
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.muted;
//        _position = Duration();
      });
    }
    return result;
  }

  // <editor-fold desc=" player on complete state ">

  void _onComplete() {
    setState(() {
      if (widget.isSleepDeck) {
        widget.index++;
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
        if (widget.songData.songs.length > widget.index) {
          widget._song = widget.songData.songs[widget.index];
          play(generic.getSongName(widget.songData.songs[widget.index].songPath,
              widget.songData.songs[widget.index].songToken));
        }
      } else {}
    });
  }
// </editor-fold desc=>
}
