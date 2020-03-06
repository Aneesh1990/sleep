import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sleep_giant/data/song_data.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

abstract class HomePageEvent extends Equatable {}

class WindDownEvent extends HomePageEvent {
  final BuildContext context;
  final List<String> songs;

  WindDownEvent(this.context, this.songs);
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SleepDeepEvent extends HomePageEvent {
  final BuildContext context;
  final List<String> songs;

  SleepDeepEvent(this.context, this.songs);
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NapRecoveryEvent extends HomePageEvent {
  final BuildContext context;
  final List<String> songs;

  NapRecoveryEvent(this.context, this.songs);
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class WakeUpEvent extends HomePageEvent {
  final BuildContext context;
  final List<String> songs;

  WakeUpEvent(this.context, this.songs);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NavigateSleepDeck extends HomePageEvent {
  final BuildContext context;
  List<MusicFile> songs;
  FirebaseUser user;
  UserRepository userRepository;

  NavigateSleepDeck(this.context, this.songs, this.user);
  @override
  // TODO: implement props
  List<Object> get props => null;
}
