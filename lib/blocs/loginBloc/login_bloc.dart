//import 'package:bloc/bloc.dart';
//import 'package:meta/meta.dart';
//import 'package:sleep_giant/Screens/Login/login_page.dart';
//import 'package:sleep_giant/blocs/authBloc/auth_event.dart';
//import 'package:sleep_giant/blocs/loginBloc/login_event.dart';
//import 'package:sleep_giant/blocs/loginBloc/login_state.dart';
//import 'package:sleep_giant/repositories/user_repository.dart';
//
//class LoginBloc extends Bloc<LoginEvent, LoginState> {
//  UserRepository userRepository;
//
//  LoginBloc({@required UserRepository userRepository}) {
//    this.userRepository = userRepository;
//  }
//
//  @override
//  // TODO: implement initialState
//  LoginState get initialState => LoginInitialState();
//
////  @override
//  Stream<LoginState> mapEventToState(AuthEvent event) async* {
//    if (event is LoginButtonPressed) {
//      yield LoginLoadingState();
//      try {
//        var user = await userRepository.signInEmailAndPassword(
//            event.email, event.password);
//        yield LoginSuccessState(user);
//      } catch (e) {
//        yield LoginFailState(e.toString());
//      }
//    } else if (event is SendButtonPageShow) {
//      yield NavigateState();
//    }
//  }
//}
