import 'package:equatable/equatable.dart';

abstract class SleepDeckEvent extends Equatable {}

class SleepDeckAddSong extends SleepDeckEvent {
  final String songUrl;
  SleepDeckAddSong({this.songUrl});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SleepDeckRemoveSong extends SleepDeckEvent {
  final String songUrl;
  SleepDeckRemoveSong({this.songUrl});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CreateDeck extends SleepDeckEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DeleteDeck extends SleepDeckEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetData extends SleepDeckEvent {
  final String userId;

  GetData({this.userId});

  @override
  // TODO: implement props
  List<Object> get props => null;
}
