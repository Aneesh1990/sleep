import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_giant/blocs/PlayerBloc/player_event.dart';
import 'package:sleep_giant/blocs/PlayerBloc/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  @override
  // TODO: implement initialState
  PlayerState get initialState => throw UnimplementedError();

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event) {
    // TODO: implement mapEventToState
    if (event is PlayerPlay) {
    } else if (event is PlayerPause) {
    } else if (event is PlayerStop) {
    } else if (event is PlayerForward) {
    } else if (event is PlayerBackward) {
    } else if (event is NavigateToBack) {}
  }
}
