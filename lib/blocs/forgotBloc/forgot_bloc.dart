import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sleep_giant/blocs/forgotBloc/forgot_event.dart';
import 'package:sleep_giant/blocs/forgotBloc/forgot_state.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {
  UserRepository userRepository;

  ForgotPassBloc({@required UserRepository userRepository}) {
    this.userRepository = userRepository;
  }
  @override
  // TODO: implement initialState
  ForgotPassState get initialState => ForgotPassInitial();

  @override
  Stream<ForgotPassState> mapEventToState(ForgotPassEvent event) async* {
    // TODO: implement mapEventToState
    if (event is SendButtonPressed) {
      yield ForgotPassLoading();
      try {
        var response = await userRepository.resetPassword(event.email);
        yield ForgotPassSuccessful();
      } catch (e) {
        yield ForgotPassFailure(e.toString());
      }
    }
  }
}
