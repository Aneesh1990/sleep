//import 'package:bloc/bloc.dart';
//import 'package:meta/meta.dart';
//import 'package:sleep_giant/blocs/regBloc/user_reg_event.dart';
//import 'package:sleep_giant/blocs/regBloc/user_reg_state.dart';
//import 'package:sleep_giant/repositories/user_repository.dart';
//
//class UserRegBloc extends Bloc<UserRegEvent, UserRegState> {
//  UserRepository userRepository;
//
//  UserRegBloc({@required UserRepository userRepository}) {
//    this.userRepository = userRepository;
//  }
//
//  @override
//  // TODO: implement initialState
//  UserRegState get initialState => UserRegInitial();
//
//  @override
//  Stream<UserRegState> mapEventToState(UserRegEvent event) async* {
////    if (event is SignUpButtonPressedregpage) {
////      yield UserRegLoading();
////      try {
////        var user = await userRepository.signUpUserWithEmailPass(
////            event.email, event.password, event.name);
////        yield UserRegSuccessful(user);
////      } catch (e) {
////        yield UserRegFailure(e.toString());
////      }
////    }
//  }
//}
