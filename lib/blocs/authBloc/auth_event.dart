import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class AuthEvent extends Equatable {}

class AppStartedEvent extends AuthEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginButtonPressed extends AuthEvent {
  String email, password;

  LoginButtonPressed({this.email, this.password});

  @override
  // TODO: implement props
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class SignUpButtonPressed extends AuthEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SignUpButtonPressedregpage extends AuthEvent {
  String email, password, name;

  SignUpButtonPressedregpage({this.email, this.password, this.name});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EmailChanged extends AuthEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends AuthEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class SendButtonPageShow extends AuthEvent {
  String email;

  SendButtonPageShow({this.email});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
