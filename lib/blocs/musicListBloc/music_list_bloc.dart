import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_giant/blocs/musicListBloc/music_list_event.dart';
import 'package:sleep_giant/blocs/musicListBloc/music_list_state.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

class MusicListBloc extends Bloc<MusicListState, MusicListEvent> {
  UserRepository userRepository;
  MusicListBloc({@required UserRepository userRepository}) {
    this.userRepository = userRepository;
  }
  @override
  // TODO: implement initialState
  MusicListEvent get initialState => throw UnimplementedError();

  @override
  Stream<MusicListEvent> mapEventToState(MusicListState event) {
    // TODO: implement mapEventToState
    if (event is GetMusicList) {
      userRepository.getMusicData();
    } else if (event is NavigateToPlayer) {
      LoadPlayer();
    }
  }
}
