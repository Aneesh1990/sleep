import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class AuthenticatedState extends AuthState {
  FirebaseUser user;

  AuthenticatedState(@required this.user);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class UnauthenticatedState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginInitialState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginLoadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NavigateState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LoginSuccessState extends AuthState {
  FirebaseUser user;

  LoginSuccessState(@required this.user);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginFailState extends AuthState {
  String message;

  LoginFailState(@required this.message);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ForgotPassInitial extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ForgotPassLoading extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ForgotPassSuccessful extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ForgotPassFailure extends AuthState {
  String message;

  ForgotPassFailure(this.message);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UserRegInitial extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UserRegLoading extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UserRegSuccessful extends AuthState {
  FirebaseUser user;

  UserRegSuccessful(this.user);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UserRegFailure extends AuthState {
  String message;

  UserRegFailure(this.message);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
