import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {}

class PlayerPlay extends PlayerEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class PlayerPause extends PlayerEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class PlayerStop extends PlayerEvent {
  List<Object> get props => throw UnimplementedError();
}

class PlayerForward extends PlayerEvent {
  List<Object> get props => throw UnimplementedError();
}

class PlayerBackward extends PlayerEvent {
  List<Object> get props => throw UnimplementedError();
}

class NavigateToBack extends PlayerEvent {
  List<Object> get props => throw UnimplementedError();
}
