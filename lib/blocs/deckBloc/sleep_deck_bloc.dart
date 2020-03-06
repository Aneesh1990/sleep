import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_giant/blocs/deckBloc/sleep_deck_event.dart';
import 'package:sleep_giant/blocs/deckBloc/sleep_deck_state.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

class SleepDeckBloc extends Bloc<SleepDeckState, SleepDeckEvent> {
  UserRepository userRepository;

  SleepDeckBloc({@required UserRepository userRepository}) {
    this.userRepository = userRepository;
  }
  @override
  // TODO: implement initialState
  SleepDeckEvent get initialState => throw UnimplementedError();

  @override
  Stream<SleepDeckEvent> mapEventToState(SleepDeckState event) async* {
    // TODO: implement mapEventToState
    if (event is SleepDeckAddSong) {
      SleepDeckSongAddedState();
    } else if (event is SleepDeckRemoveSong) {
      SleepDeckSongRemovedState();
    } else if (event is CreateDeck) {
      SleepDeckUpdatedState();
    } else if (event is GetData) {}
  }
}
