import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sleep_giant/Style/validator.dart';
import 'package:sleep_giant/blocs/authBloc/auth_event.dart';
import 'package:sleep_giant/blocs/authBloc/auth_state.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserRepository userRepository;

  AuthBloc({@required UserRepository userRepository}) {
    this.userRepository = userRepository;
  }
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get email =>
      _emailController.stream.transform(Validators().validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(Validators().validatePassword);

  // change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  submit() {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;

    print('Email is $validEmail, and password is $validPassword');
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
  }

  @override
  // TODO: implement initialState
  AuthState get initialState => AuthInitialState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStartedEvent) {
      try {
        var isSignedIn = await userRepository.isSignedIn();
        if (isSignedIn) {
          var user = await userRepository.getCurrentUser();
          yield AuthenticatedState(user);
        } else {
          yield UnauthenticatedState();
        }
      } catch (e) {
        yield UnauthenticatedState();
      }
    } else if (event is LoginButtonPressed) {
      yield LoginLoadingState();
      try {
        var user = await userRepository.signInEmailAndPassword(
            event.email, event.password);
        yield LoginSuccessState(user);
      } catch (e) {
        yield LoginFailState(e.toString());
      }
    } else if (event is SendButtonPageShow) {
      yield NavigateState();
    } else if (event is SignUpButtonPressedregpage) {
      yield UserRegLoading();
      try {
        var user = await userRepository.signUpUserWithEmailPass(
            event.email, event.password, event.name);
        yield UserRegSuccessful(user);
      } catch (e) {
        yield UserRegFailure(e.toString());
      }
    }
  }
}
