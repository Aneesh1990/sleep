import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sleep_giant/Screens/Register/signup_page.dart';
import 'package:sleep_giant/Screens/sleep_deck.dart';
import 'package:sleep_giant/blocs/homeBloc/home_page_event.dart';
import 'package:sleep_giant/blocs/homeBloc/home_page_state.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  UserRepository userRepository;

  HomePageBloc({@required UserRepository userRepository}) {
    this.userRepository = userRepository;
  }

  @override
  // TODO: implement initialState
  HomePageState get initialState => LogOutInitial();

  Future<QuerySnapshot> getMusics() => userRepository.getMusicData();

//  Future<DocumentSnapshot> getSleepDeck(String id) =>
//      userRepository.getSleepDeckData(id);

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is WakeUpEvent) {
      BuildContext context = event.context;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SignUpPageParent(userRepository: userRepository);
      }));
    } else if (event is WindDownEvent) {
      BuildContext context = event.context;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SignUpPageParent(userRepository: userRepository);
      }));
    } else if (event is NavigateSleepDeck) {
      BuildContext context = event.context;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SleepDeckParent(
          userRepository: event.userRepository,
          musicList: event.songs,
          user: event.user,
        );
      }));
    } else if (event is NapRecoveryEvent) {
      BuildContext context = event.context;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SignUpPageParent(userRepository: userRepository);
      }));
    }
  }

  //Convert map to goal list

}
