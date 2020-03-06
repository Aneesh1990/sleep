import 'package:equatable/equatable.dart';

abstract class ForgotPassState extends Equatable {}

class ForgotPassInitial extends ForgotPassState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ForgotPassLoading extends ForgotPassState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ForgotPassSuccessful extends ForgotPassState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ForgotPassFailure extends ForgotPassState {
  String message;

  ForgotPassFailure(this.message);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
